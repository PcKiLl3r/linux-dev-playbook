## How To Setup Env
1. Install dependencies:
    ```
    sudo dnf install git ansible
    ```
2. Make personal dir
    ```
    mkdir personal
    cd presonal
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
5. Run Ansible setup script:
    ```
    ansible-playbook main.yml --vault-password-file vault_pass.txt --ask-become-pass
    ```

## Todo
Make a script hosted on web to allow usage like:
```
curl https://dev.todo.com | sh
```

```
mkdir personal
cd personal
curl https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup | sh
```
