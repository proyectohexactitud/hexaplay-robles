# 00. Visión general y componentes

## Objetivo

HexaPlay es un proyecto para convertir una Raspberry Pi 3B en una head-unit automotriz similar a Android Auto. El objetivo es ofrecer navegación, multimedia y control a través del teléfono, manteniendo la personalización y el branding.

## Hardware

- **Raspberry Pi 3 Model B**: Procesador quad-core 1.2 GHz, 1 GB de RAM. Elegido por su bajo consumo y soporte a Linux.
- **Pantalla táctil HDMI**: Resolución 800×480 px (o 1366×768 px en variante), alimentación de 12 V con adaptador, conexión HDMI para video y USB para touch.
- **Barra de sonido / parlantes**: Conexión por jack 3.5 mm o Bluetooth. Puede alimentarse de la Pi o del vehículo.
- **Micrófono**: USB o integrado para control por voz.
- **Módulo Bluetooth**: Dongle USB externo compatible con BlueZ, para streaming A2DP/AVRCP y manos libres.
- **Almacenamiento**: Tarjeta microSD 32 GB o superior con sistema Crankshaft/OpenAuto.
- **Fuente de alimentación**: 5 V 3 A (para la Pi) + convertidor de 12 V a 5 V 3 A (cargador CC para auto).
- **Botón físico de encendido** (opcional): Para iniciar o apagar la Pi de forma segura.

## Software

- **Crankshaft / OpenAuto**: Distribución Linux pensada para head-units, basada en Raspbian (Debian). Incluye:
  - `autoapp` (OpenAuto Pro) que comunica el teléfono Android por USB o Wi‑Fi.
  - Servidor `OpenAuto` que maneja la interfaz y se ejecuta sobre Xorg.
  - Scripts de arranque y servicios systemd.
- **BlueZ**: Stack de Bluetooth en Linux utilizado para emparejar con teléfonos y auriculares. Configurado para perfiles A2DP y HFP.
- **PulseAudio**: Servidor de audio que mezcla salidas y rutas los streams. Se personaliza para desactivar DPMS y mover el audio a bluetooth.
- **Xorg**: Servidor gráfico para Linux que permite ejecutar OpenAuto y mostrar el overlay QML.
- **Qt/QML**: Lenguaje para construir interfaces; se utiliza para el overlay `HexPlayOverlay.qml`.
- **bash & Python**: Scripts auxiliares para mantener la pantalla activa, cambiar el hostname, parchear binarios y recuperar la sesión.
- **Systemd**: Gestor de servicios en Linux. Se configuran unidades personalizadas (`hexplay-keep-screen-on.service`) para desactivar DPMS.

## Arquitectura

1. **Sistema de archivos de sólo lectura**: Crankshaft monta la partición root como read-only para evitar corrupción. Los cambios permanentes (scripts, overlays) se aplican por overlay o parche en el arranque.
2. **Inyección de branding**: Un script Python reemplaza un fragmento HTML embebido en `autoapp.real` con el título "hexaplay robles". Un overlay QML (HexPlayOverlay.qml) se carga en la interfaz para mostrar el branding sin modificar el binario.
3. **Mantenimiento de pantalla**: Un script de shell (`hexplay_keep_screen_on.sh`) y un servicio systemd desactivan el ahorro de energía (DPMS) y el protector de pantalla (`xset s off`, `-dpms`).
4. **Recuperación rápida**: `hexplay_recover.sh` remonta la partición en modo RW, reinicia `openauto` y vuelve a aplicar los tweaks de DPMS.
5. **Gestión de audio Bluetooth**: Scripts en progreso (`a2dp_routing.sh`, `pulseaudio_tweaks.sh`) reconfiguran PulseAudio para enviar el audio del teléfono al sink bluetooth y reducir el eco.

## Diagrama de bloques (conceptual)

```
Teléfono Android <---USB/Bluetooth---> Raspberry Pi / OpenAuto
      |                                   |
  Protocolo AOA                         OpenAuto
      |                                   |
    Audio <---> PulseAudio/BlueZ <----> Parlantes / micrófono
      |                                   |
    Pantalla <----- Xorg / QML ----> Overlay de branding
```

## Glosario de componentes

- **AOA (Android Open Accessory)**: Protocolo que permite a la Pi funcionar como accesorio y controlar el teléfono.
- **A2DP/AVRCP**: Perfiles Bluetooth para transmisión de audio estéreo y control de reproducción.
- **DPMS (Display Power Management Signaling)**: Mecanismo para suspender el monitor; se desactiva para mantener la pantalla encendida.
- **QSS/QML**: Lenguajes de estilo y UI de Qt, usados para personalizar la interfaz.
- **Systemd unit**: Archivos `.service` que definen cómo y cuándo se ejecutan scripts en Linux.

## Convenciones del repositorio

- Cada script tiene permisos ejecutables y un encabezado con descripción.
- Los archivos se organizan en carpetas:
  - `scripts/`: Bash/Python.
  - `system-overlays/`: QML, QSS, configuraciones de Xorg.
  - `services/`: Unidades systemd.
  - `docs/`: Documentación técnica en español.
  - `assets/`: Imágenes optimizadas (no se suben binarios del sistema).
- Los cambios se registran en `CHANGELOG.md` usando el formato "Keep a Changelog".
