#!/usr/bin/env bash

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
echo "Repository cloned to ~/personal/linux-dev-playbook. Configure config.yml and create .ansible_vault_pass before running the playbook."
