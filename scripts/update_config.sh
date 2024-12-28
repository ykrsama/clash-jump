#!/usr/bin/bash

mixed_port=43000
external_controller_port=43001

curpath=$(dirname $(realpath $0))
cfgpath=~/.config/clash/config.yaml

source ${curpath}/../.env

mkdir -p ~/.config/clash

wget -O ${cfgpath} ${CLASH_SUBSCRIBE_URL}

# Set mixed port
sed -i "0,/mixed-port: [0-9]*/s/mixed-port: [0-9]*/mixed-port: ${mixed_port}/" ${cfgpath}
sed -i "0,/^port: [0-9]*/s/^port: [0-9]*/mixed-port: ${mixed_port}/" ${cfgpath}
# remove socks-port (use mixed port)
sed -i "0,/socks-port:/{/socks-port:/d;}" ${cfgpath}
sed -i "0,/redir-port:/{/redir-port:/d;}" ${cfgpath}
# set controller
sed -i "0,/external-controller:/s/external-controller:/external-controller: \'0.0.0.0:${external_controller_port}\' \#/" ${cfgpath}
sed -i "0,/secret:/s/secret:/secret: \'${CLASH_SECRET}\' #/" ${cfgpath}
