# unifi-nextgen-openvpn
## Setup unifi next-gen gateway openvpn site to site with dynamic remote IP

> These scripts are under development. If you accept the risk you can install with the install script or alternatively you may run just the the fix script manually to evaluate/test the results. Feedback is welcome.

## What this is for
Setting up OpenVPN site-to-site connections in Unifi requires static IP on the remote site, as the Unifi Network Application does not allow you to setup a site-to-site connection without a Remote IP address.
However OpenVPN *does* allow remote VPN endpoints with dynamic IP addresses (--float option) even though Unifi does not expose this option.

This is useful for remote endpoints such as 5G/LTE modems or routing devices connected behind a dynamic broadband internet connection, and you either dont know the true public internet IP or the public IP changes frequently.

*Note: At the very least (for any VPN connection in general) the Unifi Gateway itself will need either a static internet IP, or you should be using DDNS to have a reliable way for your remote endpoint to connect to the Unifi Gateway.*

### How the fix works
1. First you would setup OpenVPN site-to-site VPN connection(s) in Unifi Application. (Since the remote endpoint may be behind CGNAT (LTE modem) or might have a DHCP WAN address, you would enter 0.0.0.0 as the "Remote IP Address".)
2. Next a task runs (calling the fix script) at regular intervals (using cron) to parse the configured site-to-site connections; if they have a Remote IP Address of "0.0.0.0" the fix adds the --float option and comments out the --remote option.
3. Then for any site-to-site config the fix has modified, it grabs the PID and kills the process, which automatically restarts (watchdog) with the updated config (--float #--remote).
4. Finally the fix will log any actions to "/var/log/ovpn-ptp-fix.log".

## Install the fix by running the installer from this repo
*installer is under development. run at your own risk.*

To install the fix you can use the install.sh script directly in the shell.

The fix script will be automatically installed and ran from /data/custom/ - this should not be overwritten during Unifi software upgrades:
```
curl -L https://raw.githubusercontent.com/rjadams82/unifi-nextgen-openvpn/main/install.sh | bash
```

*At this time we use a cron entry in "/etc/cron.hourly" to call the fix script every hour.*

if you want to manually trigger a run, you can use run-parts to emulate a cron execution 
```
run-parts /etc/cron.hourly/
```
or you can call the script directly
```
/data/custom/ovpn-ptp-fix/ovpn-ptp-fix.sh
``` 

## No Install: Just run the fix script (for testing or one time use)
if you just want to test/run the fix script without installing, or need to debug, use this option

put the fix script on the device somewhere like "/root/ovpn-ptp-fix.sh" using SCP or other file transfer tool

make the script executable then run the script as needed
```
cd /root/
chmod 755 ovpn-ptp-fix.sh
./ovpn-ptp-fix.sh
```
