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
  curl -fsSL https://repo.jellyfin.org/install-debuntu.sh | bash
fi
log "Siapkan group nasausers dan beri akses Jellyfin"
getent group nasusers >/dev/null || groupadd nasusers
usermod -aG nasusers jellyfin
mkdir -p /srv/nas/media/{film,musik,foto}
chown -R root:nasusers /srv/nas/media 2>/dev/null || true
chmod -R 2775 /srv/nas/media
log "Atur Systemd: Jellyfin menunngu storage ter-mount"
mkdir -p /etc/systemd/system/jellyfin.service.d
cat > /etc/systemd/system/jellyfin.service.d/nas.conf <<'EOF'
[Unit]
RequiresMountsFor=/srv/nas/media
EOF
if [ -d /run/systemd/system ]; then systemctl daemon-reload; fi
systemctl enable jellyfin
if [ -d /run/systemd/system ]; then systemctl restart jellyfin; fi
log "Media selesai. Jellyfin di http://nas-os.local:8096"
