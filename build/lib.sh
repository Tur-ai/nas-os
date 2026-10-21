#!/bin/bash
# Fungsi bantu bersama. Dipakai dengan: source "$(dirname "$0")/../build/lib.sh"
export DEBIAN_FRONTEND=noninteractive

require_root() {
  if [ "$EUID" -ne 0 ]; then echo "Jalankan dengan sudo."; exit 1; fi
}

# Enable layanan; start hanya kalau systemd benar-benar jalan
# (di chroot Cubic systemd tidak jalan, jadi cukup di-enable).
enable_service() {
  systemctl enable "$1"
  if [ -d /run/systemd/system ]; then systemctl restart "$1"; fi
}

log() { echo "[nas-os] $*"; }
