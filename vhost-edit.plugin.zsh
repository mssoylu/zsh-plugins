# ~/.oh-my-zsh/custom/plugins/vhost/vhost.plugin.zsh

# Virtual host dosyalarının bulunduğu dizin
vhostDir="/etc/apache2/sites-available/"

# vhost komutunu tanımla
function vhost() {
    local vhostFiles
    vhostFiles=(${vhostDir}*.conf)

    # Eğer virtual host dosyası bulunamazsa hata mesajı gönder
    if [ -z "$vhostFiles" ]; then
        echo "Hata: Virtual host dosyaları bulunamadı."
        return 1
    fi

    # Eğer hiçbir argüman verilmediyse, virtual host dosyalarını listele
    if [ $# -eq 0 ]; then
        echo "Mevcut Virtual Host Dosyaları:"
        for file in $vhostFiles; do
            echo "$(basename $file)"
        done
    else
        # Eğer argüman verilmişse ve dosya bulunmuşsa, vim ile aç
        local selectedFile="$vhostDir$1"
        if [ -f "$selectedFile" ]; then
            vim "$selectedFile"
        else
            echo "Hata: $1 adında bir virtual host dosyası bulunamadı."
            return 1
        fi
    fi
}

# Tab tamamlama işlevini manuel olarak tanımla
compctl -K _vhost_complete vhost-edit

# Virtual host dosyalarını tamamlayan fonksiyon
_vhost_complete() {
    local vhostFiles
    vhostFiles=(${vhostDir}*.conf)

    # Dosya isimlerini yalnızca dosya adına dönüştür
    reply=("${(@)vhostFiles##*/}")
}

