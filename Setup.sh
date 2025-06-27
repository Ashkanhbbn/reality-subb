#!/bin/bash
# AUTOPILOT INSTALLER v2

# تنظیم متغیرها
CONFIG_PATH="/sdcard/nekobox/auto_config.yaml"
SSH_KEY="/sdcard/ssh/id_rsa"

# تولید کلید SSH (اگر وجود ندارد)
if [ ! -f "$SSH_KEY" ]; then
  ssh-keygen -t rsa -b 4096 -f "$SSH_KEY" -N ""
fi

# دریافت اسکریپت‌های به‌روز
curl -O https://raw.githubusercontent.com/yourrepo/autopilot/main/autogen.sh
curl -O https://raw.githubusercontent.com/yourrepo/autopilot/main/sync_keys.sh

# تنظیم مجوزها
chmod +x autogen.sh sync_keys.sh

# ایجاد سرویس دوره‌ای
echo "*/5 * * * * /data/autopilot/autogen.sh" > /etc/cron.d/autopilot
echo "0 3 * * * /data/autopilot/sync_keys.sh" >> /etc/cron.d/autopilot

# شروع سیستم
nohup ./autogen.sh > /dev/null 2>&1 &
