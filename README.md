# thanatus-tool
THANATUS Multi-Tool v3 - Savunma amaçlı pentest aracıdır
# 🔥 THANATUS MULTI-TOOL v3
Geliştirici: **thanatus-098**  
Telegram: **@thanatus098**  
GitHub: **https://github.com/thanatus-098**

THANATUS MULTI-TOOL v3, Kali Linux ve Termux üzerinde çalışan **savunma amaçlı pentest** aracıdır.  
Saldırı içermez, sadece pasif testler ve güvenlik analizi yapar.

---

## 🔥 ÖZELLİKLER

✔ Site güvenliği tarama  
✔ URL kısaltıcı  
✔ WAF tespiti  
✔ CMS tespiti  
✔ Subdomain tarama (amass + subfinder)  
✔ HTML → PDF rapor  
✔ SQL Injection pasif kontrol  
✔ XSS tespiti  
✔ Reverse IP lookup  
✔ Mass scan (pasif port + SSL taraması)  
✔ WordPress güvenlik analizi  
✔ robots.txt / sitemap analizi  
✔ OSINT toplama  
✔ Log sistemi  
✔ Full Scan modu  

Hepsi tek bir panel içinde.

---

## 📌 KURULUM

### 📍 KALI LINUX

```bash
sudo apt update
sudo apt install nmap whois curl openssl dnsutils nikto whatweb wafw00f amass wkhtmltopdf git -y
git clone https://github.com/thanatus-098/thanatus-tool
cd thanatus-tool
chmod +x thanatus3.sh
./thanatus3.sh
```

---

### 📍 TERMUX

```bash
pkg update
pkg install nmap whois curl openssl dnsutils git -y
pip install subfinder wafw00f

git clone https://github.com/thanatus-098/thanatus-tool
cd thanatus-tool
chmod +x thanatus3.sh
./thanatus3.sh
```

---

## 📌 ÇALIŞTIRMA

```bash
./thanatus3.sh
```

---

## 📌 LİSANS

MIT Lisansı ile yayınlanmıştır.  
Tamamen **yasal ve savunma amaçlı analiz** için tasarlanmıştır.

