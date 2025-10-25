#!/bin/bash
# Program: supermonASL_latest_update (safe extract, no owner changes)
# Original Author: Paul Aidukas - KN2R
# Maintainer (fix): Freddie/KD5FMU workflow hardening
# Notes: Add --no-same-owner so files aren't retagged to UID 1000 on extract.

set -euo pipefail

# Verify we're on a Debian-like ASL system
if ! grep -Eq '^(ID=debian|ID=raspbian)$' /etc/os-release; then
  echo "This does not appear to be an ASL Debian/Raspbian system; aborting." >&2
  exit 1
fi

cd /

# Download latest package to a unique temp file
TMP_TGZ="$(mktemp -p / tmp.supermon.XXXXXX.tgz)"
trap 'rm -f "$TMP_TGZ"' EXIT
wget "http://198.58.124.150/sm74/SupermonASL-latest.tgz" -O "$TMP_TGZ"

# Extract WITHOUT adopting archived owners (prevents kd5fmu ownership). Keep permission bits.
sync
tar -xzvpf "$TMP_TGZ" --no-same-owner
sync

# Cleanup old Supermon PHP stubs that the upstream script removed
CLNUP="/var/www/html/supermon"; MIM=".php"
FLS="ast_reload stats asteronoff astlog dtmf fastrestart linuxlog pi-gpio reboot webacclog"
for i in $FLS; do
  rm -f "${CLNUP}/${i}${MIM}" || true
done
rm -f "$CLNUP/edit/controlpanel.php" || true

# Optional: enforce root ownership on common install locations
# Uncomment if you want to be extra sure
# chown -R root:root /usr/local/sbin /usr/local/bin /var/www/html/supermon 2>/dev/null || true

exit 0
