#!/bin/zsh

proxy_port=50000
controller_port=50001

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
    "fyapi.net" "100.91.208.82" "100.123.197.14" "100.91.208.82" "100.67.221.6" "100.66.76.72" \
    "*.overleaf.com" "*.overleaf.cn" "*.overleaf.net" \
    "indico.cern.ch" "*.bnl.gov" "*.ihep.ac.cn" "*.zoom.us" "*.sjtu.edu.cn" "*.aps.org"
}

trap "cleanup" INT
set_system_proxy ${proxy_port}

echo "Port forwarding..."
ssh -N -L ${proxy_port}:localhost:${proxy_port} -L ${controller_port}:localhost:${controller_port} lxlogin

