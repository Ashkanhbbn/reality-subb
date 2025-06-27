#!/system/bin/sh
#
# ██▓███   ██▓ ██▒   █▓ ▄▄▄       ██████  ▄▄▄█████▓
#▓██░  ██▒▓██▒▓██░   █▒▒████▄    ▒██    ▒ ▓  ██▒ ▓▒
#▓██░ ██▓▒▒██▒ ▓██  █▒░▒██  ▀█▄  ░ ▓██▄   ▒ ▓██░ ▒░
#▒██▄█▓▒ ▒░██░  ▒██ █░░░██▄▄▄▄██   ▒   █▒ ░ ▓██▓ ░ 
#▒██▒ ░  ░░██░   ▒▀█░   ▓█   ▓██▒▒██████▒▒  ▒██▒ ░ 
#▒▓▒░ ░  ░░▓     ░ ▐░   ▒▒   ▓▒█░▒ ▒▓▒ ▒ ░  ▒ ░░   
#░▒ ░      ▒ ░   ░ ░░    ▒   ▒▒ ░░ ░▒  ░ ░    ░    
#░░        ▒ ░     ░░    ░   ▒   ░  ░  ░    ░      
#          ░        ░        ░  ░      ░           
#
# GOD-MODE PRO Network Boost Script v2.0
#
# هدف: بهینه‌سازی پارامترهای هسته لینوکس برای کاهش تاخیر، افزایش توان عملیاتی (throughput)
# و پایدارسازی اتصال VPN در شبکه‌های پر اختلال ایران.
#
# نیازمند دسترسی روت (Root Access)
#

# --- متغیرها ---
LOG_FILE="/data/local/tmp/god_mode_boost.log"

# --- توابع ---
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] - $1" >> "$LOG_FILE"
}

# --- شروع اسکریپت ---

# 1. بررسی دسترسی روت
if [ "$(id -u)" != "0" ]; then
  echo "❌ خطا: این اسکریپت برای اجرا نیازمند دسترسی روت است."
  exit 1
fi

# پاک کردن لاگ قبلی و شروع لاگ جدید
echo "--- God Mode Boost Script Initialized ---" > "$LOG_FILE"
log "Root access confirmed. Starting optimization..."

# 2. پاک‌سازی قوانین فایروال (برای شروعی تمیز)
iptables -F && iptables -t nat -F && iptables -t mangle -F
log "Firewall rules flushed."

# 3. بهینه‌سازی پارامترهای TCP/IP هسته (Kernel)
log "Applying TCP/IP kernel optimizations..."
sysctl -w net.ipv4.tcp_fastopen=3               # فعال‌سازی کامل TCP Fast Open
sysctl -w net.ipv4.tcp_window_scaling=1         # فعال‌سازی مقیاس‌پذیری پنجره TCP
sysctl -w net.ipv4.tcp_tw_reuse=1               # استفاده مجدد از سوکت‌ها در حالت TIME_WAIT
sysctl -w net.ipv4.tcp_sack=1                   # فعال‌سازی Selective Acknowledgement
sysctl -w net.core.rmem_max=4194304             # افزایش حداکثر بافر دریافت
sysctl -w net.core.wmem_max=4194304             # افزایش حداکثر بافر ارسال
sysctl -w net.core.netdev_max_backlog=10000     # افزایش صف بسته‌های ورودی
sysctl -w net.ipv4.tcp_max_syn_backlog=30000    # افزایش صف SYN
sysctl -w net.ipv4.tcp_mtu_probing=1            # فعال‌سازی خودکار کشف MTU
sysctl -w net.ipv4.tcp_slow_start_after_idle=0  # جلوگیری از کند شدن اتصال پس از عدم فعالیت

# 4. فعال‌سازی الگوریتم کنترل ازدحام Google BBR v2 (در صورت وجود)
if grep -q "bbr" /proc/sys/net/ipv4/tcp_available_congestion_control; then
  sysctl -w net.ipv4.tcp_congestion_control=bbr
  log "TCP Congestion Control set to BBR."
else
  log "BBR not available. Sticking with default (cubic/reno)."
fi

# 5. بهینه‌سازی صف‌بندی بسته‌ها (Queue Discipline) برای کاهش Bufferbloat
# این دستورات ممکن است در برخی دستگاه‌ها خطا دهند که طبیعی است
tc qdisc add dev wlan0 root fq_codel 2>/dev/null
tc qdisc add dev rmnet_data0 root fq_codel 2>/dev/null
log "Packet queue discipline set to fq_codel for wlan0 and mobile data."

# 6. غیرفعال‌سازی IPv6 (بسیاری از اختلالات به دلیل پیاده‌سازی ضعیف آن در شبکه ایران است)
log "Disabling IPv6 on all interfaces..."
for iface in $(ls /proc/sys/net/ipv6/conf/); do
    sysctl -w net.ipv6.conf.$iface.disable_ipv6=1
done
log "IPv6 has been disabled."

# 7. تنظیم DNS اضطراری در سطح سیستم‌عامل (Android Specific)
log "Setting system-level emergency DNS properties..."
setprop net.dns1 1.1.1.1
setprop net.dns2 1.0.0.1
setprop net.dns3 8.8.8.8
log "Emergency DNS set to Cloudflare & Google."

# --- پایان اسکریپت ---
log "🚀 Network Boost successfully applied. God Mode is ON!"
echo "✅ تقویت شبکه با موفقیت انجام شد. برای مشاهده جزئیات، فایل لاگ را در مسیر زیر بررسی کنید:"
echo "$LOG_FILE"
