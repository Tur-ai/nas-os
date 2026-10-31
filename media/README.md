# media/ (Media Server & Layanan)

## Fungsi
Jellyfin (streaming film/musik/foto), hostname `nas-os`, mDNS (`nas-os.local`).

## Cara menjalankan
```bash
sudo bash media/setup-media.sh
```

## Cara tes
1. Buka `http://IP-VM:8096` dari HP/laptop lain, selesaikan wizard awal Jellyfin.
2. `systemctl status jellyfin` harus `active (running)`.
3. Tes auto-restart: `sudo kill -9 $(pidof jellyfin)` lalu cek apakah hidup lagi.

## Hasil uji
| No | Skenario | Cara uji | Hasil |
|----|----------|----------|-------|
| 1 | Skrip berjalan dan idempoten | `sudo bash media/setup-media.sh`, dijalankan dua kali | Berhasil, run kedua melewati instal ulang |
| 2 | Hostname | `hostname` | `nas-os` |
| 3 | Auto-start saat boot | VM dimatikan lalu dinyalakan, `systemctl is-active jellyfin` | `active` |
| 4 | Auto-restart | `kill -9` pada Jellyfin, tunggu 15 detik | PID 1182 menjadi 3096, status `active` |
| 5 | Menunggu storage | `systemctl cat jellyfin` | `RequiresMountsFor=/srv/nas/media` terbaca |
| 6 | Izin folder media | `id jellyfin`, lalu tulis file sebagai user `jellyfin` | Anggota `nasusers`, tulis berhasil |
| 7 | Akses Jellyfin dari Windows | `http://nas-os.local:8096` | Berhasil, mDNS berfungsi |
| 8 | Akses dari HP | `http://nas-os.local:8096` | Gagal, HP tidak mengenali `.local` (keterbatasan perangkat) |

Catatan: URL skrip resmi Jellyfin berubah dari `install-debian.sh` menjadi `install-debuntu.sh`, dan sudah diperbaiki di `setup-media.sh`.
