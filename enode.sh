#!/bin/bash

tail -f /var/log/parity.log | while read LOGLINE
do
   [[ "${LOGLINE}" == *"enode"* ]] && echo $LOGLINE | grep -oEi '(enode.*@)' > /var/www/index.html
# && pkill -P $$ tail
done