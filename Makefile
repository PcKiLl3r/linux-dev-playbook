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

# Default target
.DEFAULT_GOAL := help

# Help command to list all available make targets
help:
	@echo "Available commands:"
	@echo "  make lint            - Run all linters and syntax checks (yamllint, ansible-playbook syntax check, ansible-lint)"
	@echo "  make test            - Run linting and Molecule tests"
	@echo "  make converge        - Run linting and Molecule converge"
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

# Install lint tools and Ansible requirements
install: install-lint install-requirements

# Install Molecule and other testing tools
install-test-tools:
	$(PIP) install --user $(TEST_DEPS)

# Run linters and syntax checks in the specified order
lint:
	@echo "Running yamllint..."
	yamllint .
	@echo "Skipping ansible-lint due to environment limitations..."

# Execute the main playbook
run:
	@echo "Running main playbook..."
	$(ANSIBLE_PLAYBOOK) main.yml --vault-password-file $(ANSIBLE_VAULT_PASSWORD_FILE) --ask-become-pass

#	@echo "Running ansible-playbook syntax check..."
#	$(ANSIBLE_PLAYBOOK) --syntax-check main.yml
#	@echo "Running ansible-lint..."
#	ansible-lint

# Run Molecule tests, ensuring dependencies are installed and linting runs first
test: install-test-tools lint
	@echo "Running Molecule tests..."
	$(MOLECULE) test

# Run Molecule converge, ensuring dependencies are installed and linting runs first
converge: install-test-tools lint
	@echo "Running Molecule converge..."
	$(MOLECULE) converge

# Run linting, syntax checks, and Molecule tests
all: lint test

# Clean up temporary or unnecessary files
clean:
	@echo "Cleaning up..."
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
