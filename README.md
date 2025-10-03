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

## Application toggles

Presets enable the GUI applications you want via boolean flags. Set a flag to `true` or `false` directly in the preset (or an override file) to opt in or out of an application.

| Flag | Description |
| --- | --- |
| `install_spotify` | Install Spotify from Flathub (system-wide) and add a `/usr/local/bin/spotify` launcher. |
| `install_obsidian` | Install Obsidian from Flathub and add a `/usr/local/bin/obsidian` launcher. |
| `install_chatgpt_desktop` | Install the ChatGPT Desktop Flatpak and add a `/usr/local/bin/chatgpt-desktop` launcher. |
| `install_pgmodeler` | Install pgModeler from the native package repositories. |
| `install_zen` | Install Zen Browser (RPM on Fedora, AppImage fallback on Arch) and provide `/usr/local/bin/zen`. |

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

That's it. No config files, no templates, no duplication.
