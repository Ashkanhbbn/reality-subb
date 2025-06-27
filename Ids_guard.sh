#!/bin/bash
# IDS GUARD

LOG="/sdcard/nekobox/ids.log"
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

if dmesg | grep -i "DPI BLOCK DETECTED"; then
  pkill -f nekobox
  iptables -F
  echo "🔥 DPI block detected, connection terminated" >> $LOG
  curl -s "https://api.telegram.org/bot$BOT_TOKEN/sendMessage?chat_id=$CHAT_ID&text=🔥 DPI Block! Service temporarily stopped."
fi
