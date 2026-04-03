# doublezero-updater

Keeps `doublezero` and `doublezero-solana` up to date on any node. Checks Cloudsmith every 10 minutes and runs `apt install` when a new version is available.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/doublezerofoundation/doublezero-updater/main/install.sh | sudo bash
```

## Verify

```bash
systemctl status doublezero-updater.timer
journalctl -u doublezero-updater.service
```

## Uninstall

```bash
systemctl disable --now doublezero-updater.timer
rm /lib/systemd/system/doublezero-updater.{service,timer}
rm -rf /usr/lib/doublezero-updater
systemctl daemon-reload
```
