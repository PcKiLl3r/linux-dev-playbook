# Fresh Install Guide

This guide walks you through preparing a brand new machine and applying this playbook with the correct machine preset.

## 1. Install prerequisites and clone

Run the setup script from any fresh Fedora or Arch based install. It installs Ansible and git and clones the repository into `~/personal/linux-dev-playbook`:

```bash
curl -L https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | OS_OVERRIDE=<arch|fedora> bash
```

If auto‑detection fails, set `OS_OVERRIDE` to `arch` or `fedora` as shown above.

## 2. Configure the playbook

1. Change into the repository and copy the configuration template:
   ```bash
   cd ~/personal/linux-dev-playbook
   cp config.template.yml config.yml
   ```
2. Edit `config.yml` and set the `machine_preset` to match the current machine. Available presets live under `resources/presets/` (e.g. `thinkpad_t16_gen2`, `ideapad_330`, `4k`). Review the browser flags in the chosen preset to enable any of the supported options (Brave, Firefox, or Zen Browser).
3. Create a file named `.ansible_vault_pass` containing your Ansible Vault passphrase:
   ```bash
   echo 'your‑vault‑password' > .ansible_vault_pass
   chmod 600 .ansible_vault_pass
   ```
4. (Optional) Create or edit vault files such as `vault/bluetooth.yml` to store secrets. Use:
   ```bash
   ansible-vault edit vault/bluetooth.yml --vault-password-file .ansible_vault_pass
   ```
5. (Optional) Copy any trusted device backups from `/var/lib/bluetooth` into `files/bluetooth/<inventory_hostname>/` so they ca
n be restored during provisioning.

### Opting in/out of desktop applications

Each preset exposes boolean flags that control optional GUI software. Set any of these to `false` if you want to skip an app (or `true` to ensure it is installed):

- `install_spotify` – installs Spotify via the native package repositories (negativo17 on Fedora, community package on Arch) and removes the legacy Flatpak wrapper.
- `install_obsidian` – installs Obsidian from the official repositories (RPM on Fedora, community package on Arch) and removes the legacy Flatpak wrapper.
- `install_chatgpt_desktop` – downloads the ChatGPT Desktop AppImage and exposes it through `/usr/local/bin/chatgpt-desktop`.
- `install_mattermost` – installs the Mattermost desktop client from Flathub and exposes it through `/usr/local/bin/mattermost`.
- `install_pgmodeler` – installs pgModeler from the distro repositories.
- `install_zen` – installs Zen Browser (RPM on Fedora, AppImage fallback on Arch) with `/usr/local/bin/zen`.

These flags live alongside the other `install_*` options in each preset file.

## 3. Apply the playbook

Run the bootstrap script to decrypt vault files, execute the playbook and re-encrypt them:

```bash
./scripts/bootstrap.sh
```

The playbook installs packages and copies any preset files for the chosen machine. Rerun the script whenever you need to reapply the configuration.

### Handling existing clones

The core tasks include a step that clones this repository on the target host. This is useful for provisioning remote machines but can fail on a workstation where the repository already exists with uncommitted changes.

If you hit an error during the clone step:

- Commit or stash any local changes before running the playbook, or
- Skip the clone task when invoking Ansible, for example:

  ```bash
  ansible-playbook main.yml -i localhost, -c local --skip-tags repo_clone
  ```

  (Alternatively, temporarily comment out the "Clone this repo to mirror real environment" task in `tasks/core.yml`.)
