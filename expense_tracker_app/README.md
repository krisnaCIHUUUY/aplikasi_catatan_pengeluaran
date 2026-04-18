# Expense Tracker App

Aplikasi mobile pencatat pengeluaran harian yang dibangun dengan Flutter dan Firebase. Aplikasi ini memungkinkan pengguna untuk mencatat, mengkategorikan, dan memantau pengeluaran secara real-time dengan tampilan yang bersih dan intuitif.

---

## Fitur Utama

- Pencatatan pengeluaran dengan judul, nominal, kategori, dan tanggal
- Dashboard harian yang menampilkan ringkasan total pengeluaran hari ini
- Enam kategori pengeluaran: Makanan & Minuman, Transportasi, Belanja, Hiburan, Kesehatan, dan Lainnya
- Halaman statistik dengan tampilan grafik batang per kategori
- Toggle antara tampilan Income dan Expense pada halaman transaksi
- Filter pengeluaran berdasarkan rentang tanggal dan kategori
- Operasi CRUD penuh: tambah, lihat, perbarui, dan hapus data
- Sinkronisasi data real-time menggunakan Cloud Firestore
- Penanganan state yang reaktif dengan indikator loading, empty state, dan error state

---

## Instalasi dan Menjalankan Proyek

### Prasyarat

Pastikan perangkat pengembangan telah memiliki:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) versi `^3.9.0`
- [Dart SDK](https://dart.dev/get-dart) versi `^3.9.0`
- [Android Studio](https://developer.android.com/studio) atau [Xcode](https://developer.apple.com/xcode/) (untuk iOS)
- Akun [Firebase](https://firebase.google.com/) dengan proyek yang sudah dikonfigurasi

### Langkah Instalasi

**1. Clone repositori**

```bash
git clone <url-repositori>
cd expense_tracker_app
```

**2. Install dependensi**

```bash
flutter pub get
```

**3. Konfigurasi Firebase**

- Buat proyek baru di [Firebase Console](https://console.firebase.google.com/)
- Aktifkan Cloud Firestore pada proyek tersebut
- Unduh file konfigurasi:
  - `google-services.json` untuk Android, letakkan di `android/app/`
  - `GoogleService-Info.plist` untuk iOS, letakkan di `ios/Runner/`
- Pastikan file `lib/firebase_options.dart` sudah sesuai dengan konfigurasi proyek Firebase Anda. Anda dapat men-generate ulang file ini menggunakan [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/):

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

**4. Jalankan aplikasi**

```bash
flutter run
```

Untuk menjalankan pada perangkat atau emulator tertentu:

```bash
flutter run -d <device-id>
```

Untuk melihat daftar perangkat yang tersedia:

```bash
flutter devices
```

---

## Struktur Folder

```
expense_tracker_app/
├── android/                        # Konfigurasi platform Android
├── ios/                            # Konfigurasi platform iOS
└── lib/
    ├── main.dart                   # Entry point aplikasi, inisialisasi Firebase
    ├── firebase_options.dart       # Konfigurasi Firebase per platform
    ├── cubit/
    │   ├── expense_cubit.dart      # Logika bisnis dan operasi data
    │   └── expense_state.dart      # Definisi state (Loading, Loaded, Error, Empty)
    ├── models/
    │   ├── expense.dart            # Model data pengeluaran dengan serialisasi Firestore
    │   ├── expense_category.dart   # Enum kategori pengeluaran
    │   └── app_routes.dart         # Konstanta nama dan path rute
    ├── routes/
    │   └── app_router.dart         # Konfigurasi navigasi dengan GoRouter
    ├── screens/
    │   ├── home_page.dart          # Shell navigasi dengan bottom navigation bar
    │   ├── home_screen.dart        # Dashboard pengeluaran harian
    │   ├── statistic_screen.dart   # Halaman statistik dan riwayat transaksi
    │   └── add_expense_page.dart   # Formulir tambah pengeluaran baru
    ├── services/
    │   ├── firebase_service.dart   # Operasi CRUD ke Cloud Firestore
    │   └── api_service.dart        # Layanan REST API (alternatif)
    ├── utils/
    │   ├── app_theme.dart          # Konfigurasi tema Material 3
    │   ├── colors.dart             # Palet warna dan warna per kategori
    │   ├── expense_icon.dart       # Pemetaan ikon per kategori
    │   ├── empty_state.dart        # Widget tampilan data kosong
    │   └── loading_state.dart      # Widget indikator loading
    └── widgets/
        ├── summary_card.dart       # Kartu ringkasan saldo dan pengeluaran
        ├── expense_card.dart       # Item kartu satu pengeluaran
        ├── expense_icon_card.dart  # Kartu ikon kategori
        ├── bar_chart.dart          # Grafik batang statistik
        ├── date_header.dart        # Header tanggal pada daftar transaksi
        ├── expense_page.dart       # Halaman daftar pengeluaran pada statistik
        └── income_page.dart        # Halaman daftar pemasukan pada statistik
```

---

## Teknologi yang Digunakan

| Teknologi | Versi | Keterangan |
|---|---|---|
| Flutter | ^3.9.0 | Framework UI lintas platform |
| Dart | ^3.9.0 | Bahasa pemrograman |
| firebase_core | ^4.6.0 | Inisialisasi Firebase |
| cloud_firestore | ^6.2.0 | Database NoSQL real-time |
| flutter_bloc | ^9.1.1 | State management dengan pola BLoC/Cubit |
| go_router | ^17.1.0 | Navigasi deklaratif |
| fl_chart | ^1.1.1 | Visualisasi grafik dan chart |
| intl | ^0.20.2 | Internasionalisasi dan format tanggal (id_ID) |
| flutter_form_builder | ^10.2.0 | Pengelolaan formulir |
| toggle_switch | ^2.3.0 | Komponen toggle UI |
| provider | ^6.1.5+1 | Dependency injection |
