#!/bin/sh
BOARD=${1:-nrf5340dk/nrf5340/cpuapp}
APP_DIR=$(dirname "$0")

west build -b "$BOARD" "$APP_DIR" --build-dir "$APP_DIR/build" --pristine
west flash --build-dir "$APP_DIR/build"