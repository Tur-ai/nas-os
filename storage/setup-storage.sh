#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/../build/lib.sh"
require_root

log "Install Samba"
apt-get install -y samba

log "Buat group, user dummy, dan folder share"
getent group nasusers >/dev/null || groupadd nasusers
id nasuser >/dev/null 2>&1 || useradd -m -G nasusers -s /usr/sbin/nologin nasuser

mkdir -p /srv/nas/public /srv/nas/private
chown -R root:nasusers /srv/nas
chmod 2775 /srv/nas/public
chmod 2770 /srv/nas/private

log "Salin konfigurasi Samba"
[ -f /etc/samba/smb.conf ] && cp -n /etc/samba/smb.conf /etc/samba/smb.conf.orig
cp "$HERE/config/smb.conf" /etc/samba/smb.conf

# Password DUMMY untuk demo. Ganti saat deploy sungguhan.
(echo "nas12345"; echo "nas12345") | smbpasswd -a -s nasuser

enable_service smbd
log "Storage selesai."
