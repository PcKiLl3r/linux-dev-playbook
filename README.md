## How To Setup Env
1. Install dependencies and clone the repo using the provided setup script:
    ```bash
    curl -L https://raw.githubusercontent.com/PcKiLl3r/linux-dev-playbook/master/resources/setup.sh | OS_OVERRIDE=<your_os> bash
    ```
    The `OS_OVERRIDE` environment variable is optional and allows you to force a distribution when autodetection fails.
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

6. Edit `config.yml` to customise which browsers are installed or to override OS detection.
7. Run the playbook manually if desired:
    ```bash
    ansible-playbook main.yml --vault-password-file vault/vault_pass.txt --ask-become-pass
    ```

### Inventory
This playbook runs against `localhost`, so no inventory file is needed. Ansible uses its default inventory when executing `main.yml`.

## Linting and tests
Run the linting tools before invoking any of the Makefile targets:
```bash
make install-lint
```
After the tools are installed you can run the usual checks:
```bash
make lint
make test
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
