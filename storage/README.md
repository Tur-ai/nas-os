# storage/ (Storage & File Sharing)

## Fungsi
Samba file sharing: folder `public` (tanpa login) dan `private` (login user `nasuser`, password dummy di skrip).

## Cara menjalankan
```bash
sudo bash storage/setup-storage.sh
```

## Cara tes
1. Dari Windows: buka `\\IP-VM\public` di File Explorer.
2. Dari Linux: `smbclient //IP-VM/private -U nasuser`
3. Cek permission: `ls -ld /srv/nas/*`

## Yang bisa dikembangkan (nilai tambah)
- Quota per user, LVM, atau RAID software (mdadm), NFS.

## Hasil uji
**Skenario 1: Konfigurasi User, Group, dan Direktori**
- **Hasil:** Berhasil membuat group `nasusers` dan user `nasuser`.
- **Permission:** Folder `public` diatur ke `2775`, folder `private` diatur ke `2770`.

**Skenario 2: Pengujian Hak Akses Lokal**
- **Hasil:** User `nasuser` berhasil membuat file `test.txt` pada folder `public`.
- **Pengujian private:** User `nasuser` berhasil membuat dan membaca file `file-private.txt` pada folder `private`.
- **Pengujian pembatasan akses:** User `zaky` ditolak saat mencoba membuka folder `private` karena tidak memiliki izin akses.
- **Kesimpulan:** Pengaturan permission folder `public` (`2775`) dan `private` (`2770`) berjalan sesuai konfigurasi.

