#!/bin/sh
# script for UXG platform dynamic openvpn
# 2025-01-14 github.com/rjadams82/unifi-nextgen-openvpn
#
# search/update any site-to-site configs containig remote IP 0.0.0.0
# add the float directive to allow dynamic/CGNAT remote devices
# and disable the --remote directive to allow the float
# 
# openvpn site-to-site configs are stored here in our system - you should verify your location:
# /etc/openvpn/openvpn-peer-x/peer.config.x
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
# configure variables
logtag='ovpn-ptp-fix'                   # tag to prepend in syslog entry for easy searching - "journalctl -t ovpn-ptp-fix"
cfgdir='/etc/openvpn/openvpn-peer-*/'   # root directory for config files
cfgexp='peer.config.*'                  # config file pattern to match
#cfgdir='/home/'                        # testing
#cfgexp='test.config'                   # testing
#
# NO MORE EDITS BELOW #
/usr/bin/logger -t "$logtag" -p 6 -- 'start script'
if [ $(ls -1 $cfgdir$cfgexp | wc -l) -gt 0 ]; then
    # found the file(s)
    for file in $cfgdir$cfgexp; do
        scount=0
        odir="$(dirname $file)"
        opid=$(<"${odir}/peer.pid")
        if [ -z "$opid" ]; then
            # no pid assigned so peer is not running
            opid="[stopped]"
        fi
        lstr="$odir pid:$opid"
        # check for remote 0.0.0.0
        if grep -q "remote 0.0.0.0" "$file"; then
            # ok we have a qualifying peer config with bogus remote IP (dynamic client)
            # check file for missing float option
            if ! grep -q -- "--float" "$file"; then
                # add the --float option for dynamic peer
                echo '--float' >> $file
                ((scount++))
                lstr="${lstr} | add --float"
            else
                # float already there
                :
            fi
    
            # check for --remote directve still active
            if ! grep -q -- "#--remote 0.0.0.0" "$file"; then
                # no commented --remote directive, we must comment it out
                sed -i -e "s/--remote 0.0.0.0/#--remote 0.0.0.0/g" "$file"
                ((scount++))
                lstr="${lstr} | comment --remote"
            else
                # remote already commented
                :
            fi
    
            # check for script actions
            if [ $scount -gt 0 ]; then
                # we made changes, grab the active pid and kill the peer connection process
                if [[ "$opid" != "[stopped]" ]]; then
                    kill "$opid"
                    lstr="${lstr} | kill $opid"
                fi
            else
                # no actions taken in script
                lstr="${lstr} dynamic peer config OK, no action taken"
            fi
        else
            # no peer configs with remote 0.0.0.0 found
            lstr="${lstr} no dynamic 0.0.0.0 peer found"
        fi
        
        # log results to syslog
        if  [ $scount -gt 0 ]; then
            # log notice because action taken
            /usr/bin/logger -t "$logtag" -p 5 -- "$lstr"
        else
            # log info because no action taken
            /usr/bin/logger -t "$logtag" -p 6 -- "$lstr"
        fi
    done
else
    /usr/bin/logger -t "$logtag" -p 6 -- 'no config files found'
fi
/usr/bin/logger -t "$logtag" -p 6 -- 'finish script'
exit 0
