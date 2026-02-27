#!/bin/sh
# Inicializa el workspace de west si aún no está inicializado, y descarga
# zephyr + módulos.
#
# Uso:
#   ./setup_dir.sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Si .west/config no existe en el workspace, ejecuta west init
if ! west topdir ; then
    west init -l "$SCRIPT_DIR"
fi

west update