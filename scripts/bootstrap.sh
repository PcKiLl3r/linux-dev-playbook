#!/usr/bin/env bash
set -euo pipefail

# Prompt for vault passphrase
read -s -p "Enter Ansible Vault passphrase: " VAULT_PASS
echo

VAULT_FILE=$(mktemp)
ENCRYPTED_FILES=$(grep -l '^\$ANSIBLE_VAULT' vault/* 2>/dev/null || true)
DECRYPTED=0

cleanup() {
  if [ "$DECRYPTED" -eq 1 ] && [ -n "$ENCRYPTED_FILES" ]; then
    echo "Re-encrypting vault files..."
    ansible-vault encrypt $ENCRYPTED_FILES --vault-password-file "$VAULT_FILE" >/dev/null 2>&1 || true
  fi
  rm -f "$VAULT_FILE"
}
trap cleanup EXIT INT TERM

printf "%s" "$VAULT_PASS" > "$VAULT_FILE"

if [ -n "$ENCRYPTED_FILES" ]; then
  echo "Decrypting vault files..."
  if ansible-vault decrypt $ENCRYPTED_FILES --vault-password-file "$VAULT_FILE"; then
    DECRYPTED=1
  fi
fi

# Apply secrets and dotfiles using ansible-playbook
ansible-galaxy role install -r requirements.yml
ansible-galaxy collection install -r collections/requirements.yml -p ./collections
ansible-playbook main.yml -i localhost, -c local --vault-password-file "$VAULT_FILE"
