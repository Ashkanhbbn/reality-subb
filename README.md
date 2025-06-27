# Reality-Subb - Ultimate Anti-Censorship Solution for Iran

![Iran Network Bypass](https://i.imgur.com/encrypted.png)

**پیکربندی فوق‌پیشرفته برای عبور از فیلترینگ ایران با حداکثر پایداری و سرعت**

## ویژگی‌های کلیدی 🔥

- ☁️ **استفاده از CDN های ایرانی** برای استتار ترافیک
- 🔒 **ترکیب ۶ پروتکل مختلف** (Reality, Trojan, VMess, Shadowsocks, Hysteria2 + پشتیبان اضطراری)
- 📡 **سیستم DNS هوشمند** با اولویت‌دهی به سرورهای ایرانی ضد فیلتر
- ⚡ **اسکریپت تقویت‌کننده شبکه** برای دستگاه‌های روت شده
- 🤖 **سیستم به‌روزرسانی خودکار** هر ۶ ساعت
- 🔄 **مکانیزم چرخشی** برای جلوگیری از شناسایی
- 🛡️ **مکانیزم‌های ضد DPI** برای عبور از عمیق‌ترین فیلترینگ
- 🚨 **سیستم پشتیبان اضطراری** برای شرایط بحرانی

## راهنمای استفاده 🚀

### نصب اصلی
1. **پیش‌نیازها**:
   - نصب آخرین نسخه [NekoBox](https://github.com/MatsuriDayo/NekoBoxForAndroid/releases)
   - دریافت UUID و Public Key از ارائه‌دهنده سرویس

2. **نصب کانفیگ**:
   - در NekoBox به بخش **Profiles** بروید
   - لینک زیر را وارد کنید:
     ```
     https://raw.githubusercontent.com/yourusername/reality-subb/main/reality.yaml
     ```
   - مقادیر `YOUR_UUID_HERE` و `YOUR_PUBLIC_KEY_HERE` را جایگزین کنید

### اسکریپت تقویت‌کننده (برای دستگاه‌های روت شده)
```bash
# دانلود اسکریپت
curl -O https://raw.githubusercontent.com/yourusername/reality-subb/main/iran_boost.sh

# اجرا
su -c "sh iran_boost.sh"
