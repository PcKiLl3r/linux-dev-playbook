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

## Browser Lineup

The playbook can install the following browsers via `tasks/browsers.yml`:

- Brave (default on most presets)
- Firefox
- Zen Browser (Chromium replacement)

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
