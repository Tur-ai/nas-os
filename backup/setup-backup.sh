#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/../build/lib.sh"
require_root

log "Install rsync dan smartmontools"
apt-get install -y rsync smartmontools

install -m 755 "$HERE/config/nas-backup.sh"  /usr/local/bin/nas-backup
install -m 755 "$HERE/config/nas-restore.sh" /usr/local/bin/nas-restore
install -m 644 "$HERE/config/nas-backup.service" /etc/systemd/system/nas-backup.service
install -m 644 "$HERE/config/nas-backup.timer"   /etc/systemd/system/nas-backup.timer
mkdir -p /srv/backup

systemctl daemon-reload || true
systemctl enable nas-backup.timer
[ -d /run/systemd/system ] && systemctl start nas-backup.timer
enable_service smartmontools 2>/dev/null || true

log "Backup selesai. Tes manual: sudo nas-backup"
