#!/bin/bash
set -uo pipefail

# Derive Cloudsmith repo from the apt source already configured on this machine
CLOUDSMITH_REPO=$(grep -rh "cloudsmith.io/public/malbeclabs" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null \
  | grep -o 'malbeclabs/[^/]*' | head -1 | cut -d'/' -f2)

if [ -z "$CLOUDSMITH_REPO" ]; then
    echo "ERROR: no malbeclabs Cloudsmith apt source found"
    exit 1
fi

CLOUDSMITH_API="https://api.cloudsmith.io/v1/packages/malbeclabs/${CLOUDSMITH_REPO}"

upgrade_package() {
    local pkg="$1"
    local install_flag="$2"  # "--only-upgrade" or ""

    local latest installed
    latest=$(curl -sf "${CLOUDSMITH_API}/?query=name:^${pkg}$%20format:deb&page_size=1" \
      | python3 -c "import sys,json; p=json.load(sys.stdin); print(p[0]['version']) if p else sys.exit(1)") \
      || { echo "[${pkg}] ERROR: could not fetch latest version from Cloudsmith"; return 1; }

    installed=$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null || echo "none")

    if [ "$installed" = "$latest" ]; then
        echo "[${pkg}] up to date (${installed})"
        return 0
    fi

    echo "[${pkg}] upgrading: ${installed} -> ${latest}"
    apt-get update -qq
    # shellcheck disable=SC2086
    apt-get install ${install_flag} -y "$pkg"
    echo "[${pkg}] upgrade complete"
}

upgrade_package "doublezero"        "--only-upgrade" || true
upgrade_package "doublezero-solana" ""               || true
