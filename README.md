# Reality-Subb - Ultimate Anti-Censorship Solution for Iran

![Iran Network Bypass](https://i.imgur.com/encrypted.png)

**پیکربندی فوق‌پیشرفته برای عبور از فیلترینگ ایران با حداکثر پایداری و سرعت**

## ویژگی‌های کلیدی 🔥

- ☁️ **استفاده از CDN های ایرانی** برای استتار ترافیک
- 🔒 **ترکیب ۵ پروتکل مختلف** (Reality, Trojan, VMess, Shadowsocks, Hysteria2)
- 📡 **سیستم DNS هوشمند** با اولویت‌دهی به سرورهای ایرانی ضد فیلتر
- ⚡ **بهینه‌سازی شبکه** برای کاهش تاخیر در شبکه‌های ایرانی
- 🤖 **سیستم به‌روزرسانی خودکار** هر ۶ ساعت
- 🔄 **مکانیزم چرخشی** برای جلوگیری از شناسایی
- 🛡️ **مکانیزم‌های ضد DPI** برای عبور از عمیق‌ترین فیلترینگ

## راهنمای استفاده 🚀

1. **پیش‌نیازها**:
   - نصب آخرین نسخه [NekoBox](https://github.com/MatsuriDayo/NekoBoxForAndroid/releases)
   - دریافت UUID و Public Key از ارائه‌دهنده سرویس

2. **نصب**:
   - در NekoBox به بخش **Profiles** بروید
   - لینک زیر را وارد کنید:
     ```
     https://raw.githubusercontent.com/yourusername/reality-subb/main/reality.yaml
     ```
   - مقادیر `YOUR_UUID_HERE` و `YOUR_PUBLIC_KEY_HERE` را جایگزین کنید

3. **تنظیمات حیاتی**:
   ```ini
   [TUN Mode]: Full
   [UDP Forwarding]: Enabled
   [Sniffing]: Full
   [Mux]: Disabled
   [DNS Settings]: 
     Remote DNS = https://shecan.ir/dns-query
     Fallback DNS = tls://dns11.quad9.net:853
