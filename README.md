## How To Setup Env
1. Install dependencies:
    ```
    sudo pacman -S --needed git ansible
    ```
2. Make personal dir
    ```
    mkdir personal
    cd personal
    ```
3. Clone repo:
    ```
    git clone https://github.com/PcKiLl3r/linux-dev-playbook
    cd linux-dev-playbook
    ```
4. Create Ansible Vault password file:
    ```
    vi vault/vault_pass.txt
    ```
5. Create a vault file for your Bluetooth device addresses:
    ```bash
    ansible-vault edit vault/bluetooth.yml --vault-password-file vault/vault_pass.txt
    ```
    Example content:
    ```yaml
    kinesis_mac: "AA:BB:CC:DD:EE:FF"
    sony_mac: "11:22:33:44:55:66"
    ```
6. Run Ansible setup script:
    ```
    ansible-playbook main.yml --vault-password-file vault/vault_pass.txt --ask-become-pass
    ```

## Todo
Make a script hosted on web to allow usage like:
```
curl https://dev.todo.com | sh
```

```
mkdir personal
cd personal
curl https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | sh
```
