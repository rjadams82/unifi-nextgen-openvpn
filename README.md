# unifi-nextgen-openvpn
## Setup unifi next-gen gateway openvpn site to site

> These scripts are actively being developed. If you accept the risk you can run the script manually to evaluate results. Feedback is welcome. 

-run the installer from this repo
-installer is also under development. Run at your own risk.
```
curl -L https://raw.githubusercontent.com/rjadams82/unifi-nextgen-openvpn/main/install.sh | bash
```

-run the fix script manually
upload the script to the device "/root/ovpn-ptp-fix.sh" using SCP or other tool
make executable and run the script
```
cd /root/
chmod 755 ovpn.ptp.sh
./ovpn-ptp-fix.sh
```
