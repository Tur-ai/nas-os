#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/../build/lib.sh"
require_root

log "Install avahi (mDNS) agar bisa diakses lewat nas-os.local"
apt-get install -y avahi-daemon curl

# hostnamectl butuh systemd hidup; fallback tulis file langsung (untuk chroot)
if [ -d /run/systemd/system ]; then
  hostnamectl set-hostname nas-os
else
  echo "nas-os" > /etc/hostname
fi
enable_service avahi-daemon

log "Install Jellyfin (skrip resmi)"
if ! dpkg -s jellyfin >/dev/null 2>&1; then
  curl -fsSL https://repo.jellyfin.org/install-debian.sh | bash
fi

mkdir -p /srv/nas/media/{film,musik,foto}
chown -R root:nasusers /srv/nas/media 2>/dev/null || true
chmod -R 2775 /srv/nas/media

systemctl enable jellyfin
log "Media selesai. Jellyfin di http://nas-os.local:8096"
