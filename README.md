# Clash on Jump Server

Setup clash on linux server without sudo, and use it as a proxy server.

## First setup

1. Create `.env` file:

```bash
export CLASH_SUBSCRIBE_URL=<subscription url here>
export CLASH_SECRET='<set your secret for clash controller>'
```

2. Choose your `mixed_port` and `external_controller_port` in `scripts/update_config.sh`, and run `./scripts/update_config.sh` . This will download the config file to `~/.config/clash/config.yaml`

3. Use `crontab -e` to automate config update (every hour):

```bash
0 * * * * /path/to/scripts/update_config.sh
```

## Test

1. Run test to check the port avaialbility:

```
./setup.sh test
```

2. On local machine, start port forwarding:

```
PROXY_PORT=<port1>; CTL_PORT=<port2>; ssh -N -L ${PROXY_PORT}:localhost:${PROXY_PORT} -L ${CTL_PORT}:localhost:${CTL_PORT} lxlogin
```

3. Open new terminal on local machine, test proxy:

```bash
PROXY_PORT=50000; CTL_PORT=50001; export https_proxy=http://127.0.0.1:${PROXY_PORT} http_proxy=http://127.0.0.1:${PROXY_PORT} all_proxy=socks5://127.0.0.1:${PROXY_PORT}
curl -v http://google.com
```

## Setup service

1. Install and run service:

```
./setup.sh start
```

2. Setup port forwarding and system proxy on local machine. (for automation example, see `scripts/clash-forward-mac.sh`)

## Control panel

1. Disable Chrome "Block insecure private network requests":
```
chrome://flags/#block-insecure-private-network-requests
```

![img](https://user-images.githubusercontent.com/38437979/136690045-a457f1c7-73da-40f0-b6a6-b76d82ec674a.png)

2. Open [yacd.haishan.me](https://yacd.haishan.me/) in Chrome browser, setup backend ip, port and secret.


