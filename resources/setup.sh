#!/usr/bin/env bash

if [ -n "$OS_OVERRIDE" ]; then
  TARGET_OS="$OS_OVERRIDE"
elif [ -f /etc/manjaro-release ]; then
  TARGET_OS="manjaro"
elif [ -f /etc/fedora-release ]; then
  TARGET_OS="fedora"
elif [ -f /etc/debian_version ]; then
  TARGET_OS="debian"
else
  TARGET_OS="unknown"
fi

case "$TARGET_OS" in
  manjaro)
    sudo pacman -S --noconfirm ansible git
    ;;
  fedora)
    sudo dnf install -y ansible git
    ;;
  debian)
    sudo apt-get update
    sudo apt-get install -y ansible git
    ;;
  *)
    echo "Unsupported OS: $TARGET_OS" >&2
    exit 1
    ;;
esac
git clone https://github.com/PcKiLl3r/linux-dev-playbook ~/personal/linux-dev-playbook
cd ~/personal/linux-dev-playbook
ansible-playbook main.yml --vault-password-file ./vault/vault_pass.txt -e os_override=$TARGET_OS
