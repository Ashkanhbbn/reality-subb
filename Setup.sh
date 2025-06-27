#!/bin/bash
# GOD-MODE AUTOPILOT SETUP

CONFIG_PATH="/sdcard/nekobox/auto_config.yaml"
SSH_KEY="/sdcard/ssh/id_rsa"

pkg install -y openssh openssl coreutils sed curl

if [ ! -f "$SSH_KEY" ]; then
  ssh-keygen -t ed25519 -f "$SSH_KEY" -N ""
fi

curl -O https://raw.githubusercontent.com/yourrepo/autopilot-godmode/main/autogen.sh
curl -O https://raw.githubusercontent.com/yourrepo/autopilot-godmode/main/sync_keys.sh
curl -O https://raw.githubusercontent.com/yourrepo/autopilot-godmode/main/ids_guard.sh

chmod +x autogen.sh sync_keys.sh ids_guard.sh

(crontab -l ; echo "*/10 * * * * bash /data/autopilot-godmode/autogen.sh") | sort - | uniq - | crontab -
(crontab -l ; echo "5 3 * * * bash /data/autopilot-godmode/sync_keys.sh") | sort - | uniq - | crontab -
(crontab -l ; echo "*/2 * * * * bash /data/autopilot-godmode/ids_guard.sh") | sort - | uniq - | crontab -

nohup bash ./autogen.sh > /dev/null 2>&1 &
echo "✅ GOD-MODE AUTOPILOT DEPLOYED"
