# Variables

PYTHON = python3
PIP = $(PYTHON) -m pip
MOLECULE = molecule
ANSIBLE_PLAYBOOK = ansible-playbook
ANSIBLE_GALAXY = ansible-galaxy
LINT_TOOLS = yamllint ansible-lint
ANSIBLE_VAULT_PASSWORD_FILE ?= $(CURDIR)/.ansible_vault_pass
export ANSIBLE_VAULT_PASSWORD_FILE
TEST_DEPS = molecule molecule-plugins[docker] yamllint ansible-lint

# Default preset for testing
PRESET ?= ideapad_330

# Default target
.DEFAULT_GOAL := help

# Help command to list all available make targets
help:
	@echo "Available commands:"
	@echo "  make lint            - Run all linters and syntax checks (yamllint, ansible-playbook syntax check, ansible-lint)"
	@echo "  make test            - Run linting and Molecule tests"
	@echo "  make test-nodestr    - Run linting and Molecule tests without destroying instances"
	@echo "  make converge        - Run linting and Molecule converge"
	@echo "  make converge-at     - Converge but start at a specific task (use START_AT=\"...\")"
	@echo "  make run             - Execute the main Ansible playbook"
	@echo "  make install         - Install lint tools and Ansible requirements"
	@echo "  make install-lint    - Install all linting tools"
	@echo "  make install-requirements - Install Ansible roles and collections"
	@echo "  make clean           - Clean up temporary files"
	@echo "  make all             - Run linting, syntax checks, and Molecule tests"

# Install all linting tools
install-lint:
	@echo "Installing linting tools..."
	$(PIP) install $(LINT_TOOLS)

# Install Ansible roles and collections
install-requirements:
	@echo "Installing Ansible roles and collections..."
	$(ANSIBLE_GALAXY) install -r requirements.yml
	$(ANSIBLE_GALAXY) collection install -r collections/requirements.yml -p ./collections

# Install lint tools and Ansible requirements
install: install-lint install-requirements

# Install Molecule and other testing tools
install-test-tools:
	$(PIP) install --user $(TEST_DEPS)

# Run linters and syntax checks in the specified order
lint: install-requirements
	@echo "Running yamllint..."
	yamllint .
	@echo "Running ansible-lint..."
	ansible-lint main.yml tasks/

# Run the main playbook with preset
run:
	@if [ -z "$(PRESET)" ]; then \
		echo "Error: PRESET must be specified. Usage: make run PRESET=thinkpad_t16_gen2"; \
		exit 1; \
	fi
	PRESET=$(PRESET) ansible-playbook main.yml --vault-password-file .ansible_vault_pass --ask-become-pass

# Run tests with preset
test: install-test-tools lint
	@echo "Running Molecule tests with preset: $(PRESET)"
	MOLECULE_MACHINE_PRESET=$(PRESET) $(MOLECULE) test

# Run converge with preset
converge: install-test-tools lint
	@echo "Running Molecule converge with preset: $(PRESET)"
	MOLECULE_MACHINE_PRESET=$(PRESET) $(MOLECULE) converge

#	@echo "Running ansible-playbook syntax check..."
#	$(ANSIBLE_PLAYBOOK) --syntax-check main.yml
#	@echo "Running ansible-lint..."
#	ansible-lint

# Run Molecule tests without destroying instances
test-nodestr: install-test-tools lint
	@echo "Running Molecule tests without destroying instances..."
	$(MOLECULE) test --destroy=never

# Optional: scenario pass-through: use with SCENARIO=<name>
SCEN_ARG := $(if $(SCENARIO),-s $(SCENARIO),)

# Converge starting at an arbitrary task name
.PHONY: converge-at
converge-at: install-test-tools lint
	@test -n "$(START_AT)" || (echo "ERROR: Provide START_AT=\"<task name>\"" && exit 1)
	@echo "Running Molecule converge starting at '$(START_AT)'..."
	$(MOLECULE) converge $(SCEN_ARG) -- --start-at-task "$(START_AT)"

# Run linting, syntax checks, and Molecule tests
all: lint test

# Clean up temporary or unnecessary files
clean:
	@echo "Cleaning up..."
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
	@$(MAKE) molecule-ps

# Check for lingering Molecule containers
molecule-ps:
	@./scripts/molecule-ps.sh
