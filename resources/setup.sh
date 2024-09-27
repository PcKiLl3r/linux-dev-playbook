#!/usr/bin/env bash

sudo dnf install ansible git
git clone https://github.com/PcKiLl3r/linux-dev-playbook
cd linux-dev-playbook
ansible-playbook main.yml
