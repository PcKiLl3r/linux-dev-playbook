#!/usr/bin/env bash

PRESET=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --preset)
            PRESET="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

if [ -n "$OS_OVERRIDE" ]; then
  TARGET_OS="$OS_OVERRIDE"
elif [ -f /etc/arch-release ] || [ -f /etc/manjaro-release ]; then
  TARGET_OS="arch"
elif [ -f /etc/fedora-release ]; then
  TARGET_OS="fedora"
else
  TARGET_OS="unknown"
fi

case "$TARGET_OS" in
  arch)
    sudo pacman -S --noconfirm ansible git
    ;;
  fedora)
    sudo dnf install -y ansible git
    ;;
  *)
    echo "Unsupported OS: $TARGET_OS" >&2
    exit 1
    ;;
esac

git clone https://github.com/PcKiLl3r/linux-dev-playbook ~/personal/linux-dev-playbook
cd ~/personal/linux-dev-playbook

if [[ -n "$PRESET" ]]; then
    echo "Setting up with preset: $PRESET"

    # Check if preset exists
    if [[ ! -f "presets/${PRESET}.yml" ]]; then
        echo "Error: Preset 'presets/${PRESET}.yml' not found"
        echo "Available presets:"
        ls presets/*.yml 2>/dev/null | sed 's/presets\///g' | sed 's/\.yml//g' | sed 's/^/  /'
        exit 1
    fi

    # Prompt for vault password using /dev/tty to bypass stdin redirection
    read -s -p "Enter Ansible Vault password: " VAULT_PASS < /dev/tty
    echo
    echo "$VAULT_PASS" > .ansible_vault_pass
    chmod 600 .ansible_vault_pass

    # Run the playbook automatically
    echo "Running playbook with preset: $PRESET"
    PRESET="$PRESET" ansible-playbook main.yml \
        --vault-password-file .ansible_vault_pass \
        --ask-become-pass

    echo "Setup complete! System configured with $PRESET preset."
else
    echo "Repository cloned to ~/personal/linux-dev-playbook."
    echo "To complete setup, run:"
    echo "  cd ~/personal/linux-dev-playbook"
    echo "  ./scripts/bootstrap.sh --preset <preset_name>"
fi
