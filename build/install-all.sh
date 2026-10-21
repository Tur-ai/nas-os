#!/bin/bash
# Menjalankan semua bagian berurutan. Dipanggil ketua di chroot Cubic atau di VM tes.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$ROOT/build/lib.sh"
require_root

apt-get update

for part in storage media backup security dashboard; do
  log "=== Menjalankan bagian: $part ==="
  bash "$ROOT/$part/setup-$part.sh"
done

log "Selesai. Semua bagian terpasang."
