# ~/.oh-my-zsh/custom/plugins/vhost-add/vhost-create.plugin.zsh

# Virtual host dosyalarının bulunduğu dizin
vhostDir="/etc/apache2/sites-available/"

# vhost-add komutunu tanımla
function vhost-add() {
    local vhostName=$1

    # Eğer argüman verilmediyse hata mesajı gönder
    if [ -z "$vhostName" ]; then
        echo "Hata: Lütfen bir virtual host adı belirtin."
        return 1
    fi

    # Virtual host dosyasının tam yolu
    local vhostFile="${vhostDir}${vhostName}.conf"

    # Eğer virtual host dosyası zaten varsa hata mesajı gönder
    if [ -e "$vhostFile" ]; then
        echo "Hata: $vhostName adında bir virtual host zaten mevcut."
        return 1
    fi

    # Virtual host dosyasını oluştur
    echo "<VirtualHost *:80>
    ServerName  $vhostName
    ServerAlias www.$vhostName
    DocumentRoot /var/www/$vhostName/root/public
    <Directory /var/www/$vhostName/root/public>
        DirectoryIndex index.php
        AllowOverride All
        Order allow,deny
        Allow from all
        Options FollowSymLinks
        AllowOverride All
        Require all granted
        RewriteEngine On
        RewriteBase /
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule (.*) /index.php/$1 [L]
        RewriteCond %{HTTP:Authorization} ^(.*)
        RewriteRule .* - [e=HTTP_AUTHORIZATION:%1]
    </Directory>
</VirtualHost>" | sudo tee "$vhostFile" > /dev/null

    # Virtual host dizinini oluştur
    sudo mkdir -p "/var/www/$vhostName/root/public"

    # Virtual host dosyasını düzenle
    vhost "$vhostName"
}

# Tab tamamlama işlevini manuel olarak tanımla
compctl -K _vhost_add_complete vhost-create

# Virtual host dosyalarını tamamlayan fonksiyon
_vhost_add_complete() {
    local vhostFiles
    vhostFiles=(${vhostDir}*.conf)

    # Dosya isimlerini yalnızca dosya adına dönüştür
    reply=("${(@)vhostFiles##*/}")
}

