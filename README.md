---
README.md
___

![License GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

---
## 📡 My WiFi Theme – Icone dinamiche per XFCE

Un tema di icone personalizzate per XFCE4 che visualizza lo stato del WiFi in base a:
- Standard WiFi (WiFi 4, 5, 6, 6E, 7, legacy, sconosciuto)
- Frequenza (2.4 GHz, 5 GHz, 6 GHz)
- Intensità del segnale (da 0 a 5)
- Risoluzione (16×16, 32×32, 64×64, 128×128)

## 📁 Struttura del tema

```
my_wifi_theme_autoinstall/
├── installer.sh
├── uninstaller.sh
├── index.theme
├── script/
│   ├── wifi_status.sh
│   └── my_wifi_icons_generator.sh
├── 16x16/
├── 32x32/
├── 64x64/
└── 128x128/
```

Ogni cartella contiene icone PNG generate automaticamente con nomi del tipo:

```
my_wifi_<standard>_<frequenza>_<livello>_<dimensione>.png
```

Esempio: `my_wifi_6_5_3_32.png` → WiFi 6, 5 GHz, segnale medio, icona 32×32 px.

## ⚙️ Installazione

___
 Autoinstallante :


```bash
tar -xzf my_wifi_theme_autoinstall.tar.gz
cd my_wifi_theme_autoinstall
bash installer.sh
```

  Verifica che XFCE lo riconosca:
   - Apri **Impostazioni > Aspetto > Icone**
   - Seleziona “My WiFi Theme”

---
 Manuale :

Copia la cartella `my_wifi_theme` in `~/.icons/`:

```bash
mv my_wifi_theme ~/.icons/my_wifi_theme
```

  Verifica che XFCE lo riconosca:
   - Apri **Impostazioni > Aspetto > Icone**
   - Seleziona “My WiFi Theme”

---
## ⚙️ Disinstallazione

 Esegui lo script `uninstaller.sh` nella cartella `~/.icons/my_wifi_theme` o dal pacchetto

---

## 🔧 Integrazione con `xfce4-genmon-plugin`

Usa lo script `wifi_status.sh`, incluso nella cartella script, per mostrare l’icona corretta in base alla rete attiva. Lo script:
- Rileva l’interfaccia WiFi (`wlan0` o altra)
- Determina standard, frequenza e segnale
- Seleziona l’icona corrispondente
- Mostra tooltip con bitrate e potenza
- Supporta fallback in caso di errore
- Mostrare notifiche desktop se il segnale è debole
- Riprodurre suoni di avviso
- Loggare lo stato in `/tmp/wifi_icon_debug.log`


### Esempio di configurazione genmon

```bash
/path/to/wifi_status.sh
```

Aggiornamento ogni 10 secondi consigliato.

## 🧪 Requisiti

- `iw`, `nmcli`, `rsvg-convert`, `notify-send`, `paplay`
- XFCE4 con `xfce4-genmon-plugin`
- Bash ≥ 4.0

## 📦 Generazione delle icone

Le icone SVG e PNG sono generate tramite uno script Bash che:
- Crea 6 livelli di segnale per ogni standard e frequenza
- Usa colori distintivi per ogni tecnologia
- Esporta automaticamente in 4 risoluzioni

lo script `my_wifi_icons_generator.sh` è incluso nella cartella script.

## 🧠 Autore

Creato da **Silkhowl ( Anselmo Raffi )** per uso personale e diagnostico su sistemi Linux.
Distribuibile liberamente, modificabile e migliorabile.

## 📜 Licenza

Questo progetto è distribuito sotto licenza [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).  
Puoi usarlo, modificarlo e ridistribuirlo liberamente, a condizione di mantenere la stessa licenza.

---