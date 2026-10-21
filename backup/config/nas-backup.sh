#!/bin/bash
# Backup snapshot harian pakai rsync + hard link (hemat ruang). Simpan 7 snapshot terakhir.
set -euo pipefail
SRC="/srv/nas/"
DEST="/srv/backup"
TS="$(date +%F_%H%M%S)"

mkdir -p "$DEST"
LAST="$(ls -1d "$DEST"/20* 2>/dev/null | tail -n1 || true)"

if [ -n "$LAST" ]; then
  rsync -a --link-dest="$LAST" "$SRC" "$DEST/$TS/"
else
  rsync -a "$SRC" "$DEST/$TS/"
fi

# Hapus snapshot lama, sisakan 7
ls -1d "$DEST"/20* | head -n -7 | xargs -r rm -rf
logger -t nas-backup "Backup selesai: $TS"
