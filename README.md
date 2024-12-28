# Clash on Jump Server

Setup clash on linux server without sudo, and use it as a proxy server.

## First setup on jump server

1. Create `.env` file:

   ```bash
   export CLASH_SUBSCRIBE_URL='' # add subscription url here
   export CLASH_SECRET='' # create a secret for clash web controller
   export CLASH_MIXED_PORT=45000  # choose a port for proxy
   export CLASH_CTL_PORT=45001  # choose port for web controller
   ```

   Note: Use browser to check your subscription link's content is in yaml format. If not, use [clashc.monode.xyz](https://clashc.monode.xyz) to convert the subscription link.

2. Initialize the config file:

   ```
   ./scripts/update_config.sh
   ```

   This will download the config file from your `CLASH_SUBSCRIBE_URL` to `~/.config/clash/config.yaml`, and generate `scripts/clash-forward-mac.sh`

3. Copy absolute path of the update_config.sh file:

   ```
   realpath scripts/update_config.sh
   ```

4. Use `crontab -e` to automatically update subscription on every hour:

   ```bash
   0 * * * * /path/to/scripts/update_config.sh
   ```

   Note: `crontab -l` to check the crontab list.

5. Install and run service:

   ```
   ./setup.sh start
   ```
   This will create a systemd service `clash.service` . You can check the status by `./setup.sh status` or `systemctl --user status clash`.

## On local machine

1. Setup port forwarding and system proxy on. 

   **For mac user**:
   - copy `scripts/clash-forward-mac.sh` to your local machine 
   - run `./clash-forward-mac.sh` on local machine

   **For windows user (Automation script WIP)**:
   - Setup ssh-tunnel with Putty or MobaXterm or other tools.
   - Set system proxy

   **For linux user (Automation script WIP)**:
   - Run the following command:
   ```bash
   PROXY_PORT='same as CLASH_MIXED_PORT' \
   CTL_PORT='same as CLASH_CTL_PORT' \
   ssh -N -L ${PROXY_PORT}:localhost:${PROXY_PORT} \
       -L ${CTL_PORT}:localhost:${CTL_PORT} \
       lxlogin  # Jump server hostname
   ```
   - Set system proxy

2. Optional: set proxy in terminal:

   **mac/linux**:
   ```bash
   PROXY_PORT=<port1>; CTL_PORT=<port2>; export https_proxy=http://127.0.0.1:${PROXY_PORT} http_proxy=http://127.0.0.1:${PROXY_PORT} all_proxy=socks5://127.0.0.1:${PROXY_PORT}
   ```

    Test:

    ```bash
    curl -v http://google.com
    ```

## Web controller

1. Disable Chrome "Block insecure private network requests":
   ```
   chrome://flags/#block-insecure-private-network-requests
   ```

   ![img](https://user-images.githubusercontent.com/38437979/136690045-a457f1c7-73da-40f0-b6a6-b76d82ec674a.png)

2. Open [yacd.haishan.me](https://yacd.haishan.me/) in Chrome browser, setup backend ip, port and secret.

## Debug

See logs in `/tmp/$USER/clash/log/clash.log` and `/tmp/$USER/clash/log/clash.err`.

