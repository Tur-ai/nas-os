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
(isi di sini)
