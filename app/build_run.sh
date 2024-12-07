#!/bin/sh
# Build app for NRF5340dk
west build -b nrf5340dk_nrf5340_cpuapp --build-dir build --pristine
# Flash app
west flash