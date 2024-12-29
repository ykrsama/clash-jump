#!/bin/zsh

proxy_port="__CLASH_MIXED_PORT__"
controller_port="__CLASH_CTL_PORT__"
secret="__CLASH_SECRET__"

function cleanup() {
    echo "Resetting system proxy"
    networksetup -setwebproxystate "Wi-Fi" off
    networksetup -setsecurewebproxystate "Wi-Fi" off
    networksetup -setsocksfirewallproxystate "Wi-Fi" off
    networksetup -setproxybypassdomains "Wi-Fi" ""
}

function set_system_proxy() {
    port=$1
    networksetup -setwebproxystate "Wi-Fi" on
    networksetup -setsecurewebproxystate "Wi-Fi" on
    networksetup -setsocksfirewallproxystate "Wi-Fi" on
    networksetup -setwebproxy "Wi-Fi" localhost $port
    networksetup -setsecurewebproxy "Wi-Fi" localhost $port
    networksetup -setsocksfirewallproxy "Wi-Fi" localhost $port
    networksetup -setproxybypassdomains "Wi-Fi" \
    "192.168.0.0/16" "10.0.0.0/8" "172.16.0.0/12" "127.0.0.1" "localhost" "*.local" \
    "timestamp.apple.com" "sequoia.apple.com" "seed-sequoia.siri.apple.com" "*.crashlytics.com" \
    "*.overleaf.com" "*.overleaf.cn" "*.overleaf.net" \
    "indico.cern.ch" "*.bnl.gov" "*.ihep.ac.cn" "*.zoom.us" "*.sjtu.edu.cn" "*.aps.org"
}

trap "cleanup" INT
set_system_proxy ${proxy_port}

WEB_CTL_URL="https://yacd.haishan.me/#/backend"
echo "Opening web controller:"
echo $WEB_CTL_URL
# Open url in chrome
open -a "Google Chrome" $WEB_CTL_URL
echo "First time setup:"
echo "    API Base URL = http://127.0.0.1:${controller_port}"
if [[ ! -z $secret ]]; then
    echo "    Secret = $secret"
fi
echo ""
echo "SSH tunneling..."
ssh -N -L ${proxy_port}:localhost:${proxy_port} -L ${controller_port}:localhost:${controller_port} lxlogin

