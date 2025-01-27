#!/bin/bash
#
# installer script for UXG platform dynamic openvpn ptp fix
# 2025-01-14 github.com/rjadams82/unifi-nextgen-openvpn
# run this install with "curl -L https://raw.githubusercontent.com/rjadams82/unifi-nextgen-openvpn/main/install.sh | bash"
# or "bash <(curl --silent https://raw.githubusercontent.com/rjadams82/unifi-nextgen-openvpn/main/install.sh)"
#
# USE AT YOUR OWN RISK
# this is a custom script - provided freely and openly for
# testing purposes only! consider it untested and unsupported!
# you obviously run the risk of damage to your hardware or software
# and should not run this script without understanding the risk.
#
set -e; # safe exit on any failure
clear -x
# Disclaimer
echo "";
echo "";
echo "*************************************************************************"
echo "* IMPORTANT: This custom script is provided AS IS without any warranty. *"
echo "* This script should be considered for testing purposes only and you    *"
echo "* should consider it untested and unsupported! Use at your own risk!    *"
echo "* There is a chance you will damage your hardware and software! The     *"
echo "* author is not responsible for any damage or data loss that may occur! *"
echo "*************************************************************************"
echo ""
echo "Unifi Next Generation Gateway openvpn ptp dynamic client fix"
echo "github.com/rjadams82/unifi-nextgen-openvpn"
echo ""
if [[ $EUID -ne 0 ]]; then
  echo "Error: This script requires root privileges. Please run with sudo."
  exit 1
fi
echo ""
read -p "Please READ CAREFULLY then press any key to continue... OR CTRL+C to EXIT NOW..."

echo ""
echo ""
# setup variables
homedir=$HOME
stagedir="$homedir/ovpn-ptp-fix/"
installdir='/data/custom/ovpn-ptp-fix/'
giturl='https://raw.githubusercontent.com/rjadams82/unifi-nextgen-openvpn/dev/'
fscriptsrc='ovpn-ptp-fix.sh'    # source script
fscriptdst='ovpn-ptp-fix.sh'    # destination script
fcron='/etc/cron.d/ovpn-ptp-fix'    # cron entry
flog='/var/log/ovpn-ptp-fix.log'    # log file

echo ""
echo "Default installation directory: $installdir"
echo "To complete installation of 'ovpn-ptp-fix' ";
read -p "Press any key to continue... OR CTRL+C to EXIT NOW..."

echo ""
echo ""

#cd "$homedir"

# temp staging needed?
mkdir -p $stagedir

# where we will put our production custom fix
mkdir -p $installdir

# pull down asset to staging
curl -L $giturl/$fscriptsrc > "$stagedir/$fscriptdst"

# move to install dir
cp "$stagedir/$fscriptdst" "$installdir/$fscriptdst"

# make executable
chmod 755 "$installdir/$fscriptdst"

# add cron entry to run this at regular intervals
cronadd="# cron task for ovpn-ptp-fix script located in $installdir
# run ovpn-ptp-fix.sh every 5 minutes to check for dynamic openvpn ptp configurations
*/5 * * * * root $installdir$fscriptdst >> /var/log/ovpn-ptp-fix.log 2>&1
"
echo "$cronadd" > $fcron

# Post-installation message
echo ""
echo "script installation complete!"
echo ""
echo "ovpn-ptp-fix script has been installed in $installdir"
echo "fix has been added to cron and will run at 5 minute intervals"
echo "you can also run it manually using: '$installdir/$fscriptdst'"
echo ""
echo "to review script results check syslog with 'journalctl -t ovpn-ptp-fix'"
echo ""
echo "please refer to documentation for any other information."
echo "github.com/rjadams82/unifi-nextgen-openvpn"
echo ""
exit 0
