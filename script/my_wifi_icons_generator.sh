#!/bin/bash

## definiamo le principali variabili

filebasename="my_wifi_" 

## inizializziamo a vuoto la variabili che useremo
i=""
c1=""
c2=""
c3=""
c4=""
c5=""
F=""
STD=""
Q=""

# Array di colori da usare
colors=("white" "#E91E63" "#FF9800" "#2196F3" "#4CAF50" "#9C27B0" "black")

# Ciclo per generare SVG
for i in "${!colors[@]}"; do
  color="${colors[$i]}"
    case "$i" in
        "0")
            STD="old" # Standard precedente (802.11a/b/g)
            F=("24" "5")
            ;;
        "1")
            STD="4" # WiFi 4 (802.11n)
            F=("24" "5")
            ;;
        "2")
            STD="5" # WiFi 5 (802.11ac)
            F=("5")
            ;;
        "3")
            STD="6"  # WiFi 6
            F=("24" "5")
            ;;
        "4")
            STD="6e" # WiFi 6E
            F=("6")
            ;;
        "5")
            STD="7" # WiFi 7 (802.11be)
            F=("24" "5" "6")
            ;;
        "6")
            STD="unk" # Standard sconosciuto
            F=("")
            ;;
    esac

		for E in "${!F[@]}"; do
		Q="${F[$E]}"

	for ((n = 0 ; n < 6 ; n++)); do 
	for a in {1..5}; do
	  if (( n >= a )); then
	    eval "c$a=$color"
	  else
	    eval "c$a=grey"
	  fi

  filename=$filebasename$STD"_$((Q))_$((n)).svg"

  cat > "$filename" <<EOF
<svg width="120" height="120" viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg">
  <!-- definizione dello spazio su cui disegnare lunghezza ed althezza e dell'area visibile -->
  <!-- vieBox da le cordinate minime e massime di x e y -->

  <circle cx="15" cy="110" r="5" fill="$color" />
  <!-- la funzione circle disegna un cerchio con centro alle coodinate cx e cy -->
  <!-- la funzione fill riempie del colore indicato il cerchio -->

  <!-- disegnamo ora i 5 archi circolari e spessori progressivi -->
  <path d="M 10 90 A 20 20 0 0 1 30 120" stroke="$c1" stroke-width="5" fill="none"/>
  <path d="M 10 70 A 40 40 0 0 1 50 120" stroke="$c2" stroke-width="5.5" fill="none"/>
  <path d="M 10 50 A 60 60 0 0 1 70 120" stroke="$c3" stroke-width="6" fill="none"/>
  <path d="M 10 30 A 80 80 0 0 1 90 120" stroke="$c4" stroke-width="6.5" fill="none"/>
  <path d="M 10 10 A 100 100 0 0 1 110 120" stroke="$c5" stroke-width="7" fill="none"/>
  <text x="115" y="110" font-family="Arial" font-size="40" font-weight="bold" fill="black" text-anchor="end">$Q</text>
  <text x="115" y="30" font-family="Arial" font-size="40" font-weight="bold" fill="black" text-anchor="end">$STD</text>
</svg>

EOF
			done
		done
	done

done

## convertiamo in PNG 
sizes=("16" "32" "64" "128")

for s in "${!sizes[@]}"; do
  size="${sizes[$s]}"

	for svg in my_wifi_*.svg; do
	  png="${svg%.svg}_$size.png"
	  rsvg-convert --width=$size --height=$size --keep-aspect-ratio "$svg" -o "$png" &
	done
	wait
done

exit 0
