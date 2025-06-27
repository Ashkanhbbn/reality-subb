#!/bin/bash
# AUTOGEN SCRIPT v3

# تولید مقادیر تصادفی
UUID=$(cat /proc/sys/kernel/random/uuid)
PUBLIC_KEY=$(openssl rand -base64 32 | tr -d '\n')
SHORT_ID=$(openssl rand -hex 2)
IRAN_CDN=$(shuf -n1 -e "edge.snappfood.ir" "cdn.snapp.ir" "dl.digikala.com")
IRAN_DOMAIN=$(shuf -n1 -e "www.digikala.com" "www.torob.com" "www.sheypoor.com")
IRAN_PATH="/$(tr -dc a-z </dev/urandom | head -c 8)"

# به‌روزرسانی فایل کانفیگ
sed -i "s/{{ uuid }}/$UUID/g" $CONFIG_PATH
sed -i "s/{{ public_key }}/$PUBLIC_KEY/g" $CONFIG_PATH
sed -i "s/{{ short_id }}/$SHORT_ID/g" $CONFIG_PATH
sed -i "s/{{ iran_cdn }}/$IRAN_CDN/g" $CONFIG_PATH
sed -i "s/{{ iran_domain }}/$IRAN_DOMAIN/g" $CONFIG_PATH
sed -i "s|{{ iran_path }}|$IRAN_PATH|g" $CONFIG_PATH

# راه‌اندازی مجدد سرویس
pkill -f nekobox
sleep 2
am start -n moe.nb4l.neko/.ui.MainActivity

# گزارش به تلگرام
curl -s "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=🔄 سیستم بازسازی شد%0A🔑 کلید جدید: ${PUBLIC_KEY:0:8}...%0A🌐 CDN: $IRAN_CDN"
