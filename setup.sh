#!/usr/bin/bash

function install() {
    echo -e "\033[33mInstalling service\033[0m"
    mkdir -p ~/.config/systemd/user/
    cat>~/.config/systemd/user/clash.service<<EOF
[Unit]
Description=Clash Service
After=network.target

[Service]
ExecStart=${clash}
Restart=always
WorkingDirectory=${curpath}
#StandardOutput=append:${curpath}/log/clash.log
#StandardError=append:${curpath}/log/clash.err
EOF

    systemctl --user daemon-reload
}

function ctl_clash() {
    if [[ $1 == "start" || $1 == "restart" ]]; then
        #mkdir -p log
        if [[ $(systemctl --user is-active clash) == "inactive" ]]; then
            install
        fi
    fi
    systemctl --user $1 clash
    state=$(systemctl --user is-active clash)
    echo -e "\033[32mClash service is \033[1m${state}\033[0m"
}

function uninstall() {
    echo -e "\033[33mUninstalling service\033[0m"
    ctl_clash "stop"
    rm ~/.config/systemd/user/clash.service
    systemctl --user daemon-reload
}

workdir=$(pwd)
curpath=$(dirname $(realpath $0))
cd $curpath

source scripts/get_cpu_arch.sh

if [[ -z "$CpuArch" ]]; then
    echo "\033[32mFailed to get CPU architecture\033[0m"
    exit 1
fi

if [[ $CpuArch =~ "x86_64" || $CpuArch =~ "amd64"  ]]; then
    clash=$curpath/bin/clash-linux-amd64
elif [[ $CpuArch =~ "aarch64" ||  $CpuArch =~ "arm64" ]]; then
    clash=$curpath/bin/clash-linux-arm64
elif [[ $CpuArch =~ "armv7" ]]; then
    clash=$curpath/bin/clash-linux-armv7
else
    echo -e "\033[31m\n[ERROR] Unsupported CPU Architecture ${CpuArch} >< \033[0m"
    exit 1
fi


if [[ $1 == "test" ]]; then
    $clash
elif [[ $1 == "uninstall" ]]; then
    uninstall
elif [[ $1 == "start" ]]; then
    ctl_clash "start"
elif [[ $1 == "stop" ]]; then
    ctl_clash "stop"
elif [[ $1 == "restart" ]]; then
    ctl_clash "restart"
else
    echo -e "\033[33mUsage: $0 [test|start|stop|restart|uninstall]\033[0m"
fi

cd $workdir
