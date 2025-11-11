# 05. Uso básico del repositorio y Git

## ¿Qué es un repositorio Git?

Un repositorio Git es una colección de archivos y carpetas con historial de cambios. Cada vez que se realiza un *commit* se guarda un snapshot del estado actual del proyecto con un mensaje descriptivo. Git permite trabajar en equipo, recuperar versiones anteriores y sincronizar los cambios con un servidor remoto, como GitHub.

## Cómo clonar este repositorio

Para obtener una copia local:

```bash
git clone https://github.com/proyectohexactitud/hexaplay-robles.git
cd hexaplay-robles
```

Esto crea una carpeta `hexaplay-robles` con todos los archivos y conserva el historial de cambios.

## Flujo de trabajo básico

1. **Actualizar tu copia local**: Antes de empezar, asegúrate de tener los últimos cambios:

   ```bash
   git pull
   ```

2. **Crear una rama (opcional)**: Para nuevas funcionalidades se recomienda trabajar en una rama separada de `main`:

   ```bash
   git checkout -b nombre-de-rama
   ```

3. **Hacer cambios y añadirlos**:

   - Edita o crea archivos.
   - Luego marca los cambios para commit:

     ```bash
     git add ruta/al/archivo
     # o añade todos los cambios:
     git add .
     ```

4. **Crear un commit**:

   ```bash
   git commit -m "feat: descripción breve del cambio"
   ```

   Usa mensajes de commit claros: `feat` para nuevas funcionalidades, `fix` para correcciones, `docs` para documentación, `chore` para tareas de mantenimiento.

5. **Subir los cambios al servidor remoto**:

   ```bash
   git push origin nombre-de-rama
   ```

   Si trabajas en `main`, ejecuta `git push origin main`.

6. **Combinar cambios (merge)**: En GitHub puedes abrir un *pull request* para revisar y fusionar tus cambios en `main`.

## Editar archivos desde la web

GitHub permite crear y editar archivos directamente desde el navegador:

- Navega al directorio deseado y haz clic en **Add file** → **Create new file**.
- Escribe el nombre del archivo y su contenido.
- Añade un mensaje de commit descriptivo y confirma.

Para subir archivos (imágenes, scripts):

- Usa **Add file** → **Upload files** y selecciona los archivos desde tu computadora.

## Estructura de ramas recomendada

- `main`: rama estable con versiones funcionales.
- `dev` (opcional): rama de integración donde se combinan cambios antes de pasar a `main`.
- Ramas de características: `feat/nombre-funcion`, `fix/error-descripcion`.

## Consejos adicionales

- Haz commits pequeños y frecuentes, cada uno con un propósito claro.
- Revisa el fichero `CHANGELOG.md` para seguir el historial de cambios.
- Usa `.gitignore` para evitar subir archivos temporales o grandes.
- Para más información, consulta la [documentación oficial de Git](https://git-scm.com/doc) y de [GitHub](https://docs.github.com/).
