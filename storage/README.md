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
(isi: skenario, hasil, tangkapan layar, kecepatan transfer)
