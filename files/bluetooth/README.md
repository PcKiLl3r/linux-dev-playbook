# Bluetooth Backup Directory

Place machine-specific backups of `/var/lib/bluetooth` here so the playbook can restore trusted device pairings. Create a subdirectory matching the inventory hostname and copy the backed-up files into it, for example:

```
files/
  bluetooth/
    my-laptop/
      <contents of /var/lib/bluetooth>
```

You can also store the backup in an encrypted vault instead of committing it to the repository.
