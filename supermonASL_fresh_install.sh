#!/bin/bash
set -euo pipefail
#
# Program: supermonASL_fresh_install (Copyright) Nov 2, 2020
# Author:  Paul Aidukas - KN2R
#
# Get/install latest Official Supermon Update
# from Original Supermon developer internet site.
#
# 02-Nov-2020  Paul-KN2R  Initial release.
# 27-Nov-2020  Paul-KN2R  Changed to always get latest update.
# 10-May-2021  Paul-KN2R  Ported software to ASL platform.
#
###############################################################

OSR=`cat /etc/os-release | egrep -i '^id=' |  awk -F '=' '{print $2}'`
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

UPDATE_FILE=SupermonASL-fresh-install.tgz

cd /
wget "http://198.58.124.150/sm74/${UPDATE_FILE}" -O $UPDATE_FILE
sync; tar -xzvf $UPDATE_FILE --no-same-owner; sync; rm $UPDATE_FILE

cd /var/log; chmod +r syslog* messages*
mkdir apache2; cd apache2; chmod +rx .
touch access.log error.log; chmod +r *

/usr/local/sbin/supermon/logip
/var/www/html/supermon/astdb.php

# /usr/local/sbin/supermon/fixperms
sync

service apache2 force-reload
systemctl restart apache2
echo -e "\nAll tasks completed.\n"

exit 0

# The end ;)
###############################################################