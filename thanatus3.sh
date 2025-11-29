#!/bin/bash

# THANATUS Multi-Tool v3
# Güvenli Pentest Paneli
# GitHub: https://github.com/thanatus-098
# Telegram: @thanatus098

LOGDIR="logs"
mkdir -p $LOGDIR

banner() {
clear
echo -e "\e[91m
████████╗██╗  ██╗ █████╗ ███╗   ██╗ █████╗ ████████╗██╗   ██╗███████╗
╚══██╔══╝██║  ██║██╔══██╗████╗  ██║██╔══██╗╚══██╔══╝██║   ██║██╔════╝
   ██║   ███████║███████║██╔██╗ ██║███████║   ██║   ██║   ██║█████╗  
   ██║   ██╔══██║██╔══██║██║╚██╗██║██╔══██║   ██║   ╚██╗ ██╔╝██╔══╝  
   ██║   ██║  ██║██║  ██║██║ ╚████║██║  ██║   ██║    ╚████╔╝ ███████╗
   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝     ╚═══╝  ╚══════╝
\e[0m"
echo -e "\033[96m                     Telegram: @thanatus098\033[0m\n"
}

log() {
    echo "[$(date)] $1" >> "$LOGDIR/thanatus.log"
}

# 1. Site güvenliği kontrolü
check_security() {
    read -p "Hedef site: " target
    out="report_$target.html"
    log "Security scan başlatıldı: $target"

    echo "<h1>THANATUS Raporu</h1>" > $out
    echo "<h3>Hedef: $target</h3>" >> $out

    echo -e "\n--- SSL TEST ---"
    ssl=$(echo | openssl s_client -connect $target:443 2>/dev/null | openssl x509 -noout -dates -issuer -subject)
    echo "<pre>$ssl</pre>" >> $out

    echo -e "\n--- HEADER TEST ---"
    header=$(curl -I -s https://$target)
    echo "<pre>$header</pre>" >> $out

    echo -e "\n--- NMAP (pasif mod) ---"
    ports=$(nmap -Pn -T4 $target)
    echo "<pre>$ports</pre>" >> $out

    echo -e "\n--- WHOIS ---"
    who=$(whois $target | head -n 30)
    echo "<pre>$who</pre>" >> $out

    echo -e "\n--- DNS ---"
    dns=$(dig $target ANY +short)
    echo "<pre>$dns</pre>" >> $out

    echo -e "\n--- NIKTO (zararsız mod) ---"
    nik=$(nikto -host $target)
    echo "<pre>$nik</pre>" >> $out

    log "Security scan tamamlandı: $target"
    echo -e "\033[92mRapor oluşturuldu: $out\033[0m"
}

# 2. URL kısaltıcı
url_shortener() {
    read -p "Kısaltılacak URL: " longurl
    short=$(curl -s "https://is.gd/create.php?format=simple&url=$longurl")
    echo -e "Kısa Link: \033[92m$short\033[0m"
}

# 3 — WAF tespiti
waf_detect() {
    read -p "Site: " site
    wafw00f $site
}

# 4 — CMS Tespiti
cms_detect() {
    read -p "Site: " site
    whatweb $site
}

# 5 — Subdomain tarama
subdomain_scan() {
    read -p "Domain: " domain
    echo "--- Amass ---"
    amass enum -d $domain
    echo "--- Subfinder ---"
    subfinder -d $domain
}

# 6 — PDF rapor dönüştürme
convert_pdf() {
    read -p "HTML rapor: " html
    pdf="${html%.html}.pdf"
    wkhtmltopdf $html $pdf
    echo "PDF oluşturuldu: $pdf"
}

# 7 — Full scan
full_scan() {
    read -p "Hedef site: " target
    check_security $target
    waf_detect $target
    cms_detect $target
    subdomain_scan $target
}

# 8 — SQL Injection pasif test
sql_passive() {
    read -p "Site URL: " site
    echo "[+] Basit SQLi kontrolü yapılıyor..."
    test=$(curl -s "$site'" | grep -Ei "sql|syntax|mysql|error|ODBC|PDO")
    if [[ -n "$test" ]]; then
        echo -e "\033[91mMuhtemel SQLi belirtisi bulundu!\033[0m"
        echo "$test"
    else
        echo -e "\033[92mSQL zafiyeti belirtisi bulunamadı.\033[0m"
    fi
}

# 9 — XSS pasif tarayıcı
xss_passive() {
    read -p "Site URL: " site
    payload="<script>alert(1)</script>"
    test=$(curl -s "$site?test=$payload" | grep "$payload")
    if [[ -n "$test" ]]; then
        echo -e "\033[91mXSS açığına benzer davranış tespit edildi!\033[0m"
    else
        echo -e "\033[92mXSS belirtisi yok.\033[0m"
    fi
}

# 10 — Reverse IP Lookup (pasif OSINT)
reverse_ip() {
    read -p "IP veya Domain: " target
    curl -s "https://api.hackertarget.com/reverseiplookup/?q=$target"
}

# 11 — Mass Scan (port + SSL + header)
mass_scan() {
    read -p "Domain listesi (dosya yolu): " file
    while read url; do
        echo "Tarama: $url"
        nmap -Pn -p 80,443 $url
        curl -I -s https://$url | head -n 5
        echo
    done < "$file"
}

# 12 — WordPress güvenlik kontrolü
wp_scan_safe() {
    read -p "WordPress site: " site
    whatweb $site
}

# 13 — robots.txt / sitemap
robots_scan() {
    read -p "Site: " site
    curl -s "$site/robots.txt"
    curl -s "$site/sitemap.xml"
}

# 14 — OSINT bilgi toplama
osint_scan() {
    read -p "Domain: " domain
    dig $domain ANY
    whois $domain
}

# 15 — Log görüntüleyici
view_logs() {
    cat $LOGDIR/thanatus.log
}

menu() {
banner
echo -e "\033[93m[1]\033[0m Site güvenliği kontrolü"
echo -e "\033[93m[2]\033[0m URL kısaltıcı"
echo -e "\033[93m[3]\033[0m WAF tespit"
echo -e "\033[93m[4]\033[0m CMS tespit"
echo -e "\033[93m[5]\033[0m Subdomain tarama"
echo -e "\033[93m[6]\033[0m HTML ➜ PDF"
echo -e "\033[93m[7]\033[0m Full Scan"
echo -e "\033[93m[8]\033[0m SQL Injection (pasif)"
echo -e "\033[93m[9]\033[0m XSS Test (pasif)"
echo -e "\033[93m[10]\033[0m Reverse IP Lookup"
echo -e "\033[93m[11]\033[0m Mass Scan"
echo -e "\033[93m[12]\033[0m WordPress güvenlik kontrolü"
echo -e "\033[93m[13]\033[0m robots.txt & sitemap analizi"
echo -e "\033[93m[14]\033[0m OSINT Bilgi Toplama"
echo -e "\033[93m[15]\033[0m Log Kayıtları"
echo -e "\033[93m[0]\033[0m Çıkış\n"
read -p "Seçenek: " s

case $s in
    1) check_security ;;
    2) url_shortener ;;
    3) waf_detect ;;
    4) cms_detect ;;
    5) subdomain_scan ;;
    6) convert_pdf ;;
    7) full_scan ;;
    8) sql_passive ;;
    9) xss_passive ;;
    10) reverse_ip ;;
    11) mass_scan ;;
    12) wp_scan_safe ;;
    13) robots_scan ;;
    14) osint_scan ;;
    15) view_logs ;;
    0) exit ;;
    *) menu ;;
esac
}

menu
