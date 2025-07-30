#!/usr/bin/env bash

sudo pacman -S --noconfirm ansible git
git clone https://github.com/PcKiLl3r/linux-dev-playbook ~/personal/linux-dev-playbook
cd ~/personal/linux-dev-playbook
ansible-playbook main.yml --vault-password-file ./vault/vault_pass.txt
