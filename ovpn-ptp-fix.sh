#!/bin/bash
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
# configure variables
logtag='ovpn-ptp-fix'                   # tag to prepend in syslog entry for easy searching - "journalctl -t ovpn-ptp-fix"
cfgdir='/etc/openvpn/openvpn-peer-*/'   # root directory for config files
cfgexp='peer.config.*'                  # config file pattern to match
#cfgdir='/home/'                        # testing
#cfgexp='test.config'                   # testing
#
# NO MORE EDITS BELOW #

for file in $cfgdir$cfgexp; do
    # found the file(s)
    scount=0
    odir="$(dirname $file)"
    opid=$(<${odir}/peer.pid)
    lstr=" $odir $opid "
    # check for remote 0.0.0.0
    if grep -q "remote 0.0.0.0" $file; then  
        # ok we have a qualifying peer config with bogus remote IP (dynamic client)        
        # check file for missing float option
        if ! grep -q -- "--float" $file; then        
            # add the --float option for dynamic peer
            echo '--float' >> $file
            ((scount++))
            lstr=${lstr}' add --float | '
        else
            # float already there
            :
        fi

        # check for --remote directve still active
        if ! grep -q -- "#--remote 0.0.0.0" $file; then
            # no commented --remote directive, we must comment it out
            sed -i -e "s/--remote 0.0.0.0/#--remote 0.0.0.0/g" $file
            ((scount++))
            lstr=${lstr}' comment --remote | ' 
        else
            # remote already commented
            :
        fi

        # check for script actions
        if [ $scount -gt 0 ]; then
            # we made changes, grab the pid and kill the site connection
            #pkill $opid            
            lstr=${lstr}" kill $opid "
        else
            # no actions taken in script
            lstr=${lstr}' dynamic peer config OK, no action taken '            
        fi
    else
        # no peer configs with remote 0.0.0.0 found
        lstr=${lstr}' no dynamic peer found '
    fi
    
    # log results to syslog
    if  [ $scount -gt 0 ]; then
        # log notice because action taken
        logger -t $logtag -p user.notice -- $lstr
    else
        # log info because no action taken
        logger -t $logtag -p user.info -- $lstr
    fi    
done
