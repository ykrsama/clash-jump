
## First setup

1. Create `.env` file:

```bash
export CLASH_SUBSCRIBE_URL=<url>
export CLASH_SECRET='<set your secret for clash controller>'
```

2. Modify port in `scripts/update_config.sh`, and run `./scripts/update_config.sh` . The config file will be downloaded to `~/.config/clash/config.yaml`

3. Use `crontab -e` to automate config update (every hour):

```bash
0 * * * * /path/to/scripts/update_config.sh
```

## Test

1. Run test:

```
./setup.sh test
```

2. On local machine, start port forwarding:

```
ssh -N -L <proxy_port>:localhost:<proxy_port> -L <controller_port>:localhost:<controller_port> lxlogin
```

3. Setup system proxy on local machine. (for automation, see `clash-forward-mac.sh`)

4. Open youtube.com on local web browser

## Setup service

1. Install and run service:

```
./setup.sh start
```

2. Setup port forwarding and system proxy on local machine. (for automation, see `clash-forward-mac.sh`)

## Control panel

1. Disable Chrome "Block insecure private network requests":
```
chrome://flags/#block-insecure-private-network-requests
```

![img](https://user-images.githubusercontent.com/38437979/136690045-a457f1c7-73da-40f0-b6a6-b76d82ec674a.png)

2. Open [yacd.haishan.me](https://yacd.haishan.me/) in Chrome browser, setup backend ip, port and secret.


