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
ansible-playbook main.yml -e machine=thinkpad_t16_gen2 --vault-password-file vault_pass.txt --ask-become-pass
```

### Machine presets
Machine-specific defaults live in the `machines/` directory. Each file contains
all variables that can be tuned for a particular host. Two examples are
included:

- `thinkpad_t16_gen2.yml` – uses **Hyprland** as the default window manager.
- `thinkpad_x240.yml` – uses **i3** as the default window manager.

To add a new machine, copy one of these files, adjust any variables (such as
`window_manager`, `use_on_tv`, or `restore_last_ssh`), and pass the new machine
name with the `machine` extra variable:

```bash
ansible-playbook main.yml -e machine=my_new_host --vault-password-file vault_pass.txt --ask-become-pass
```

### Molecule testing
Each machine has a matching Molecule scenario. Install Molecule and the Docker
driver first:

```bash
pip install molecule molecule-plugins[docker]
```

Run the tests or converge steps with the scenario name to validate your settings
in a container:

```bash
molecule test -s thinkpad_t16_gen2
molecule test -s thinkpad_x240
# Or converge only
molecule converge -s thinkpad_t16_gen2
```

### Inventory
This playbook runs against `localhost`, so no inventory file is needed. Ansible uses its default inventory when executing `main.yml`.

## Linting and tests
Run the linting tools before invoking any of the Makefile targets:
```bash
make install-lint
```
After the tools are installed you can run the usual checks:
```bash
make lint
make test
```

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
