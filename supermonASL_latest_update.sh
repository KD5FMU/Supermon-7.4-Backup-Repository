#!/bin/bash
#
# Program: supermonASL_latest_update (Copyright) Nov 2, 2020
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

cd /; wget "http://198.58.124.150/sm74/SupermonASL-latest.tgz" -O SupermonASL-latest.tgz
sync; tar -xzvpf SupermonASL-latest.tgz; sync; rm SupermonASL-latest.tgz

# Cleanup old files:
CLNUP="/var/www/html/supermon"; MIM=".php"
FLS=" ast_reload stats asteronoff astlog dtmf fastrestart linuxlog pi-gpio reboot webacclog"
for i in $FLS
 do
    rm -f "${CLNUP}/${i}.${MIM}"
 done
rm -f "$CLNUP/edit/controlpanel.php"
# /usr/local/sbin/supermon/fixperms
sync

exit 0

# The end ;)
###############################################################
