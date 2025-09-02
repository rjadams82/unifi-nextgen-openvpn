# unifi-nextgen-openvpn
## Setup unifi next-gen gateway openvpn site to site with dynamic remote IP

> These scripts are under development. If you accept the risk you can install or run the script manually to evaluate results. Feedback is welcome. 

## What this is for
Setting up OpenVPN site-to-site connections in Unifi requires static IP on the remote site, as the Unifi Network Application does not allow you to setup a site-to-site connection without a Remote IP address.
However OpenVPN *does* allow remote VPN endpoints with dynamic IP addresses (--float option) even though Unifi does not expose this option.

This is useful for remote endpoints such as 5G/LTE modems or routing devices connected behind a dynamic broadband internet connection, and you either dont know the true public internet IP or the public IP changes frequently.

*Note: At the very least (for any VPN connection in general) the Unifi Gateway will need either a static internet IP, or you should be using DDNS to have a reliable way for your remote endpoint to connect to the Unifi Gateway.*

### How it works
1. First we setup our OpenVPN site-to-site VPN connection in Unifi. Since the remote endpoint may be behind CGNAT (LTE modem) or might have a DHCP WAN address, we will enter 0.0.0.0 as the "Remote IP Address".
2. Next we run a task every 5 minutes to look at the configured site-to-site connections; if they have a Remote IP Address of "0.0.0.0" we add the --float option and comment out the --remote option.
3. Then for any site-to-site config that we have modified, we grab the PID and kill the process, which then automatically restarts with the modified config.
4. Finally we log any actions to to syslog. You can search for the log entries using "journalctl -t ovpn-ptp-fix".

## run the installer from this repo
*installer is under development. run at your own risk.*
To install the fix right away you can use the install.sh script directly.

script will be installed in /data/custom/
```
curl -L https://raw.githubusercontent.com/rjadams82/unifi-nextgen-openvpn/main/install.sh | bash
```

## just run the fix script manually (for testing)
if you want to test the script without installing, or need to debug changes or tweaks, use this option.

upload script to the device in "/root/ovpn-ptp-fix.sh" using SCP or other tool
make executable and run the script
```
cd /root/
chmod 755 ovpn-ptp-fix.sh
./ovpn-ptp-fix.sh
```
