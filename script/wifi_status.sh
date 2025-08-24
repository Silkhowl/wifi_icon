#!/bin/bash

# This script is part of My WiFi Theme
# Copyright (C) 2025 Silkhowl ( Anselmo Raffi )
# Licensed under the GNU General Public License v3.0
# See LICENSE file for details


# Configura l'interfaccia di rete WiFi (MODIFICARE QUESTA RIGA CON LA GIUSTA INTERFACCIA)
INTERFACE="wlan0"

# Percorso della cartella delle icone
ICON_DIR="$HOME/.local/share/my_wifi_icons"

# Funzione per ottenere la frequenza (es. "24" per 2.4 GHz, "5" per 5 GHz, "6" per 6 GHz)
get_frequency() {
    # Usa 'iw dev link' e cerca il campo 'freq:'
    FREQ_MHZ=$(iw dev "$INTERFACE" link 2>/dev/null | grep "freq:" | awk '{print $2}' | cut -d'.' -f1)
    if [ -n "$FREQ_MHZ" ]; then
        # Calcola la banda: 2000-3000 -> 2, 5000-6000 -> 5, >6000 -> 6
        if [ "$FREQ_MHZ" -lt 3000 ]; then
            echo "24"
        elif [ "$FREQ_MHZ" -lt 6000 ]; then
            echo "5"
        else
            echo "6"
        fi
    else
        echo "0"
    fi
}

## standard WiFi
get_wifi_standard() {
    LINK_INFO=$(iw dev "$INTERFACE" link 2>/dev/null)

    STD_RAW=$(echo "$LINK_INFO" | grep -o -E "(HT|VHT|HE|EHT)" | head -n 1)

    if [ -n "$STD_RAW" ]; then
        echo "$STD_RAW"
    else
        if echo "$LINK_INFO" | grep -q "MCS"; then
            echo "HT"
        else
            echo "LEGACY"
        fi
    fi
}

# Controlla se l'interfaccia esiste e ha un ESSID (è connessa)
if iw dev "$INTERFACE" link 2>/dev/null | grep -q "SSID:"; then

    FREQ=$(get_frequency)
    STD_RAW=$(get_wifi_standard)

    case "$STD_RAW" in
        "HT")
            STD="4" # WiFi 4 (802.11n)
            ;;
        "VHT")
            STD="5" # WiFi 5 (802.11ac)
            ;;
        "HE")
            if [ "$FREQ" = "6" ]; then
                STD="6e" # WiFi 6E
            else
                STD="6"  # WiFi 6
            fi
            ;;
        "EHT")
            STD="7" # WiFi 7 (802.11be)
            ;;
        "LEGACY")
            STD="old" # Standard precedente (802.11a/b/g)
            ;;
        *)
            STD="unk" # Standard sconosciuto
            ;;
    esac

## Determinare la potenza del segnale
SIGNAL=$(iw dev "$INTERFACE" link | grep "signal:" | awk '{print $2}')
LEVEL=0
if [ "$SIGNAL" -gt -90 ]; then LEVEL=1; fi
if [ "$SIGNAL" -gt -80 ]; then LEVEL=2; fi
if [ "$SIGNAL" -gt -70 ]; then LEVEL=3; fi
if [ "$SIGNAL" -gt -60 ]; then LEVEL=4; fi
if [ "$SIGNAL" -gt -50 ]; then LEVEL=5; fi

## emette messaggio visivo e sonoro di segnale debole
## libnotify e paplay debbono essere installati.
if [ "$LEVEL" -le 1 ]; then
  notify-send "Segnale WiFi debole" "Controlla la connessione ($SIGNAL dBm)"
  paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
fi

## Scegliere una dimensione per le icone
## in automatico
PANEL_HEIGHT=$(xfconf-query -c xfce4-panel -p /panels/panel-1/size 2>/dev/null)
case "$PANEL_HEIGHT" in
  16) size=16 ;;
  32) size=32 ;;
  64) size=64 ;;
  *) size=32 ;;
esac
## default 32px, sovrascrivibile da argomento
## o manualmwnte commentando la riga sopra e decommentando sotto
## sostituendo XX con uno dei valori: 16 32 64 128
##    size=XX
    ICON_NAME="my_wifi_${STD}_${FREQ}_${LEVEL}_${size}.png"
    ICON_PATH="$ICON_DIR/$ICON_NAME"

    # Controlla se l'icona specifica esiste, altrimenti usa un'icona di fallback
    if [ ! -f "$ICON_PATH" ]; then
        ICON_PATH="$ICON_DIR/my_wifi_unk_0_0_16.png"
        # Se non esiste nemmeno l'icona per sconosciuto, usa quella "off"
        if [ ! -f "$ICON_PATH" ]; then
            ICON_PATH="$ICON_DIR/wifi-off.png"
        fi
    fi

    # tooltip informativo
    BITRATE=$(iw dev "$INTERFACE" link | grep "bitrate:" | head -n 1 | awk '{print $2 " " $3}')
    SIGNAL=$(iw dev "$INTERFACE" link | grep "signal:" | awk '{print $2}')

    # Output per xfce4-genmon-plugin
    echo "<img>$ICON_PATH</img>"
    echo "<tool>Connesso: WiFi $STD (@ ${FREQ} GHz)
Bitrate: $BITRATE
Segnale: $SIGNAL</tool>"

else
    # Non connesso o interfaccia down
    echo "<img>$ICON_DIR/wifi-off.png</img>"
    if ! ip link show dev "$INTERFACE" | grep -q "state UP"; then
        echo "<tool>Interfaccia WiFi disattivata</tool>"
    else
        echo "<tool>WiFi Disconnesso (nessuna rete)</tool>"
    fi
fi

if [ "$LEVEL" -le 1 ]; then
  notify-send "Segnale WiFi debole" "Controlla la connessione ($SIGNAL dBm)"
  paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga
fi

## richiede che libnotify e paplay siano installati.

## log di debag
echo "DEBUG: STD=$STD, FREQ=$FREQ, SIGNAL=$SIGNAL, LEVEL=$LEVEL, ICON=$ICON_PATH" >> /tmp/wifi_icon_debug.log

## click su icona
echo "<click>nm-connection-editor</click>"
# Aggiorna l'icona ogni 10 secondi
echo "<txt></txt>"

exit 0