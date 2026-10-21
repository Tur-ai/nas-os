# build/ (Ketua / Build & Integrasi)

## Isi
- `lib.sh` : fungsi bantu (`require_root`, `enable_service`, `log`)
- `install-all.sh` : memanggil `setup-*.sh` tiap bagian secara berurutan

## Memasukkan repo ke ISO lewat Cubic
1. Di VM Ubuntu Desktop, `git clone` repo ini.
2. Buka Cubic, pilih ISO Ubuntu Server sebagai base.
3. Di terminal chroot Cubic, salin repo (tombol "Copy" di Cubic atau drag file ke jendela terminal).
4. Jalankan: `cd /root/nas-os && bash build/install-all.sh`
5. Lanjut ke tahap generate ISO, lalu tes boot di VM baru.

## Catatan chroot
- `systemctl start` tidak jalan di chroot, jadi skrip memakai `enable` saja. Layanan aktif saat boot pertama.
- Perintah yang butuh kernel/jaringan hidup (misal `ufw enable`) bisa gagal di chroot. Skrip sudah menanganinya.
