#!/usr/bin/bash

curpath=$(dirname $(realpath $0))
cfgpath=${curpath}/../config.yaml

source ${curpath}/../.env

if [[ -z $CLASH_MIXED_PORT ]]; then
    echo "Please add: export CLASH_MIXED_PORT in .env"
    exit 1
fi

if [[ -z $CLASH_CTL_PORT ]]; then
    echo "Please add: export CLASH_CTL_PORT in .env"
    exit 1
fi

#mkdir -p ~/.config/clash

wget -O ${cfgpath} ${CLASH_SUBSCRIBE_URL}

# Set log level
sed -i "0,/log-level:/s/log-level:/log-level: error \#/" ${cfgpath}
# Set mixed port
sed -i "0,/mixed-port: [0-9]*/s/mixed-port: [0-9]*/mixed-port: ${CLASH_MIXED_PORT}/" ${cfgpath}
sed -i "0,/^port: [0-9]*/s/^port: [0-9]*/mixed-port: ${CLASH_MIXED_PORT}/" ${cfgpath}
# remove socks-port (use mixed port)
sed -i "0,/socks-port:/{/socks-port:/d;}" ${cfgpath}
sed -i "0,/redir-port:/{/redir-port:/d;}" ${cfgpath}
# set controller
sed -i "0,/external-controller:/s/external-controller:/external-controller: \'0.0.0.0:${CLASH_CTL_PORT}\' \#/" ${cfgpath}
sed -i "0,/secret:/s/secret:/secret: \'${CLASH_SECRET}\' #/" ${cfgpath}

################################
# Create clash-forward-mac.sh
################################
echo "Creating ${curpath}/clash-forward-mac.sh"
sed -e "s/__CLASH_MIXED_PORT__/${CLASH_MIXED_PORT}/" \
    -e "s/__CLASH_CTL_PORT__/${CLASH_CTL_PORT}/" \
    -e "s/__CLASH_SECRET__/${CLASH_SECRET}/" \
    ${curpath}/template/clash-forward-mac.sh > ${curpath}/clash-forward-mac.sh

echo "Done."
