#!/bin/bash
set -e

case "$1" in
    remove|upgrade|deconfigure)
        systemctl disable --now doublezero-updater.timer || true
        ;;
esac
