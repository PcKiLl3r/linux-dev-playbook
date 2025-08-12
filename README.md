## How To Setup Env
1. Install dependencies and clone the repo using the provided setup script:
    ```bash
    curl -L https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | OS_OVERRIDE=<your_os> bash
    ```
    The `OS_OVERRIDE` environment variable is optional and allows you to force a distribution when autodetection fails. Valid values are `arch` (for Arch Linux and derivatives such as Manjaro) and `fedora`.

### Running on minimal Fedora
On a minimal Fedora installation, install the required packages first:

```bash
sudo dnf install -y ansible git
```

Then clone the repository and run the playbook:

```bash
git clone https://github.com/PcKiLl3r/linux-dev-playbook
cd linux-dev-playbook
cp config.template.yml config.yml
ansible-playbook main.yml --vault-password-file .ansible_vault_pass -e os_override=fedora --ask-become-pass
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
    vi .ansible_vault_pass
    ```
5. Create a vault file for your Bluetooth device addresses:
    ```bash
    ansible-vault edit vault/bluetooth.yml --vault-password-file .ansible_vault_pass
    ```
    Example content:
    ```yaml
    bluetooth_macs:
      - "AA:BB:CC:DD:EE:FF"  # Kinesis keyboard
      - "11:22:33:44:55:66"  # Sony headset
      - "22:33:44:55:66:77"  # Logitech TKL keyboard
    ```

6. Edit `config.yml` to customise which browsers are installed or to override OS detection.
7. Run the playbook manually if desired:
    ```bash
    ansible-playbook main.yml --vault-password-file .ansible_vault_pass --ask-become-pass
    ```
    make run
    ```

### Bootstrap script
Use the helper script to apply secrets and dotfiles:
```bash
./scripts/bootstrap.sh
```
The script prompts for your Ansible Vault passphrase, runs the playbook, and re-encrypts vault files.

### Configuration
Copy `config.template.yml` to `config.yml` and adjust values as needed:

```bash
cp config.template.yml config.yml
```

Key options available in the configuration file:

- `os_override`: force a specific distribution instead of auto-detection. Supported values: `arch` (also for Arch-based systems like Manjaro) and `fedora`.

- `machine_preset`: name of a preset under `resources/presets/` to copy machine-specific files.
- `window_manager`: choose `i3` or `hyprland`.
- Hyprland extras (effective only when `window_manager` is `hyprland`):
  - `add_input_group`: add the current user to the `input` group.
  - `install_sddm`: install the SDDM display manager and themes.
  - `install_gtk_themes`: install additional GTK themes.
  - `install_thunar`: install the Thunar file manager.
  - `install_quickshell`: install the Quickshell Wayland panel.
  - `install_rog_packages`: install ROG-specific packages.
- Other flags: `install_bluetooth`, `install_codecs`, `install_brave`, `install_firefox`, `install_chromium`.

### Presets
Presets allow you to copy machine-specific dotfiles or configuration snippets
into your home directory. Create a directory under `resources/presets/` with the
name of your preset, add any files you want to override, then set
`machine_preset` to that name in `config.yml`.

To override automatic package manager detection, set `os_override` in `config.yml` or pass `-e os_override=<arch|fedora>` when running `ansible-playbook`.

### Inventory
To manage multiple machines, add them to `inventory/hosts.yml` and provide
per-host variables in `inventory/host_vars/<hostname>.yml`. Run the playbook
against one or more hosts using:

```bash
ansible-playbook -i inventory/hosts.yml main.yml --limit <hostname>
```

## Linting and tests
Run the linting tools and install role requirements before invoking any of the Makefile targets:

## Development and tests
Run the linting tools before invoking any of the Makefile targets:
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

Use `make converge` (or `molecule converge`) for a quick iterative run without
destroying the test container. When you're satisfied with the result, run
`molecule verify` or `make test` for the full create–converge–verify–destroy
cycle. The Docker images used for Molecule are available from
[Jeff Geerling's collection](https://ansible.jeffgeerling.com/).
Use `molecule destroy` to remove the test container when you're finished.

Molecule defaults to Fedora 41 (`geerlingguy/docker-fedora41-ansible:latest`), but you can test other distributions by setting the `MOLECULE_DISTRO` and `MOLECULE_IMAGE` environment variables. The playbook also ships with an Arch variables file, so Arch and Arch-based systems (e.g., Manjaro) are expected to work even though they are not part of the default scenario. Debian or Ubuntu may require additional variables and remain untested.

For example, to run the scenario against Ubuntu 20.04:

```bash
MOLECULE_DISTRO=ubuntu \
MOLECULE_IMAGE=geerlingguy/docker-ubuntu2004-ansible:latest \
make test
```

Running Molecule with multiple platforms will execute the playbook against each listed distribution.

### Testing presets with Molecule

You can run Molecule against a specific hardware preset by setting the
`MOLECULE_MACHINE_PRESET` environment variable. The playbook will still detect
the operating system inside the container automatically.

Run the ThinkPad T16 Gen 2 preset on the default Fedora image:

```bash
MOLECULE_MACHINE_PRESET=thinkpad_t16_gen2 make test
```

To test a different distribution, override the Docker image and container name:

```bash
MOLECULE_DISTRO=arch \
MOLECULE_IMAGE=geerlingguy/docker-archlinux-ansible:latest \
MOLECULE_MACHINE_PRESET=thinkpad_t16_gen2 make test
```

`MOLECULE_DISTRO` controls the container name, while `MOLECULE_IMAGE` selects
the base image used for the scenario.

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
