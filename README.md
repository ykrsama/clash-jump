# Clash on Jump Server

Setup clash on linux server without sudo, and use it as a proxy server.

## First setup on jump server

1. Create `.env` file:

   ```bash
   export CLASH_SUBSCRIBE_URL='' # add subscription url here
   export CLASH_SECRET='' # create a secret for clash web controller
   export CLASH_MIXED_PORT=45000  # chooose a port for proxy
   export CLASH_CTL_PORT=45001  # choose port for web controller
   ```

   Note: Use browser to check your subscription link's content is in yaml format. If not, use [clashc.monode.xyz](https://clashc.monode.xyz) to convert the subscription link.

2. Initialize the config file:

   ```
   ./scripts/update_config.sh
   ```

   This will download the config file from your `CLASH_SUBSCRIBE_URL` to `~/.config/clash/config.yaml`

3. Copy absolute path of the update_config.sh file:

   ```
   realpath scripts/update_config.sh
   ```

4. Use `crontab -e` to automatically update subscription on every hour:

   ```bash
   0 * * * * /path/to/scripts/update_config.sh
   ```

   Note: `crontab -l` to check the crontab list.

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
   PROXY_PORT=<port1>; CTL_PORT=<port2>; export https_proxy=http://127.0.0.1:${PROXY_PORT} http_proxy=http://127.0.0.1:${PROXY_PORT} all_proxy=socks5://127.0.0.1:${PROXY_PORT}
   curl -v http://google.com
   ```

If no problem in step 1, 2 but step 3 failed, switch the proxy node (See **Web controller** section)

## Setup service

1. Install and run service:

   ```
   ./setup.sh start
   ```
   This will create a systemd service `clash.service` . You can check the status by `systemctl --user status clash`.

2. Setup port forwarding and system proxy on local machine. (for automation example, see `scripts/clash-forward-mac.sh`)

## Web controller

1. Disable Chrome "Block insecure private network requests":
   ```
   chrome://flags/#block-insecure-private-network-requests
   ```

   ![img](https://user-images.githubusercontent.com/38437979/136690045-a457f1c7-73da-40f0-b6a6-b76d82ec674a.png)

2. Open [yacd.haishan.me](https://yacd.haishan.me/) in Chrome browser, setup backend ip, port and secret.


