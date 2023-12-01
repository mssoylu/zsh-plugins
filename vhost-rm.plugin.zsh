# ~/.oh-my-zsh/custom/plugins/vhost-rm/vhost-rm.plugin.zsh

# Fonksiyon: Belirtilen VirtualHost dosyasını siler ve siteyi devre dışı bırakır
vhost-rm() {
    local vhostName=$1
    local vhostFile="/etc/apache2/sites-enabled/${vhostName}.conf"

    # Eğer belirtilen VirtualHost dosyası zaten varsa sil ve devre dışı bırak
    if [ -e "$vhostFile" ]; then
        sudo a2dissite "$vhostName"
        sudo rm "$vhostFile"
        echo "VirtualHost '$vhostName' başarıyla silindi ve devre dışı bırakıldı."
    else
        echo "Hata: '$vhostName' adında bir VirtualHost dosyası bulunamadı."
    fi
}

# Zsh tab tamamlama işlevini belirtilen VirtualHost dosyalarıyla sınırla
_vhost_files_complete() {
    local vhostFiles
    vhostFiles=(/etc/apache2/sites-enabled/*.conf(N:t))

    # Dosya isimlerini döndür
    reply=($vhostFiles)
}

# Tab tamamlama işlevini manuel olarak tanımla
compctl -K _vhost_files_complete vhost-rm

# Alias: 'vhost-rm' komutunu 'vhost-rm' fonksiyonuna bağla
alias vhost-rm=vhost-rm

