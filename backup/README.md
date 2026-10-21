# backup/ (Backup & Ketahanan)

## Fungsi
Backup snapshot harian `/srv/nas` ke `/srv/backup` (rsync + hard link, simpan 7 snapshot),
dijadwalkan lewat systemd timer. Ada skrip restore dan monitoring SMART (smartmontools).

## Cara menjalankan
```bash
sudo bash backup/setup-backup.sh
sudo nas-backup          # tes manual
systemctl list-timers    # cek jadwal
```

## Skenario uji restore
1. Buat file: `echo halo | sudo tee /srv/nas/public/tes.txt`
2. `sudo nas-backup`
3. Hapus: `sudo rm /srv/nas/public/tes.txt`
4. `ls /srv/backup` lalu `sudo nas-restore <nama-snapshot>`
5. File harus kembali.

## Yang bisa dikembangkan
- Notifikasi saat SMART bermasalah, backup ke disk eksternal, restic (terenkripsi).

## Hasil uji
(isi di sini)
