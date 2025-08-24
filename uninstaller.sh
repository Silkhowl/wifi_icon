#!/bin/bash

# This script is part of My WiFi Theme
# Copyright (C) 2025 Silkhowl ( Anselmo Raffi )
# Licensed under the GNU General Public License v3.0
# See LICENSE file for details


# Nome del tema
THEME_NAME="my_wifi_theme"
INSTALL_DIR="$HOME/.icons/$THEME_NAME"

echo "📦 Rimozione del tema icone WiFi: $THEME_NAME"

if [ -d "$INSTALL_DIR" ]; then
    echo "🟡 Rimuovo $THEME_NAME ..."
    rm -rf "$INSTALL_DIR"
fi


echo "✅ Rimozione completata!"
echo "🔧 Vai in XFCE > Impostazioni > Aspetto > Icone per selezionare un altro tema"

exit 0