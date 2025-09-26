#!/bin/bash
# cleanup.sh
# for testing purposes only this script will clear out the fix
#

rm -f /etc/cron.d/ovpn-ptp-fix
rm -f /etc/cron.hourly/ovpn-ptp-fix
rm -rf /home/ovpn-ptp-fix/ 
rm -rf /root/ovpn-ptp-fix/
rm -rf /data/custom/ovpn-ptp-fix/
rm -f /var/log/ovpn-ptp-fix.log*
rm -f /etc/logrotate.d/ovpn-ptp-fix
