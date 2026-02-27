#!/bin/bash
# start_gdb_server.sh
#
# Launches JLinkGDBServerCL.exe in a new PowerShell window on Windows via
# WSL2/Docker Windows interop (powershell.exe must be on the PATH).
#
# Usage (from inside the container or WSL):
#   ./scripts/start_gdb_server.sh

# PS C:\Program Files\SEGGER\JLink_V922> .\JLinkGDBServerCL.exe -device nRF5340_xxAA_APP -if SWD -speed auto -port 2331 -localhostonly 0

JLINK_EXE="C:\\Program Files\\SEGGER\\JLink_V922\\JLinkGDBServerCL.exe"
GDB_ARGS="-device nRF5340_xxAA_APP -if SWD -speed auto -port 2331 -localhostonly 0"

if ! command -v powershell.exe &>/dev/null; then
    echo "ERROR: powershell.exe not found. Windows interop may be disabled."
    echo "Enable it with: echo '[interop]' >> /etc/wsl.conf && echo 'enabled=true' >> /etc/wsl.conf"
    exit 1
fi

# Check if a GDB server is already listening on port 2331
if nc -z host.docker.internal 2331 2>/dev/null; then
    echo "JLink GDB Server already running on port 2331, skipping launch."
    exit 0
fi

echo "Launching JLink GDB Server on Windows (port 2331)..."

# Start-Process opens a new visible PowerShell window that stays open after the
# server exits, so you can see error messages.
powershell.exe -NoProfile -Command "
    Start-Process powershell -ArgumentList \`
        '-NoExit', \`
        '-Command', \`
        '& ''${JLINK_EXE}'' ${GDB_ARGS}'
"

# Wait for the server to become reachable
echo -n "Waiting for GDB server to start"
for i in $(seq 1 15); do
    if nc -z host.docker.internal 2331 2>/dev/null; then
        echo " ready."
        exit 0
    fi
    echo -n "."
    sleep 1
done

echo ""
echo "WARNING: GDB server did not respond on port 2331 after 15s."
echo "Check the PowerShell window on Windows for errors."
exit 1
