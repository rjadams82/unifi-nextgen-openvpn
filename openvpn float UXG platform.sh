# script for UXG platform 
# update any site-to-site configs
# with the float option to allow remote devices
# to use dynamic IP addresses or CGNAT
# 
# openvpn configs are stored here for process loading
# /etc/openvpn/openvpn-peer-x/peer.config.x

# configure variables
logpri='user.notice'
#lstr='[openvpn config fix] '

for file in /etc/openvpn/openvpn-peer-*/peer.config.*; do
    # check for remote 0.0.0.0
    if grep -q "remote 0.0.0.1" $file; then  
        
        # check file for missing float option
        if ! grep -q "float" $file; then        
            # add the --float option
            echo '--float' >> $file

            # grab the pid and kill the site connection
            opid=$(<${file%/*}/peer.pid)
            #pkill -F ${file%/*}/peer.pid

            # log the task
            logger -t '[openvpn config fix]' -p user.notice "updated $file with --float and restart openvpn pid $opid"
        fi
        # else
        logger -t '[openvpn config fix]' -p user.info "${file} contains float option. no action taken."
    fi
    logger -t '[openvpn config fix]' -p user.info "${file} configured for remote with dedicated ip/hostname. no action taken."  
done
