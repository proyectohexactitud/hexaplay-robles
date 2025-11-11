#!/bin/bash
set -euo pipefail
# Script de bootstrap para HexaPlay – Robles
# Crea la estructura inicial, archivos base y hace el primer commit.

REPO_NAME="hexaplay-robles"
GH_USER="proyectohexactitud"
WORKDIR="$HOME/proyectos/$REPO_NAME"

# 1) Preparar carpeta de trabajo
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# 2) Crear árbol base
mkdir -p docs/anexos assets/{splash,fondos,branding} \
         scripts/{system,branding,hostname,bluetooth} \
         system-overlays/{qml,qss,xorg} services examples/{qml_overlay_demo,audio_test} \
         backups

# 3) Archivos base
cat > README.md << 'EOF'
# HexaPlay – Robles
Proyecto para personalizar OpenAuto/Crankshaft en Raspberry Pi 3B: branding "hexaplay robles", pantalla siempre encendida, pruebas de audio Bluetooth y más.

> Estado: v0.1 (estructura inicial). Ver `docs/`.
EOF

cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2025 Thiago

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
EOF

cat > CHANGELOG.md << 'EOF'
# Changelog

## [Unreleased]
- Integrar slider de volumen con `pactl`.
- Hook systemd para mover streams BT.
- PoC de cámara con GStreamer.

## [v0.1] - 2025-11-11
- Estructura inicial del repo y docs.
- Scripts: hostname, DPMS off, recover, parches de branding.
EOF

cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]

# Logs/temporales
*.log
*.tmp

# IDE
.vscode/
.idea/

# RPi/Crankshaft
*.img
*.tgz
/tmp/openauto.log

# Medios grandes
assets_raw/
*.zip
*.7z
*.rar
EOF

# 4) Documentos iniciales
mkdir -p docs
cat > docs/00_visio_general.md << 'EOF'
Resumen de visión, UX y arquitectura del proyecto.
EOF
cat > docs/07_pendientes_limitaciones.md << 'EOF'
- Slider volumen sin control real del sink.
- Cámara sin backend.
- Bluetooth con eco/doble ruta (mitigaciones en progreso).
EOF

# 5) Scripts probados (hostname, keep screen, recover, branding)
mkdir -p scripts/hostname scripts/system scripts/branding scripts/bluetooth
# set hostname script
install -m 0755 /dev/stdin scripts/hostname/set_hostname_hexaplay.sh << 'EOF'
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
EOF

# Keep screen script
install -m 0755 /dev/stdin scripts/system/hexplay_keep_screen_on.sh << 'EOF'
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
EOF

# Recover script
install -m 0755 /dev/stdin scripts/system/hexplay_recover.sh << 'EOF'
#!/bin/bash
set -e
sudo mount -o remount,rw /
sudo systemctl restart openauto || true
DISPLAY=:0 XAUTHORITY=/home/pi/.Xauthority xset s off -dpms s noblank || true
echo "Logs de OpenAuto:"
tail -n 200 /tmp/openauto.log || true
EOF

# Branding: patch autoapp banner
install -m 0755 /dev/stdin scripts/branding/patch_autoapp_banner.py << 'EOF'
#!/usr/bin/env python3
# Reemplaza bloque <html>...</html> en autoapp.real manteniendo la longitud.
TARGET = "/usr/local/bin/autoapp.real"
START = b"<html>"
END   = b"</html>"
REPL  = b"<html><p style=\"font-size:21px;color:#fff\">hexaplay <span style=\"color:#007bff\">robles</span></p></html>"
import sys
buf = open(TARGET,'rb').read()
i = buf.find(START)
j = buf.find(END, i) + len(END)
if i < 0 or j < 0:
    sys.exit("No se encontró bloque HTML")
chunk = buf[i:j]
pad = len(chunk) - len(REPL)
if pad < 0:
    sys.exit("Reemplazo más grande que el bloque. Ajustar estilos.")
new = buf[:i] + REPL + (b" " * pad) + buf[j:]
open(TARGET,'wb').write(new)
print("OK: banner parcheado")
EOF

# Branding: reduce title font script (esqueleto)
install -m 0755 /dev/stdin scripts/branding/reduce_title_font_3px.py << 'EOF'
#!/usr/bin/env python3
# Esqueleto para reducir el tamaño de fuente del título en el binario.
print("TODO: implementar reducción de -3px.")
EOF

# 6) Inicializar git y primer commit
if ! command -v git >/dev/null; then
  echo "Instala git antes de continuar" >&2
  exit 1
fi

git init
git add .
git commit -m "chore(repo): bootstrap estructura inicial + scripts"

git branch -M main
git remote add origin "https://github.com/$GH_USER/$REPO_NAME.git"

echo "Estructura creada en $WORKDIR. Para subir usa: git push -u origin main"
