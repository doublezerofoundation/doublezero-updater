#!/bin/bash
set -e

REPO="https://raw.githubusercontent.com/doublezerofoundation/doublezero-updater/main"

mkdir -p /usr/lib/doublezero-updater

curl -fsSL "${REPO}/scripts/update.sh" -o /usr/lib/doublezero-updater/update.sh
chmod +x /usr/lib/doublezero-updater/update.sh

curl -fsSL "${REPO}/packaging/systemd/doublezero-updater.service" -o /lib/systemd/system/doublezero-updater.service
curl -fsSL "${REPO}/packaging/systemd/doublezero-updater.timer"   -o /lib/systemd/system/doublezero-updater.timer

systemctl daemon-reload
systemctl enable --now doublezero-updater.timer

echo "doublezero-updater installed and running."
