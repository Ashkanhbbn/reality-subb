
---

### دستورات اضافی برای اجرای اسکریپت تقویت‌کننده

برای راحتی کاربران، یک فایل جداگانه برای اسکریپت تقویت‌کننده ایجاد کنید:

**نام فایل**: `iran_boost.sh`
```bash
#!/system/bin/sh
# ایران نتورک توربو بوست اسکریپت
# نسخه: 1.2
# آخرین به‌روزرسانی: 2025-06-28

log_file="/data/local/tmp/iran_boost.log"

# تابع لاگ
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> $log_file
}

# بررسی دسترسی روت
if [ "$(id -u)" != "0" ]; then
  echo "این اسکریپت نیاز به دسترسی روت دارد!"
  exit 1
fi

log "شروع اسکریپت تقویت‌کننده"

# پاک‌سازی قوانین فایروال
iptables -F
iptables -t nat -F
iptables -t mangle -F
ip6tables -F
ip6tables -t nat -F
log "پاک‌سازی قوانین فایروال انجام شد"

# بهینه‌سازی پارامترهای شبکه
sysctl -w net.ipv4.tcp_fastopen=3
sysctl -w net.ipv4.tcp_window_scaling=1
sysctl -w net.ipv4.tcp_tw_reuse=1
sysctl -w net.ipv4.tcp_sack=1
sysctl -w net.core.rmem_max=2500000
sysctl -w net.core.wmem_max=2500000
sysctl -w net.core.netdev_max_backlog=10000
sysctl -w net.ipv4.tcp_max_syn_backlog=30000
log "پارامترهای شبکه بهینه‌سازی شد"

# غیرفعال‌سازی IPv6
for iface in $(ip -o link show | awk -F': ' '{print $2}'); do
  sysctl -w net.ipv6.conf.$iface.disable_ipv6=1
done
log "IPv6 غیرفعال شد"

# بهینه‌سازی صف‌بندی ترافیک
tc qdisc add dev tun0 root sfq perturb 10 2>/dev/null
tc qdisc add dev wlan0 root sfq 2>/dev/null
log "صف‌بندی ترافیک بهینه‌سازی شد"

# فعال‌سازی TCP BBR
if grep -q "bbr" /proc/sys/net/ipv4/tcp_available_congestion_control; then
  echo "bbr" > /proc/sys/net/ipv4/tcp_congestion_control
  log "TCP BBR فعال شد"
fi

# تنظیمات پیشرفته TCP
echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
echo "15" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "1" > /proc/sys/net/ipv4/tcp_mtu_probing
echo "1" > /proc/sys/net/ipv4/tcp_low_latency
log "تنظیمات پیشرفته TCP اعمال شد"

# تنظیم DNS اضطراری
setprop net.dns1 1.1.1.1
setprop net.dns2 8.8.8.8
log "DNS اضطراری تنظیم شد"

log "اسکریپت با موفقیت اجرا شد!"
echo "شبکه شما با موفقیت تقویت شد!"
