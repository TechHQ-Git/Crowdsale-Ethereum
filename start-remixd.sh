#!/bin/bash

. ~/.nvm/nvm.sh
nvm use 8 > remixd.log
remixd -s `pwd` >> remixd.log &
echo "remixd invoked"
echo "Check remixd.log for details"
echo "You can use 'netstat -tulnp | grep 65520' to check if running"
echo "You can use 'killall node' to stop"

