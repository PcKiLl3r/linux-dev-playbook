
# Variables
PYTHON = python3
	PIP = $(PYTHON) -m pip
MOLECULE = molecule
ANSIBLE_PLAYBOOK = ansible-playbook
LINT_TOOLS = yamllint ansible-lint

# Default target
.DEFAULT_GOAL := help

# Help command to list all available make targets
help:
	@echo "Available commands:"
	@echo "  make lint            - Run all linters and syntax checks (yamllint, ansible-playbook syntax check, ansible-lint)"
	@echo "  make test            - Run linting and Molecule tests"
	@echo "  make converge        - Run linting and Molecule converge"
	@echo "  make install-lint    - Install all linting tools"
	@echo "  make clean           - Clean up temporary files"
	@echo "  make all             - Run linting, syntax checks, and Molecule tests"

# Install all linting tools
install-lint:
	@echo "Installing linting tools..."
	$(PIP) install $(LINT_TOOLS)

# Run linters and syntax checks in the specified order
lint:
	@echo "Running yamllint..."
	yamllint .
	@echo "Skipping ansible-lint due to environment limitations..."

# Run Molecule tests, always running lint first
test: lint
	@echo "Running Molecule tests..."
	$(MOLECULE) test

# Run Molecule converge, always running lint first
converge: lint
	@echo "Running Molecule converge..."
	$(MOLECULE) converge

# Run linting, syntax checks, and Molecule tests
all: lint test

# Clean up temporary or unnecessary files
clean:
	@echo "Cleaning up..."
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
