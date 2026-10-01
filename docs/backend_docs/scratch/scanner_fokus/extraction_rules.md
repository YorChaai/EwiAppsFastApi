# 📋 Aturan Ekstraksi Data Excel (Sheet 2 & 3)

Dokumen ini berfungsi sebagai panduan teknis untuk proses ekstraksi data dari Excel ke SQL.

---

## 📄 Sheet 2: Laba Rugi & Neraca

### 1. Tabel "LABA RUGI" (Sebelah Kiri)
Fokus hanya pada komponen pendapatan dan pajak spesifik berikut:
- **PENDAPATAN LAINNYA**
- **CORPORATE TAX (PPh 29)**

### 2. Tabel "NERACA" (Sebelah Kanan)
Ambil nilai saldo untuk akun-akun berikut:
- **KAS DAN SETARA KAS TAHUN SEBELUMNYA**
- **KAS DAN SETARA KAS TAHUN LAPORAN**
- **PIUTANG USAHA**
- **PAJAK BAYAR DI MUKA (pph23)**
- **BIAYA BAYAR DI MUKA**
- **PIUTANG LAIN LAIN**
- **INVENTARIS KANTOR**
- **HUTANG USAHA**
- **HUTANG GAJI**
- **HUTANG PEMEGANG SAHAM**
- **BIAYA YANG MASIH HARUS DI BAYAR**
- **MODAL SAHAM**
- **LABA DI TAHAN**

> [!IMPORTANT]
> **Abaikan:** Baris Total, Subtotal, Header, Footer, Logo, dan Tanda Tangan.

---

## 📄 Sheet 3: Business Summary

### Seksi "DEVIDEN"
Target ekstraksi adalah daftar penerima deviden.

**Aturan Ekstraksi:**
1. Cari baris dengan judul **"DEVIDEN"**.
2. Ekstrak hanya **teks nama orang** di setiap baris di bawahnya.
3. **Abaikan:** Angka, Currency, dan Catatan Pajak.

**Output yang diharapkan (Contoh):**
```json
[
  "Alan Muhadjir",
  "Anevril Chairulsyah"
]
```

---

## 🛠️ Logika Pembersihan (General)
- Gunakan fungsi `clean_amount()` untuk menghapus simbol "Rp", titik ribuan, dan koma desimal agar data bisa masuk ke SQL sebagai tipe `NUMERIC` atau `FLOAT`.
- Gunakan `fuzzy_search` jika nama akun di Excel memiliki sedikit perbedaan spasi atau karakter.
