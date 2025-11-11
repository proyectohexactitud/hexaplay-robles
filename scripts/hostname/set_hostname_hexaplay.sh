#!/bin/bash
set -euo pipefail
NEW_HOST="hexaplay-robles"
BACKDIR="/home/pi/hexplay_backup"
mkdir -p "$BACKDIR"
TS=$(date +%Y%m%d_%H%M%S)
sudo mount -o remount,rw /
sudo cp /etc/hostname "$BACKDIR/hostname_$TS.bak" || true
sudo cp /etc/hosts "$BACKDIR/hosts_$TS.bak" || true
echo "$NEW_HOST" | sudo tee /etc/hostname >/dev/null
sudo sed -i "/127.0.1.1/c\\127.0.1.1\t$NEW_HOST" /etc/hosts
sync
sudo mount -o remount,ro /
echo "Hostname actualizado a $NEW_HOST. Reinicia para aplicar."
