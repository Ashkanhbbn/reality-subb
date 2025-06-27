---

## 🟩 اسکریپت نهایی (ایده‌آل + مانیتورینگ و ALERT)
> اسکریپت پیشرفته با log لحظه‌ای، تشخیص قطعی/کندی، و ارسال نوتیفیکیشن محلی/تلگرام (در صورت نیاز)

```bash
#!/system/bin/sh
#
# GOD-MODE PRO v13 - Ultimate Net Boost & Monitoring Script
#

LOG_FILE="/data/local/tmp/god_mode_boost.log"
ALERT_ENABLED=true
TELEGRAM_BOT_TOKEN="YOUR_BOT_TOKEN"
TELEGRAM_CHAT_ID="YOUR_CHAT_ID"

# Log Function
log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] - $1" >> "$LOG_FILE"; }

# Send Alert Function
send_alert() {
  [ "$ALERT_ENABLED" = true ] && \
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" -d text="[$(date +'%H:%M:%S')] God-Mode Alert: $1" >/dev/null
}

# Check Root
if [ "$(id -u)" != "0" ]; then
  echo "❌ Root required." ; exit 1
fi

# Clear old log
echo "--- God Mode Boost v13 INIT ---" > "$LOG_FILE"
log "Root confirmed."

# Firewall Clean
iptables -F && iptables -t nat -F && iptables -t mangle -F
log "Firewall flushed."

# Kernel Optimization
log "Kernel TCP/IP optimizations..."
sysctl -w net.ipv4.tcp_fastopen=3
sysctl -w net.ipv4.tcp_window_scaling=1
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_sack=1
sysctl -w net.core.rmem_max=4194304
sysctl -w net.core.wmem_max=4194304
sysctl -w net.core.netdev_max_backlog=10000
sysctl -w net.ipv4.tcp_max_syn_backlog=30000
sysctl -w net.ipv4.tcp_mtu_probing=1
sysctl -w net.ipv4.tcp_slow_start_after_idle=0

# BBR v2
if grep -q "bbr" /proc/sys/net/ipv4/tcp_available_congestion_control; then
  sysctl -w net.ipv4.tcp_congestion_control=bbr
  log "BBR enabled."
else
  log "BBR not available."
fi

# Bufferbloat
tc qdisc add dev wlan0 root fq_codel 2>/dev/null
tc qdisc add dev rmnet_data0 root fq_codel 2>/dev/null
log "Queue discipline set."

# Disable IPv6
log "Disabling IPv6..."
for iface in $(ls /proc/sys/net/ipv6/conf/); do
    sysctl -w net.ipv6.conf.$iface.disable_ipv6=1
done
log "IPv6 disabled."

# Set emergency DNS
log "Setting emergency DNS..."
setprop net.dns1 1.1.1.1
setprop net.dns2 1.0.0.1
setprop net.dns3 8.8.8.8
log "DNS set."

# --- Real-Time Monitoring & Alert Loop ---
while true; do
  PING_MS=$(ping -c1 -W1 8.8.8.8 | grep 'time=' | awk -F'time=' '{print $2}' | cut -d' ' -f1 | cut -d'.' -f1)
  [ -z "$PING_MS" ] && PING_MS=9999
  log "Ping: $PING_MS ms"
  if [ "$PING_MS" -gt 700 ]; then
    log "ALERT: High ping detected! [$PING_MS ms]"
    send_alert "Network latency critical: $PING_MS ms"
  fi
  if [ "$PING_MS" -eq 9999 ]; then
    log "ALERT: Network disconnected!"
    send_alert "Network disconnected! Immediate check required."
  fi
  sleep 60
done &

log "🚀 God Mode Net Boost v13 successfully applied."
echo "✅ شبکه تقویت و پایش شد. لاگ: $LOG_FILE"
