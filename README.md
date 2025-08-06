## How To Setup Env
1. Install dependencies and clone the repo using the provided setup script:
    ```bash
    curl -L https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | OS_OVERRIDE=<your_os> bash
    ```
    The `OS_OVERRIDE` environment variable is optional and allows you to force a distribution when autodetection fails.

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
ansible-playbook main.yml --vault-password-file vault/vault_pass.txt -e os_override=fedora --ask-become-pass
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
5. Create a vault file for your Bluetooth device addresses:
    ```bash
    ansible-vault edit vault/bluetooth.yml --vault-password-file vault/vault_pass.txt
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
    ansible-playbook main.yml --vault-password-file vault/vault_pass.txt --ask-become-pass
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

- `window_manager`: choose `i3` or `hyprland`. Set to `hyprland` to install the Hyprland compositor.
- Hyprland extras (effective only when `window_manager` is `hyprland`):
  - `add_input_group`: add the current user to the `input` group.
  - `install_sddm`: install the SDDM display manager and themes.
  - `install_gtk_themes`: install additional GTK themes.
  - `install_thunar`: install the Thunar file manager.
  - `install_quickshell`: install the Quickshell Wayland panel.
  - `install_rog_packages`: install ROG-specific packages.
- Other flags: `install_bluetooth`, `install_brave`, `install_firefox`, `install_chromium`.

To override automatic package manager detection, set `os_override` in `config.yml` or pass `-e os_override=<distro>` when running `ansible-playbook`.

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
