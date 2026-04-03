#!/bin/bash
set -e

case "$1" in
    configure)
        systemctl daemon-reload
        systemctl enable --now doublezero-updater.timer
        ;;
    abort-upgrade|abort-deconfigure|abort-remove)
        ;;
esac
