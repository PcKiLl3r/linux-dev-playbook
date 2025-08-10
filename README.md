## How To Setup Env
1. Install dependencies:
    ```
    sudo dnf install git ansible
    ```
2. Make personal dir
    ```
    mkdir personal
    cd personal
    ```
3. Clone repo:
    ```
    git clone https://github.com/PcKiLl3r/linux-dev-playbook
    cd linux-dev-playbook
    ```
4. Create Ansible Vault password file:
    ```
    vi vault/vault_pass.txt
    ```
5. Run Ansible setup script:
    ```
    make run
    ```

### Inventory
This playbook runs against `localhost`, so no inventory file is needed. Ansible uses its default inventory when executing `main.yml`.

## Linting and tests
Run the linting tools and install role requirements before invoking any of the Makefile targets:
```bash
make install
```
After the dependencies are installed you can run the usual checks:
```bash
make lint
make test
```

### Makefile commands
The Makefile exposes several common development tasks:

- `make run` – Execute the main Ansible playbook (uses `vault/vault_pass.txt` by default)
- `make lint` – Run yamllint, ansible-playbook syntax check, and ansible-lint
- `make test` – Run linting and Molecule tests
- `make converge` – Run linting and Molecule converge
- `make install` – Install lint tools and Ansible requirements
- `make install-lint` – Install all linting tools
- `make install-requirements` – Install Ansible roles and collections
- `make clean` – Clean up temporary files
- `make all` – Run linting, syntax checks, and Molecule tests
- `make help` – List available commands

## Todo
Make a script hosted on web to allow usage like:
```
curl https://dev.todo.com | sh
```

```
mkdir personal
cd personal
curl https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | sh
```
