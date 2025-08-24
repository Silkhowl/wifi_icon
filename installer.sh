#!/bin/bash

# This script is part of My WiFi Theme
# Copyright (C) 2025 Silkhowl ( Anselmo Raffi )
# Licensed under the GNU General Public License v3.0
# See LICENSE file for details

# Nome del tema
THEME_NAME="my_wifi_theme"
INSTALL_DIR="$HOME/.icons/$THEME_NAME"

echo "📦 Installazione del tema icone WiFi: $THEME_NAME"

# Rimuove eventuale versione precedente
if [ -d "$INSTALL_DIR" ]; then
    echo "🟡 Rimuovo versione precedente..."
    rm -rf "$INSTALL_DIR"
fi

# Crea struttura cartelle
mkdir -p "$INSTALL_DIR"/{16x16,32x32,64x64,128x128}

# Copia le icone PNG
echo "📁 Copio le icone PNG..."
cp 16x16/*.png "$INSTALL_DIR/16x16/"
cp 32x32/*.png "$INSTALL_DIR/32x32/"
cp 64x64/*.png "$INSTALL_DIR/64x64/"
cp 128x128/*.png "$INSTALL_DIR/128x128/"

# Copia index.theme
echo "📝 Copio il file index.theme..."
cp index.theme "$INSTALL_DIR/"

# Imposta permessi
chmod -R 755 "$INSTALL_DIR"

# Copia gli script nella home (opzionale)
echo "📂 Copio gli script in ~/my_wifi_scripts/"
mkdir -p "$HOME/my_wifi_scripts"
cp script/*.sh "$HOME/my_wifi_scripts/"
chmod +x "$HOME/my_wifi_scripts/"*.sh
# Crea file di cache a volte richiesto
exec gtk-update-icon-cache -f -t "$INSTALL_DIR/"

echo "✅ Installazione completata!"
echo "🔧 Vai in XFCE > Impostazioni > Aspetto > Icone per selezionare '$THEME_NAME'"
echo "📜 Gli script sono disponibili in ~/my_wifi_scripts/"


exit 0