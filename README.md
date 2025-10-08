# Linux Development Playbook

Dead simple Ansible playbook for setting up Linux development machines. Each machine gets its own preset file - that's it.

## Quick Start

<!-- 1. **Install prerequisites and clone:** -->
<!--    ```bash -->
<!--    curl -L https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | bash -->
<!--    cd ~/personal/linux-dev-playbook -->
<!--    ``` -->
<!---->
<!-- 2. **Create vault password:** -->
<!--    ```bash -->
<!--    echo 'your-vault-password' > .ansible_vault_pass -->
<!--    chmod 600 .ansible_vault_pass -->
<!--    ``` -->
<!---->
<!-- 3. **Run with a preset:** -->
<!--    ```bash -->
<!--    ./scripts/bootstrap.sh --preset thinkpad_t16_gen2 -->
<!--    ``` -->

Complete setup in one command
```bash
curl -L https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | bash -s -- --preset ideapad_330
```

Or with OS override:

```bash
# Force specific OS detection
curl -L https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | OS_OVERRIDE=arch bash -s -- --preset ideapad_330
```

## Presets - Single Source of Truth

Each machine has **one preset file** in `presets/` that contains everything:
- OS and packages
- Window manager, terminal, shell
- Applications and tools
- Hardware-specific settings
- Dotfiles folders to stow

Available presets:
- `thinkpad_t16_gen2.yml` - ThinkPad T16 Gen 2 with Hyprland
- `ideapad_330.yml` - Ideapad 330 with i3

### Feature toggles

- `enable_flatpak` &mdash; when set to `true` in a preset or inventory entry, the core role installs Flatpak, enables the system helper service, and configures the Flathub remote for both system and user scopes. Set it to `false` if you want to skip Flatpak entirely during provisioning.

## Browser Lineup

The playbook can install the following browsers via `tasks/browsers.yml`:

- Brave (default on most presets)
- Firefox
- Zen Browser (Chromium replacement)
- Google Chrome (Fedora or Debian/Ubuntu targets)

Chrome installs automatically ship with the WAVE Evaluation Tool and Vimium C extensions enabled via managed policies. Brave and Firefox deployments also receive Vimium C so keyboard navigation is consistent across browsers.

## Application toggles

Presets enable the GUI applications you want via boolean flags. Set a flag to `true` or `false` directly in the preset (or an override file) to opt in or out of an application.

| Flag | Description |
| --- | --- |
| `install_spotify` | Install Spotify via native packages (RPM Fusion + LPF workflow on Fedora, community repo on Arch) and ensure the Flatpak wrapper is removed. |
| `install_obsidian` | Download the latest Obsidian AppImage and expose it through `/usr/local/bin/obsidian`, replacing the legacy Flatpak wrapper. |
| `install_chatgpt_desktop` | Download the ChatGPT Desktop AppImage and install a `/usr/local/bin/chatgpt-desktop` wrapper. |
| `install_mattermost` | Install the Mattermost desktop client from Flathub and add a `/usr/local/bin/mattermost` launcher. |
| `install_pgmodeler` | Install pgModeler from the native package repositories. |
| `install_zen` | Install Zen Browser (RPM on Fedora, AppImage fallback on Arch) and provide `/usr/local/bin/zen`. |
| `install_chrome` | Install Google Chrome from the official repositories (Fedora) or direct Debian package (Debian/Ubuntu). |

All shipped presets default these flags to `true`, but you can flip them to `false` if you prefer to skip any of the tools.

## Adding a New Machine

1. **Copy existing preset:**
   ```bash
   cp presets/thinkpad_t16_gen2.yml presets/my_machine.yml
   ```

2. **Edit the preset:**
   ```bash
   vim presets/my_machine.yml
   ```

3. **Run it:**
   ```bash
   ./scripts/bootstrap.sh --preset my_machine
   ```

## Development

```bash
# Run with specific preset
make run PRESET=thinkpad_t16_gen2

# Test with preset
make test PRESET=ideapad_330

# Lint code
make lint
```

## Requirements

- Fedora or Arch-based Linux
- Ansible and git (installed by setup script)
- Optional Docker Desktop support requires:
  - Hardware virtualization enabled in firmware (VT-x/AMD-V)
  - Systemd user lingering for the target user (handled by the playbook)
  - Network access to download packages from Docker

## Docker Desktop (optional)

Set `install_docker_desktop: true` in your preset to have the playbook:

- Add the official Docker repositories (Fedora) and dependencies
- Download and install the latest Docker Desktop package for Fedora or Arch
- Enable both the system and user systemd services for Docker Desktop
- Verify the installation with `docker version` and `com.docker.cli -v`

That's it. No config files, no templates, no duplication.

## FAQ

### Why was my ThinkPad T16 Gen 2 rebooted even though Hyprland was already installed?

The `thinkpad_t16_gen2` preset drives the Hyprland role, and the playbook
performs a reboot whenever a desktop environment or window manager is freshly
installed. The reboot is gated on the `desktop_install_changed` fact, which is
set by `tasks/hyprland.yml` only when the Hyprland binaries are missing before
the package task runs. The detection checks `/usr/bin/Hyprland` and
`/usr/bin/hyprland`, so if Hyprland was previously installed somewhere else
(e.g., from a manual build or a non-standard package), the playbook assumes it
needs to install Hyprland and marks `desktop_install_changed` as true. That flag
triggers the reboot defined in the post tasks to ensure the new desktop stack is
started cleanly. Aligning the existing Hyprland installation with one of the
detected binary paths (or letting the playbook manage the packages) prevents the
extra reboot. The Hyprland role now prints a summary block (`Report Hyprland
installation summary`) that lists whether the binaries were detected before the
run and whether the package task reported changes. Immediately before the
reboot, the playbook also echoes the collected `desktop_install_change_reason`
messages (for Hyprland, KDE, or XFCE) so your log file clearly states why the
reboot is happening. Look for output like:

```
TASK [Report Hyprland installation summary] ************************
ok: [localhost] => {
    "msg": [
        "Hyprland binaries detected before run: False",
        "Hyprland package task reported changes: True",
        "desktop_install_changed: True"
    ]
}
TASK [Show desktop installation change reasons] ********************
ok: [localhost] => {
    "msg": "Hyprland packages were installed because no Hyprland binary was detected before the playbook ran. The role only checks /usr/bin/Hyprland and /usr/bin/hyprland, so installations in other paths will trigger a reinstall and the subsequent reboot."
}
```

In the sample log you shared, the `Install Hyprland packages` step finished with
`ok`, which means the playbook did not reinstall Hyprland on that particular
run. The reboot you observed happened earlier, when the packages were actually
installed and the new summary output would have shown `Hyprland binaries
detected before run: False`. 【F:main.yml†L276-L309】【F:tasks/hyprland.yml†L1-L92】

### Can I review the playbook logs after the reboot happens?

The bootstrap script pipes Ansible's output directly to your terminal, so once
the machine reboots that scrollback is gone. Capture a log before you rerun the
playbook by exporting `ANSIBLE_LOG_PATH` to a writable location:

```bash
mkdir -p ~/.ansible/logs
ANSIBLE_LOG_PATH=~/.ansible/logs/linux-dev-playbook-$(date +%Y%m%d%H%M%S).log \
  ./scripts/bootstrap.sh --preset thinkpad_t16_gen2
```

After the reboot you can inspect that log file to review everything the playbook
changed. For additional system context around the reboot itself, use
`journalctl -b -1` (or add `-u sshd`, `-u systemd-logind`, etc.) to see the
previous boot's journal entries. 【F:scripts/bootstrap.sh†L1-L41】

## Secrets and Automated Logins

Some development services require credentials at install time. Populate
`vault/dev-tools.yml` (and encrypt it with `ansible-vault` in your own
environment) to enable the following automations:

| Toggle | Required values | Description |
| --- | --- | --- |
| `github_cli_enable_auth` | `github_cli_token`, optional `github_cli_host` | Installs `gh` and performs `gh auth login` with the provided token. |

All values default to disabled/blank so the playbook remains usable without the
services. Remember to re-encrypt `vault/dev-tools.yml` after editing.
