#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/../build/lib.sh"
require_root

log "Install Cockpit (untuk administrasi) dan Python"
apt-get install -y cockpit cockpit-storaged python3
systemctl enable cockpit.socket

log "Pasang NAS-OS Control Deck"
# User tanpa sudo dan tanpa password: hanya untuk menjalankan dashboard
id nasdash >/dev/null 2>&1 || useradd -m -s /bin/bash nasdash
install -d /opt/nas-dashboard
install -m 755 "$HERE/app/server.py"  /opt/nas-dashboard/server.py
install -m 755 "$HERE/app/console.py" /opt/nas-dashboard/console.py
install -m 644 "$HERE/app/index.html" /opt/nas-dashboard/index.html
install -m 644 "$HERE/config/nas-dashboard.service" /etc/systemd/system/nas-dashboard.service
systemctl daemon-reload || true
enable_service nas-dashboard

log "Layar fisik (tty1) langsung menampilkan dashboard teks"
install -d /etc/systemd/system/getty@tty1.service.d
install -m 644 "$HERE/config/getty-override.conf" /etc/systemd/system/getty@tty1.service.d/autologin.conf
echo 'exec python3 /opt/nas-dashboard/console.py' > /home/nasdash/.bash_profile
chown nasdash:nasdash /home/nasdash/.bash_profile

# Buka port 80 di firewall (aturan ditambahkan di sini karena dashboard butuh port ini)
ufw allow 80/tcp || true

log "Dashboard selesai. Web: http://nas-os.local  |  Admin: https://nas-os.local:9090"
