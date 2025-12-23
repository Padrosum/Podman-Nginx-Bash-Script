#!/bin/bash



# Renkler
YESIL='\033[0;32m'
SARI='\033[1;33m'
KIRMIZI='\033[0;31m'
NC='\033[0m'

# --- KULLANIM KILAVUZU ---
# Eğer kullanıcı argüman girmezse nasıl kullanılacağını göster
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "HATA: Eksik parametre girdiniz."
    echo "  "
    echo -e "${KIRMIZI}Kullanım: ${NC} ./nginx_multi.sh [ISIM] [PORT]"
    echo -e "${SARI}Örnek:   ${NC} ./nginx_multi.sh site1 8081"
    echo -e "${SARI}Örnek:   ${NC} ./nginx_multi.sh blog 8082"
    exit 1
fi

# --- DİNAMİK AYARLAR ---
# $1 = Scripti çalıştırırken yazdığın ilk kelime (İsim)
# $2 = Scripti çalıştırırken yazdığın ikinci kelime (Port)
KONTEYNER_ADI="$1"
PORT="$2"

# Tüm projeleri düzenli tutmak için ana bir klasör altında topluyoruz
PROJE_DIZINI="$HOME/podman-websiteleri/$KONTEYNER_ADI"
IMAGE="docker.io/library/nginx:latest"


echo -e "${YESIL}--- Podman Kurulumu Başlatılıyor: $KONTEYNER_ADI ($PORT) ---${NC}"

# 1. Klasör Yapısını Oluştur
echo -e "${SARI}[*] Klasörler oluşturuluyor: $PROJE_DIZINI ${NC}"
mkdir -p "$PROJE_DIZINI/html"
mkdir -p "$PROJE_DIZINI/conf"

# 2. Örnek HTML Dosyası (Özel İçerik)
if [ ! -f "$PROJE_DIZINI/html/index.html" ]; then
    echo -e "${SARI}[*] index.html oluşturuluyor...${NC}"
    cat <<EOF > "$PROJE_DIZINI/html/index.html"
<!DOCTYPE html>
<html>
<head><title>$KONTEYNER_ADI</title></head>
<body style="background-color:#222; color:#fff; font-family:sans-serif; text-align:center; padding-top:50px;">
    <h1>Merhaba! Burası: <span style="color:#0f0;">$KONTEYNER_ADI</span></h1>
    <p>Bu site $PORT portunda çalışıyor.</p>
</body>
</html>
EOF
fi

# 3. Config Dosyası (Orijinalini Çek)
if [ ! -f "$PROJE_DIZINI/conf/nginx.conf" ]; then
    echo -e "${SARI}[*] Orijinal nginx.conf kopyalanıyor...${NC}"
    # İsim çakışmasını önlemek için geçici konteynera rastgele sayı ekle
    TEMP_NAME="temp-nginx-$RANDOM"
    podman run --name $TEMP_NAME -d $IMAGE > /dev/null
    podman cp $TEMP_NAME:/etc/nginx/nginx.conf "$PROJE_DIZINI/conf/nginx.conf"
    podman rm -f $TEMP_NAME > /dev/null
fi

# 4. Eski Konteyner Temizliği (Aynı isimde varsa sil)
if podman ps -a --format "{{.Names}}" | grep -q "^$KONTEYNER_ADI$"; then
    echo -e "${SARI}[*] Eski $KONTEYNER_ADI siliniyor...${NC}"
    podman rm -f $KONTEYNER_ADI > /dev/null
fi

# 5. Yeni Konteyneri Başlat
echo -e "${SARI}[*] Konteyner başlatılıyor...${NC}"

podman run -dt \
  --name "$KONTEYNER_ADI" \
  -p $PORT:80 \
  -v "$PROJE_DIZINI/html":/usr/share/nginx/html:Z \
  -v "$PROJE_DIZINI/conf/nginx.conf":/etc/nginx/nginx.conf:Z \
  $IMAGE

# 6. Sonuç
if [ $? -eq 0 ]; then
    echo -e "\n${YESIL}--- BAŞARILI! ---${NC}"
    echo -e "Site Adresi: http://localhost:$PORT"
    echo -e "Dosyalar: $PROJE_DIZINI"
else
    echo -e "\n${KIRMIZI}[HATA] Port dolu olabilir veya Podman hatası.${NC}"
fi
