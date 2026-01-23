#!/usr/bin/env bash
# clock_battery.sh
# Mostra l'hora i la bateria amb icona segons percentatge i estat de càrrega

# Obtenir hora
HORA=$(date '+%H:%M')

# Llegir percentatge i estat de la bateria
BATTERY_PATH="/sys/class/power_supply/BAT0"
if [[ ! -d "$BATTERY_PATH" ]]; then
    BATTERY_PATH="/sys/class/power_supply/BAT1"
fi

PERCENT=$(cat "$BATTERY_PATH/capacity" 2>/dev/null || echo "?" )
STATUS=$(cat "$BATTERY_PATH/status" 2>/dev/null || echo "Unknown")

# Assignar icona segons percentatge
if (( PERCENT >= 75 )); then
    ICON=""
elif (( PERCENT >= 50 )); then
    ICON=""
elif (( PERCENT >= 25 )); then
    ICON=""
elif (( PERCENT >= 10 )); then
    ICON=""
else
    ICON=""
fi

# Mostrar resultat
echo "$HORA  $ICON"
