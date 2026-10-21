#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/../build/lib.sh"
require_root

log "Install Cockpit"
apt-get install -y cockpit
systemctl enable cockpit.socket
log "Dashboard selesai. Buka https://IP-VM:9090"
