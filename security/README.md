# security/ (Keamanan & Jaringan)

## Fungsi
Firewall UFW, fail2ban (blokir brute-force SSH), hardening SSH, audit dengan Lynis.

## Cara menjalankan
```bash
sudo bash security/setup-security.sh
```

## Cara tes + bukti (untuk laporan)
1. **Sebelum** menjalankan skrip: `sudo apt install -y lynis && sudo lynis audit system`, catat "Hardening index".
2. Jalankan skrip, lalu audit lagi dan catat skor sesudahnya.
3. `sudo ufw status verbose` (aturan firewall)
4. `sudo fail2ban-client status sshd`
5. Dari mesin lain, coba login SSH salah 5x, IP harus terblokir.
6. Nmap dari mesin lain: `nmap IP-VM`, catat port terbuka.

## Yang bisa dikembangkan
- WireGuard, login SSH pakai key saja, AppArmor, auditd.

## Hasil uji (skor Lynis sebelum vs sesudah)
(isi di sini)
