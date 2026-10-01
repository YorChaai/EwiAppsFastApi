# Implementation Plan: Fix Hybrid Migration Grouping Logic (v13)

Berdasarkan permintaan dan penjelasan Anda, ini adalah rencana perbaikan untuk script `generate_hybrid_migration_v13.py` agar jumlah Single dan Batch sesuai dengan target manual Anda, menggunakan aturan kolom yang sangat spesifik.

## 1. Goal Description

Memperbaiki logika ekstraksi dan pengelompokan data pada script migrasi agar dapat secara akurat membedakan antara Judul Grup, Subkategori, dan Baris Data (Item). Tujuannya adalah mencapai target persis seperti perhitungan manual Anda:
*   **2024:** ~187 Single, ~39 Batch
*   **2025:** ~335 Single, ~55 Batch
*   **2026:** ~101 Single, ~13 Batch

## 2. Aturan Utama (Berdasarkan Instruksi Anda)

Untuk membedakan jenis baris (Judul, Subkategori, atau Data), kita akan mengimplementasikan aturan eksplisit berikut:

1.  **Baris Data (Item):**
    *   **Syarat Mutlak:** Sebuah baris pasti merupakan data jika memenuhi kondisi berikut berdasarkan tahun:
        *   **Untuk 2024:**
            1. Ada teks di **D** (Activity).
            2. Ada nominal di **E** (Jumlah).
            3. Ada teks mata uang di **F** (Currency).
        *   **Untuk 2025 & 2026:**
            1. Ada teks di **D** (Activity).
            2. Ada nominal di **E ATAU F** (Jumlah).
            3. Ada teks mata uang HANYA di **G** (Currency).
    *   Jika syarat sesuai tahunnya terpenuhi, baris tersebut PASTI adalah Data/Item.
2.  **Judul Grup (Batch Header):**
    *   **Kondisi Awal:** Bukan Baris Data (salah satu dari D, E, F kosong).
    *   **Syarat Mutlak:** **HARUS ADA data di kolom B**. (Bisa berlanjut ke C atau D, tapi kolom B wajib terisi).
    *   **Deteksi Visual Dihapus:** Kita **TIDAK** lagi menggunakan deteksi warna biru atau teks tebal. Hanya murni berdasarkan letak teks di kolom B.
    *   **Aksi:** Jika terdeteksi di bagian bawah (setelah divider), kita menyiapkan Settlement baru (Batch baru).
    *   **Penanganan Judul Ganda (Kasus 2026):** Jika ada dua baris judul yang muncul berurutan (misalnya baris 299 berisi "20260109_L5A-086..." dan baris 300 berisi "Trip to L5A-086") tanpa diselingi Baris Data, kita akan **menggabungkan** kedua teks tersebut menjadi satu judul Settlement yang lengkap (Contoh: `"20260109_L5A-086... - Trip to L5A-086"`).
3.  **Pemisah (Divider) "OPERATION COST AND OFFICE":**
    *   Baris ini adalah pemisah utama.
    *   **Bagian Atas (Sebelum Divider):** Setiap Baris Data langsung menjadi **Single** Settlement yang berdiri sendiri.
    *   **Bagian Bawah (Setelah Divider):** Baris Data akan masuk ke dalam **Grup (Batch)** yang ditentukan oleh Judul Grup terakhir.
4.  **Subkategori:**
    *   **Kondisi Awal:** Bukan Baris Data.
    *   **Lokasi Data:** Teks HANYA berada di kolom D.
    *   **Aksi:** Kita memperbarui ID Kategori sementara untuk item-item di bawahnya, tanpa membuat Settlement baru.
4.  **Baris Kosong:**
    *   Jika baris kosong, kita memutus grup saat ini.

## 3. Strategi Klasifikasi Single vs Batch (The Cheat Code)

Seringkali sulit menentukan apakah sebuah grup adalah "Single" atau "Batch" saat baru membaca judulnya (karena kita belum tahu berapa banyak item di bawahnya).

**Solusi Jitu:**
Kita akan menganggap semua grup baru sebagai `Batch`. Setelah seluruh script selesai membaca data dan menghasilkan file SQL, kita akan menambahkan satu baris SQL super ampuh di akhir file:
```sql
-- Mengubah batch menjadi single jika grup tersebut ternyata HANYA memiliki 1 item pengeluaran
UPDATE public.settlements 
SET settlement_type = 'single' 
WHERE id IN (
    SELECT settlement_id 
    FROM public.expenses 
    GROUP BY settlement_id 
    HAVING COUNT(id) = 1
);
```
Dengan trik ini, kita dijamin mendapat jumlah Single dan Batch yang 100% akurat sesuai dengan berapa banyak item yang benar-benar masuk ke dalam grup tersebut.

## 4. User Review Required

> [!IMPORTANT]
> **Mohon konfirmasi Anda:**
> 1. Apakah aturan Baris Data (Wajib ada isi di D, E, F) sudah tepat sesuai maksud Anda?
> 2. Apakah trik SQL `UPDATE` di akhir (mengubah otomatis ke Single jika item cuma 1) dapat diterima? Ini jauh lebih aman dan akurat daripada mencoba menebak di tengah jalan.
> 
> Jika Anda setuju dengan *Plan* ini, mohon berikan approval/persetujuan agar saya bisa langsung menulis kode perbaikannya ke `generate_hybrid_migration_v13.py`.
