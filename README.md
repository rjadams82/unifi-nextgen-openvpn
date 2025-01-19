# unifi-nextgen-openvpn
## Setup unifi next-gen gateway openvpn site to site

> These scripts are under development. If you accept the risk you can install or run the script manually to evaluate results. Feedback is welcome. 

## run the installer from this repo
installer is under development. run at your own risk.
script will be installed in /data/custom/
```
curl -L https://raw.githubusercontent.com/rjadams82/unifi-nextgen-openvpn/main/install.sh | bash
```

## run the fix script manually
upload script to the device in "/root/ovpn-ptp-fix.sh" using SCP or other tool
make executable and run the script
```
cd /root/
chmod 755 ovpn-ptp-fix.sh
./ovpn-ptp-fix.sh
```
