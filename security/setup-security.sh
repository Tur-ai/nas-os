#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/../build/lib.sh"
require_root

log "Install ufw, fail2ban, lynis"
apt-get install -y ufw fail2ban lynis openssh-server

log "Atur aturan firewall"
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow Samba
ufw allow 8096/tcp   # Jellyfin
ufw allow 9090/tcp   # Cockpit
ufw allow 5353/udp   # mDNS
# Di chroot Cubic ufw tidak bisa diaktifkan; akan aktif lewat service saat boot
ufw --force enable || log "ufw belum bisa aktif sekarang (normal di chroot)"
systemctl enable ufw

log "Fail2ban"
install -m 644 "$HERE/config/jail.local" /etc/fail2ban/jail.local
enable_service fail2ban

log "Hardening SSH"
mkdir -p /etc/ssh/sshd_config.d
install -m 644 "$HERE/config/99-nas-hardening.conf" /etc/ssh/sshd_config.d/99-nas-hardening.conf
# Password login SENGAJA tidak dimatikan supaya tidak terkunci sebelum key SSH disiapkan
sshd -t && { [ -d /run/systemd/system ] && systemctl reload ssh || true; }

log "Security selesai. Cek skor: sudo lynis audit system"
