#!/bin/bash
# Pakai: nas-restore.sh <nama-snapshot>   (lihat daftar: ls /srv/backup)
set -euo pipefail
SNAP="${1:?Sebutkan nama snapshot, lihat: ls /srv/backup}"
[ -d "/srv/backup/$SNAP" ] || { echo "Snapshot tidak ditemukan"; exit 1; }
rsync -a "/srv/backup/$SNAP/" /srv/nas/
logger -t nas-backup "Restore dari $SNAP"
echo "Restore selesai dari $SNAP"
