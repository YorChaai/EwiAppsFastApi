# Blue Print: Migrasi Hybrid v5 - Sistem Ekstraksi Dinamis & Selaras Database

Dokumen ini adalah panduan teknis untuk meningkatkan skrip migrasi dari versi v5 ke v5, fokus pada penanganan data perbankan yang kompleks.

filenya diisni
"
D:\Aplikasi\EWIApps\backend\scratch\scanner_fokus\scripts\generate_hybrid_migration_v5.py
"

## 1. Masalah Utama (Current State - v5)

- **Posisi Kaku (Hardcoded Positions)**: Skrip mencari header di baris tertentu (misal: baris 77). Jika user menambah baris di atasnya, ekstraksi gagal total.
- **Abaikan Data Bank**: Data "BANK Status" belum diproses, padahal sangat krusial untuk rekonsiliasi kas.
- **Struktur Grouping Terabaikan**: Data bank dipisahkan oleh baris abu-abu (Group Header) yang tidak memiliki kolom tanggal, sehingga sering dianggap "sampah" oleh parser lama.
- **Belum Selaras Database**: Data bank seharusnya masuk ke tabel `bank_transactions`, bukan `expenses` biasa.

## 2. Rencana Masa Depan (Future State - v5)

Membangun sistem yang **"Style-Aware"** (sadar gaya visual) dan **"Stateful"** (sadar posisi grup).

### A. Strategi Pencarian Dinamis (Anchor Logic)

- **Masalah**: Posisi tabel berpindah-pindah.
- **Solusi**: Skrip akan melakukan scan seluruh sheet untuk mencari sel dengan properti: `Value == "BANK Status"` AND `Font == "Arial"` AND `Size == 20` AND `Bold == True`.
- **Hasil**: Koordinat sel ini menjadi "Titik Nol" (Anchor). Semua perhitungan baris header (USD/IDR) dihitung relatif (+1 atau +2) dari titik ini.

### B. Stateful Group Parsing

- **Masalah**: Baris abu-abu (Grup) memutus alur baris data.
- **Solusi**: Gunakan variabel `current_group_name`.
  - Jika baris memiliki teks di kolom B tetapi C & E kosong -> Update `current_group_name` (misal: "Bank Interest (BRI)").
  - Jika baris memiliki tanggal dan angka -> Simpan sebagai transaksi di bawah grup tersebut.

## 3. Penyelarasan Database & Backend

Skrip harus "berbicara" dengan model `models.py` yang sudah ada:

- **Tabel Target**: `bank_transactions`.
- **Pemetaan Kolom**:
  - Nama Grup (Abu-abu) -> `group_name`
  - Teks Deskripsi -> `description`
  - Nilai USD -> `amount_usd`
  - Nilai IDR -> `amount_idr`
  - Pemindahbukuan -> `transaction_type = 'transfer'` (Membutuhkan pencarian `bank_id` dan `to_bank_id`).
  - Bank Interest -> `transaction_type = 'income'`.

## 4. Perbandingan Before vs After

| Fitur           | Versi Lama (v5)                  | Versi Baru yang inign di ubah (v5)   |
| :-------------- | :------------------------------- | :----------------------------------- |
| **Lokasi Data** | Harus di baris tertentu (Fixed)  | Dinamis (Cari Arial 20 Bold)         |
| **Input User**  | Tanya-jawab setiap mulai (Rigid) | Menu Interaktif (Preview/Load/Run)   |
| **Data Bank**   | Diabaikan                        | Diekstrak ke `bank_transactions`     |
| **Header**      | Single Header                    | Multi-Currency Header (USD/IDR)      |
| **Akurasi**     | Sering terlewat jika baris geser | Sangat akurat karena berbasis Anchor |

## 5. Hasil Akhir (Expected Outcome)

User akan memiliki satu menu utama yang kuat. Saat memilih "Preview BANK Status", skrip akan menampilkan laporan:

```text
🔍 Analisis BANK Status:
   ✅ Lokasi Ditemukan: Baris 76
   📊 Grup Terdeteksi:
      - Bank Interest (BRI) : 12 item
      - Pemindahbukuan BRI ke BCA : 4 item
      - ... dst
   🚀 Siap Migrasi ke tabel bank_transactions.
```

Hasil SQL akhirnya akan mencakup `INSERT` yang lengkap dengan ID Bank yang benar, sehingga saldo di aplikasi langsung sinkron dengan Excel.
