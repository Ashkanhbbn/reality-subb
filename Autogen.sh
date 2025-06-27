#!/bin/bash
# AUTOGEN GODMODE v15.∞

CONFIG_PATH="/sdcard/nekobox/auto_config.yaml"
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

UUID=$(cat /proc/sys/kernel/random/uuid)
PUBLIC_KEY=$(openssl rand -base64 32 | tr -d '\n')
SHORT_ID=$(openssl rand -hex 4)
IRAN_CDN=$(shuf -n1 -e "cdn.aria-cdn.com" "files.cdn.bale.ai" "dl.digikala.com" "proxy.hamrahaval.net")
IRAN_DOMAIN=$(shuf -n1 -e "www.digikala.com" "www.torob.com" "www.sheypoor.com" "dl.iranapps.ir")
IRAN_PATH="/$(tr -dc a-z </dev/urandom | head -c 8)"
TUIC_TOKEN=$(openssl rand -hex 16)
HYSTERIA_PASS=$(openssl rand -base64 12)
OBFS_PASS=$(openssl rand -base64 8)

sed -i "s|{{ uuid }}|$UUID|g" $CONFIG_PATH
sed -i "s|{{ public_key }}|$PUBLIC_KEY|g" $CONFIG_PATH
sed -i "s|{{ short_id }}|$SHORT_ID|g" $CONFIG_PATH
sed -i "s|{{ iran_cdn }}|$IRAN_CDN|g" $CONFIG_PATH
sed -i "s|{{ iran_domain }}|$IRAN_DOMAIN|g" $CONFIG_PATH
sed -i "s|{{ iran_path }}|$IRAN_PATH|g" $CONFIG_PATH
sed -i "s|{{ tuic_token }}|$TUIC_TOKEN|g" $CONFIG_PATH
sed -i "s|{{ hysteria_pass }}|$HYSTERIA_PASS|g" $CONFIG_PATH
sed -i "s|{{ obfs_pass }}|$OBFS_PASS|g" $CONFIG_PATH

pkill -f nekobox
sleep 2
am start -n moe.nb4l.neko/.ui.MainActivity

STATUS=$(curl -s http://checkip.amazonaws.com)
curl -s "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=🔄 AUTOPILOT UPDATED%0A🌐 CDN: $IRAN_CDN%0A🔑 Key: ${PUBLIC_KEY:0:8}...%0A📡 IP: $STATUS"
