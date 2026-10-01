# Alur Koneksi `dashboard_screen.dart`

Berikut adalah diagram visual yang menunjukkan bagaimana file **`dashboard_screen.dart`** terhubung dengan file-file lainnya di dalam aplikasi Anda.

```mermaid
graph TD
    %% Node Styling
    classDef entryPoint fill:#e3f2fd,stroke:#1565c0,stroke-width:2px,color:#000
    classDef mainNode fill:#e8f5e9,stroke:#2e7d32,stroke-width:3px,color:#000
    classDef targetNode fill:#fff3e0,stroke:#e65100,stroke-width:2px,color:#000
    classDef helperNode fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px,color:#000

    %% Nodes
    A["main.dart<br>(Pintu Masuk Aplikasi)"]:::entryPoint
    B["dashboard_screen.dart<br>(Halaman Pilih Perusahaan)"]:::mainNode
    C["main_layout.dart<br>(Ruang Kerja Utama)"]:::targetNode
    D["auth_provider.dart<br>(Pengelola Akun & Logout)"]:::helperNode
    E["app_theme.dart<br>(Pengelola Warna & Desain)"]:::helperNode
    F["context_extensions.dart<br>(Pendeteksi Gelap/Terang)"]:::helperNode

    %% Connections
    A -- "1. Setelah Login berhasil,<br>arahkan ke sini" --> B
    B -- "2. Jika perusahaan dipilih,<br>oper ke sini" --> C
    B -. "Mengambil Hak Akses<br>& Fungsi Logout" .-> D
    B -. "Mengambil Palet Warna" .-> E
    B -. "Mendeteksi Mode HP" .-> F
```

> [!NOTE]
> * Garis penuh (panah solid) menunjukkan **Alur Perpindahan Layar** (Navigasi).
> * Garis putus-putus menunjukkan **Pengambilan Data / Bantuan** (Dependency).
