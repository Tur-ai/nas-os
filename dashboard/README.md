# dashboard/ (Dashboard, QA & Dokumentasi)

## Fungsi
Dashboard web Cockpit (status CPU/RAM/disk, layanan, log). Tahap lanjut: halaman status
buatan sendiri (Flask) yang menampilkan status Samba, Jellyfin, backup terakhir, dan SMART disk.

## Cara menjalankan
```bash
sudo bash dashboard/setup-dashboard.sh
```
Buka `https://IP-VM:9090`, login dengan user Linux di VM.

## Tugas QA
Kumpulkan hasil uji dari semua bagian ke `docs/hasil-uji.md`:
waktu boot (`systemd-analyze`), kecepatan transfer Samba, uji restore, skor Lynis, RAM idle.

## Hasil uji
(isi di sini)
