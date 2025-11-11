#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/pi/.Xauthority
for i in {1..30}; do
  if sudo -u pi xset -display :0 q &>/dev/null; then break; fi
  sleep 2
done
while true; do
  sudo -u pi xset s off
  sudo -u pi xset -dpms
  sudo -u pi xset s noblank
  sleep 60
done
