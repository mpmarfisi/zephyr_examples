# zephyr_examples

Ejemplos de Zephyr RTOS para nRF5340DK. Manifest repo de west: `west.yml` define el workspace completo.

## Requisitos

- VS Code + extensión Dev Containers
- Docker Desktop (Windows/macOS) o Docker Engine (Linux)
- J-Link instalado en el host Windows (`JLinkGDBServerCL.exe`)

## Setup

Abre el repo en VS Code → **"Reopen in Container"**.  
El contenedor ejecuta `west init -l` + `west update` automáticamente.

> Versión de Zephyr: controlada por `revision` en `west.yml` (actualmente `v4.1.0`).

## Compilar y flashear

```bash
# Tarea VS Code (Ctrl+Shift+B): "Build blinky"
# O manualmente:
west build -b nrf5340dk/nrf5340/cpuapp apps/blinky --build-dir apps/blinky/build
west flash --build-dir apps/blinky/build
```

## GDB Server externo (J-Link en Windows)

El GDB server corre en el **host Windows** y el contenedor se conecta a él vía `host.docker.internal:2331`.

### 1. Iniciar el servidor desde el contenedor

```bash
./scripts/start_gdb_server.sh
```

Lanza `JLinkGDBServerCL.exe` en una ventana PowerShell de Windows mediante interop WSL2/Docker. Requiere que `powershell.exe` esté accesible desde el contenedor.

Parámetros usados:
```
-device nRF5340_xxAA_APP -if SWD -speed auto -port 2331 -localhostonly 0
```

> `-localhostonly 0` es imprescindible para que acepte conexiones desde el contenedor.

### 2. Conectar GDB desde el contenedor

```bash
arm-zephyr-eabi-gdb apps/blinky/build/zephyr/zephyr.elf \
  -ex "target remote host.docker.internal:2331"
```

### 3. RTT (logs en tiempo real)

Con el GDB server activo, escucha el canal RTT en el puerto 19021:

```bash
nc host.docker.internal 19021
# O usa la tarea VS Code: "Watch RTT"
```
