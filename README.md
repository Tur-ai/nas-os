# NAS-OS

Distro Ubuntu Server untuk Mini-NAS rumahan: file sharing (Samba), media server (Jellyfin),
backup otomatis, hardening keamanan, dan dashboard web (Cockpit).

> Proyek Final Project Sistem Operasi, Ganjil 2026/2027. Semua data dan password di repo ini DUMMY.

## Struktur repo
| Folder | Isi | PIC |
|--------|-----|-----|
| `build/` | Skrip utama + library bersama, panduan Cubic | (ketua) |
| `storage/` | Samba, user/group, permission | |
| `media/` | Jellyfin, hostname, mDNS | |
| `backup/` | Backup otomatis, restore, cek SMART | |
| `security/` | UFW, fail2ban, hardening SSH, Lynis | |
| `dashboard/` | Cockpit + halaman status | |
| `docs/` | Pembagian tugas, bahan laporan | |

## Cara menjalankan (di Ubuntu Server kosong / VM)
```bash
git clone <URL-REPO> && cd nas-os
sudo bash build/install-all.sh
```
Atau jalankan satu bagian saja, contoh: `sudo bash storage/setup-storage.sh`

## Aturan kerja tim
1. Satu orang = satu folder. Jangan edit folder orang lain tanpa bilang.
2. Kerja di branch sendiri (`git checkout -b storage-samba`), lalu buat Pull Request ke `main`.
3. Skrip harus **non-interaktif** (`apt install -y`) dan **aman dijalankan berulang**.
4. Jangan commit ISO/VM. Jangan commit password asli.
5. Tiap folder wajib punya `README.md` (fungsi, cara jalan, cara tes + hasil uji).

## Anggota tim
Lihat `docs/pembagian-tugas.md`.
