#!/bin/bash
# Program: supermonASL_fresh_install (patched to avoid ownership flip)
# Author:  Paul Aidukas - KN2R   |  Patch: prevent UID/GID from archive being applied
# Notes:   Removes 'tar -p' and adds '--no-same-owner' (optionally '--no-same-permissions')

set -euo pipefail

OSR=$(grep -i '^ID=' /etc/os-release | awk -F '=' '{print $2}')
if [ "$OSR" != "debian" ] && [ "$OSR" != "raspbian" ]; then
    echo -e "\nThis is NOT an ASL DEBIAN system!"
    echo "You must get and run the correct installer for your system image."
    echo -e "ASL or HamVoIP.  Installation aborted.\n\a"
    exit 1
fi

echo -e "\nStarting installation...\n"

apt -y update
apt -y install apache2
apt -y install php
apt -y install libapache2-mod-php
apt -y install libcgi-session-perl
ln -sf ../mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load
systemctl enable apache2
systemctl restart apache2
apt -y install bc
apt -y autoremove

UPDATE_FILE="SupermonASL-fresh-install.tgz"

cd /
wget "http://198.58.124.150/sm74/${UPDATE_FILE}" -O "$UPDATE_FILE"

# IMPORTANT: prevent archive UID/GID from being applied
# (drop -p, add --no-same-owner; uncomment --no-same-permissions if desired)
sync
tar -xzvf "$UPDATE_FILE" --no-same-owner
    # Make sure weather.sh is executable after extraction (prevent permission issues)
    if [ -f /usr/local/sbin/supermon/weather.sh ]; then
        chmod +x /usr/local/sbin/supermon/weather.sh || true
        chown root:root /usr/local/sbin/supermon/weather.sh || true
    fi

# tar -xzvf "$UPDATE_FILE" --no-same-owner
    # Make sure weather.sh is executable after extraction (prevent permission issues)
    if [ -f /usr/local/sbin/supermon/weather.sh ]; then
        chmod +x /usr/local/sbin/supermon/weather.sh || true
        chown root:root /usr/local/sbin/supermon/weather.sh || true
    fi
 --no-same-permissions
sync
rm -f "$UPDATE_FILE"

# Ensure apache logs exist and are readable
cd /var/log
chmod +r syslog* messages* || true
mkdir -p apache2
cd apache2
chmod +rx .
touch access.log error.log
chmod +r *

# Run post-install helpers (these paths come from the package)
# They are left as-is from original script
/usr/local/sbin/supermon/logip || true
/var/www/html/supermon/astdb.php || true

# If you want to force root ownership anyway, uncomment these:
# chown -R root:root /var/www/html/supermon /usr/local/sbin/supermon /usr/lib/cgi-bin /etc/apache2 || true

sync
service apache2 force-reload
systemctl restart apache2

echo -e "\nAll tasks completed.\n"
exit 0
