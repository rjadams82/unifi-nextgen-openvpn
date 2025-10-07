#!/bin/bash
# cleanup.sh
# for testing purposes only 
# this script will clear out the fix files
#
# error handling
#set -x # full xtrace output
set -o errtrace
handle_error() {
    echo "FAILED: line $1, exit code $2"
    exit 1
}
trap 'handle_error $LINENO $?' ERR
#
echo "*************************************************************************"
echo "* IMPORTANT: This custom script is provided AS IS without any warranty. *"
echo "* This script should be considered for testing purposes only and you    *"
echo "* should consider it untested and unsupported! Use at your own risk!    *"
echo "* There is a chance you will damage your hardware and software! The     *"
echo "* author is not responsible for any damage or data loss that may occur! *"
echo "*************************************************************************"
echo ""
echo "Unifi Next Generation Gateway openvpn ptp dynamic client fix - REMOVAL SCRIPT"
echo "github.com/rjadams82/unifi-nextgen-openvpn"
echo ""
echo "Continuing this script will completely remove the ovpn-ptp-fix files and logs"
read -p "Press any key to continue... OR CTRL+C to EXIT NOW..." < /dev/tty

rm -f /etc/cron.d/ovpn-ptp-fix
rm -f /etc/cron.hourly/ovpn-ptp-fix
rm -rf /home/ovpn-ptp-fix/ 
rm -rf /root/ovpn-ptp-fix/
rm -rf /data/custom/ovpn-ptp-fix/
rm -f /var/log/ovpn-ptp-fix.log*
rm -f /etc/logrotate.d/ovpn-ptp-fix

echo "ovpn-ptp-fix files and lgos have been removed from the device"

exit 0
