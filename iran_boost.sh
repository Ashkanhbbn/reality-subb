#!/system/bin/sh
# GOD-MODE PRO v13 - Ultimate Net Boost & Monitoring
# Last Updated: 2025-07-01

# ===== تنظیمات =====
LOG_FILE="/data/local/tmp/god_mode_boost.log"
ALERT_TELEGRAM=true
TELEGRAM_BOT_TOKEN="YOUR_BOT_TOKEN"
TELEGRAM_CHAT_ID="YOUR_CHAT_ID"
MONITOR_INTERVAL=60

# ===== توابع =====
log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE; }
send_alert() { [ "$ALERT_TELEGRAM" = true ] && curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d chat_id="$TELEGRAM_CHAT_ID" -d text="$1" >/dev/null; }
rotate_log() { [ $(stat -c%s $LOG_FILE) -gt 10000000 ] && mv $LOG_FILE $LOG_FILE.old; }

# ===== بررسی روت =====
if [ "$(id -u)" != "0" ]; then
  echo "❌ نیاز به دسترسی روت دارد!" | tee -a $LOG_FILE
  exit 1
fi

# ===== شروع لاگ =====
echo "=== GOD-MODE PRO v13 - BOOST STARTED ===" > $LOG_FILE
log "سیستم تقویت و مانیتورینگ فعال شد"
send_alert "🟢 سیستم GOD-MODE PRO روی دستگاه فعال شد"

# ===== بهینه‌سازی شبکه =====
log "بهینه‌سازی پارامترهای هسته"
sysctl -w net.ipv4.tcp_fastopen=3
sysctl -w net.ipv4.tcp_window_scaling=1
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.core.rmem_max=2500000
sysctl -w net.core.wmem_max=2500000
sysctl -w net.ipv4.tcp_mtu_probing=1
sysctl -w net.ipv4.tcp_slow_start_after_idle=0

# فعال‌سازی TCP BBR
if grep -q "bbr" /proc/sys/net/ipv4/tcp_available_congestion_control; then
  sysctl -w net.ipv4.tcp_congestion_control=bbr
  log "فعال‌سازی TCP BBR"
fi

# ===== بهینه‌سازی ترافیک =====
log "بهینه‌سازی صف‌های ترافیک"
for iface in $(ip link show | grep 'state UP' | awk -F': ' '{print $2}'); do
  tc qdisc add dev $iface root fq_codel 2>/dev/null
  log "بهینه‌سازی $iface"
done

# ===== ضد DPI =====
log "فعال‌سازی مکانیزم‌های ضد DPI"
iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
ip6tables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# ===== مانیتورینگ لحظه‌ای =====
log "شروع سیستم مانیتورینگ"
while true; do
  rotate_log
  # تست سرعت پایه
  PING_GOOGLE=$(ping -c1 -W1 8.8.8.8 | grep 'time=' | cut -d'=' -f4 | cut -d' ' -f1)
  PING_DIGI=$(ping -c1 -W1 www.digikala.com | grep 'time=' | cut -d'=' -f4 | cut -d' ' -f1)
  
  # تشخیص وضعیت
  if [ -z "$PING_GOOGLE" ]; then
    log "⛔ قطعی کامل شبکه!"
    send_alert "⛔ قطعی کامل شبکه! بررسی فوری"
  elif [ $(echo "$PING_GOOGLE > 500" | bc -l) -eq 1 ]; then
    log "⚠️ تاخیر بالا: ${PING_GOOGLE}ms"
    send_alert "⚠️ تاخیر شبکه: ${PING_GOOGLE}ms"
  fi
  
  # تست سرعت پیشرفته (هر ۵ دقیقه)
  if [ $(( $(date +%s) % 300 )) -eq 0 ]; then
    SPEED_TEST=$(curl -s https://speedtest.yourdomain.com/test | grep 'Speed:' | awk '{print $2}')
    log "سرعت واقعی: ${SPEED_TEST}Mbps"
  fi
  
  sleep $MONITOR_INTERVAL
done &

# ===== سیستم بازیابی خودکار =====
log "فعال‌سازی سیستم بازیابی خودکار"
while true; do
  if ! ping -c1 8.8.8.8 &>/dev/null; then
    log "تلاش بازیابی شبکه..."
    svc wifi disable && svc wifi enable
    sleep 10
    [ $? -eq 0 ] && send_alert "🔄 شبکه با موفقیت بازسازی شد"
  fi
  sleep 60
done
