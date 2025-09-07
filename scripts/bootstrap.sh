#!/usr/bin/env bash
# Simplified bootstrap with mandatory preset

PRESET=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --preset)
            PRESET="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 --preset <preset_name>"
            exit 1
            ;;
    esac
done

if [[ -z "$PRESET" ]]; then
    echo "Error: --preset is required"
    echo "Available presets:"
    ls presets/*.yml 2>/dev/null | sed 's/presets\///g' | sed 's/\.yml//g' | sed 's/^/  /'
    exit 1
fi

if [[ ! -f "presets/${PRESET}.yml" ]]; then
    echo "Error: Preset 'presets/${PRESET}.yml' not found"
    echo "Available presets:"
    ls presets/*.yml 2>/dev/null | sed 's/presets\///g' | sed 's/\.yml//g' | sed 's/^/  /'
    exit 1
fi

echo "Using preset: $PRESET"

# Run ansible with preset environment variable
PRESET="$PRESET" ansible-playbook main.yml \
    --vault-password-file .ansible_vault_pass \
    --ask-become-pass

# #!/usr/bin/env bash
# # Enhanced bootstrap with machine preset support
#
# MACHINE_PRESET=""
#
# while [[ $# -gt 0 ]]; do
#     case $1 in
#         --machine|--preset)
#             MACHINE_PRESET="$2"
#             shift 2
#             ;;
#         *)
#             shift
#             ;;
#     esac
# done
#
# # Auto-detect if not specified
# if [[ -z "$MACHINE_PRESET" ]]; then
#     MACHINE_PRESET=$(detect_machine_preset)
# fi
#
# echo "Using machine preset: $MACHINE_PRESET"
#
# # Run ansible with machine preset
# ansible-playbook main.yml \
#     --vault-password-file .ansible_vault_pass \
#     -e "machine_preset=$MACHINE_PRESET" \
#     --ask-become-pass

# #!/usr/bin/env bash
# set -euo pipefail
#
# # Prompt for vault passphrase
# read -s -p "Enter Ansible Vault passphrase: " VAULT_PASS
# echo
#
# VAULT_FILE=$(mktemp)
# ENCRYPTED_FILES=$(grep -l '^\$ANSIBLE_VAULT' vault/* 2>/dev/null || true)
# DECRYPTED=0
#
# cleanup() {
#   if [ "$DECRYPTED" -eq 1 ] && [ -n "$ENCRYPTED_FILES" ]; then
#     echo "Re-encrypting vault files..."
#     ansible-vault encrypt $ENCRYPTED_FILES --vault-password-file "$VAULT_FILE" >/dev/null 2>&1 || true
#   fi
#   rm -f "$VAULT_FILE"
# }
# trap cleanup EXIT INT TERM
#
# printf "%s" "$VAULT_PASS" > "$VAULT_FILE"
#
# if [ -n "$ENCRYPTED_FILES" ]; then
#   echo "Decrypting vault files..."
#   if ansible-vault decrypt $ENCRYPTED_FILES --vault-password-file "$VAULT_FILE"; then
#     DECRYPTED=1
#   fi
# fi
#
# # Apply secrets and dotfiles using ansible-playbook
# ansible-galaxy role install -r requirements.yml
# ansible-galaxy collection install -r collections/requirements.yml -p ./collections
# ansible-playbook main.yml -i localhost, -c local --vault-password-file "$VAULT_FILE"
