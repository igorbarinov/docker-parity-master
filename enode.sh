#!/bin/bash
touch /var/log/parity.log
tail -f /var/log/parity.log | while read LOGLINE
do
   [[ "${LOGLINE}" == *"enode"* ]] && echo $LOGLINE | grep -oEi '(enode.*@)' > /var/www/index.html
done
