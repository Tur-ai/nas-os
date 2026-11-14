# dashboard/ (Dashboard, QA & Dokumentasi)

## Fungsi
**NAS-OS Control Deck**: dashboard web buatan sendiri (CPU, RAM, disk, jaringan live, status layanan,
backup terakhir) + dashboard teks di layar fisik saat boot. Cockpit tetap dipasang untuk administrasi.

## Komponen
| File | Fungsi |
|------|--------|
| `app/server.py` | Server web (Python standar) yang membaca `/proc`, `systemctl`, `/srv/backup`; API di `/api/stats` |
| `app/index.html` | Tampilan web (gauge, grafik jaringan live, kartu layanan) |
| `app/console.py` | Dashboard teks untuk tty1 (layar monitor mesin) |
| `config/nas-dashboard.service` | Unit systemd (jalan sebagai user `nasdash`, port 80) |
| `config/getty-override.conf` | Auto-login `nasdash` di tty1, langsung menampilkan `console.py` |

## Cara menjalankan
```bash
sudo bash dashboard/setup-dashboard.sh
sudo systemctl restart getty@tty1      # atau reboot, untuk melihat dashboard teks di layar
```
- Web: `http://nas-os.local` atau `http://IP-VM`
- Admin: `https://IP-VM:9090` (Cockpit, login user Linux)

## Cara tes (untuk Bab IV)
1. Buka web dari HP/laptop lain: angka harus bergerak tiap 2 detik.
2. Salin file besar lewat Samba: grafik jaringan harus naik.
3. `sudo systemctl stop smbd`: kartu Samba berubah merah dalam ±5 detik.
4. `sudo nas-backup`: "Backup terakhir" berubah.
5. Reboot: layar VM langsung menampilkan dashboard teks tanpa login.

## Keamanan
Dashboard hanya **membaca** status dan tidak punya login, jadi hanya untuk jaringan lokal. User `nasdash`
tanpa sudo dan tanpa password. Port 80 dibuka di UFW oleh skrip ini.

## Hasil uji
(isi di sini)
