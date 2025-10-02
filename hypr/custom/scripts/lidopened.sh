#!/bin/bash

CONFIG_FILE="/home/piotr/.config/hypr/monitors.conf"

# Sprawdź czy plik istnieje
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Błąd: Plik $CONFIG_FILE nie istnieje."
    exit 1
fi

# Przetwarzaj każdą linię
while IFS= read -r line; do
    # Pomijaj puste linie lub te, które nie zaczynają się od 'monitor='
    [[ -z "$line" || "$line" != monitor=* ]] && continue

    # Usuń prefix 'monitor=' i rozdziel dane po przecinkach
    line=${line#monitor=}
    IFS=',' read -r name resolution position scale <<< "$line"

    # Buduj argument hyprctl
    monitor_arg="${name},${resolution},${position},${scale}"

    echo "Ustawiam monitor: $monitor_arg"
    hyprctl keyword monitor "$monitor_arg"
done < "$CONFIG_FILE"
