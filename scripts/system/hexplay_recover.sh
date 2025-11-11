#!/bin/bash
set -e
sudo mount -o remount,rw /
sudo systemctl restart openauto || true
DISPLAY=:0 XAUTHORITY=/home/pi/.Xauthority xset s off -dpms s noblank || true
echo "Logs de OpenAuto:"
tail -n 200 /tmp/openauto.log || true
