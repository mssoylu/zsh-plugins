#!/bin/bash

mkdir -p "$HOME/.oh-my-zsh/plugins/vhost-edit/"
mkdir -p "$HOME/.oh-my-zsh/plugins/vhost-add/"
mkdir -p "$HOME/.oh-my-zsh/plugins/vhost-rm/"

cp vhost-edit.plugin.zsh "$HOME/.oh-my-zsh/plugins/vhost-edit/vhost-edit.plugin.zsh"
cp vhost-add.plugin.zsh "$HOME/.oh-my-zsh/plugins/vhost-add/vhost-add.plugin.zsh"
cp vhost-rm.plugin.zsh "$HOME/.oh-my-zsh/plugins/vhost-rm/vhost-rm.plugin.zsh"

# Fonksiyon: Belirtilen Zsh plugin'ini ekler ve Zsh'yi yeniden başlatır
add_zsh_plugin() {
    local pluginName=$1
    local zshrcFile="$HOME/.zshrc"

    # Eğer plugins satırı zaten varsa sadece eklenen plugin kontrol edilir
    if grep -q "plugins" "$zshrcFile"; then
        # Eğer belirtilen plugin zaten ekli değilse ekle
        if ! grep -q "$pluginName" "$zshrcFile"; then
            sed -i "/plugins/s/=(/=($pluginName /" "$zshrcFile"
        fi
    else
        # Eğer plugins satırı yoksa yeni satır eklenir
        echo "plugins=($pluginName)" >> "$zshrcFile"
    fi

    # Zsh'i yeniden başlat
    exec zsh
}
# Örnek kullanım
add_zsh_plugin "vhost-add"
add_zsh_plugin "vhost-edit"
add_zsh_plugin "vhost-rm"

