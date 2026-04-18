# Expense Tracker App

Aplikasi mobile pencatat pengeluaran harian yang dibangun dengan Flutter dan Firebase. Aplikasi ini memungkinkan pengguna untuk mencatat, mengkategorikan, dan memantau pengeluaran secara real-time dengan tampilan yang bersih dan intuitif.

---

## Fitur Utama

- Pencatatan pengeluaran dengan judul, nominal, kategori, dan tanggal
- Dashboard harian yang menampilkan ringkasan total pengeluaran hari ini beserta sapaan berdasarkan waktu
- Enam kategori pengeluaran: Makanan & Minuman, Transportasi, Belanja, Hiburan, Kesehatan, dan Lainnya
- Halaman statistik dengan toggle antara tampilan Expense dan Income
- Filter pengeluaran berdasarkan kategori dan rentang tanggal (per bulan)
- Operasi CRUD penuh: tambah, lihat, perbarui, dan hapus data
- Hapus semua data sekaligus dengan operasi batch Firestore
- Sinkronisasi data real-time menggunakan Cloud Firestore (stream & one-time fetch)
- Penanganan state yang reaktif dengan indikator loading, empty state, dan error state
- Halaman pengaturan (Akun & Notifikasi)

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
    ├── main.dart                   # Entry point aplikasi, inisialisasi Firebase & locale id_ID
    ├── firebase_options.dart       # Konfigurasi Firebase per platform
    ├── cubit/
    │   ├── expense_cubit.dart      # Logika bisnis: load, add, update, delete, filter
    │   └── expense_state.dart      # Definisi state (Initial, Loading, Loaded, Error, Empty)
    ├── models/
    │   ├── expense.dart            # Model data pengeluaran dengan serialisasi Firestore
    │   ├── expense_category.dart   # Enum kategori pengeluaran dengan displayName
    │   └── app_routes.dart         # Konstanta nama dan path rute (part of app_router.dart)
    ├── routes/
    │   └── app_router.dart         # Konfigurasi navigasi dengan GoRouter & StatefulShellRoute
    ├── screens/
    │   ├── home_page.dart          # Shell navigasi dengan bottom navigation bar dan FAB
    │   ├── home_screen.dart        # Dashboard pengeluaran harian dengan sapaan waktu
    │   ├── statistic_screen.dart   # Halaman statistik dengan toggle Income/Expense
    │   ├── add_expense_page.dart   # Formulir tambah pengeluaran dengan category picker
    │   └── setting_page.dart       # Halaman pengaturan (Akun & Notifikasi)
    ├── services/
    │   └── firebase_service.dart   # Operasi CRUD, stream, filter kategori & tanggal ke Firestore
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

## Navigasi

Aplikasi menggunakan GoRouter dengan `StatefulShellRoute` untuk menjaga state antar tab:

| Route | Path | Keterangan |
|---|---|---|
| Home | `/home` | Dashboard pengeluaran harian |
| Transaction | `/transaction` | Statistik & riwayat transaksi |
| Add | `/add` | Formulir tambah pengeluaran |
| Setting | `/setting` | Halaman pengaturan |

---

## State Management

Aplikasi menggunakan pola BLoC/Cubit dengan state berikut:

| State | Keterangan |
|---|---|
| `ExpenseInitial` | State awal sebelum data dimuat |
| `ExpenseLoading` | Sedang memuat atau memproses data |
| `ExpenseLoaded` | Data berhasil dimuat, menyimpan list dan total |
| `ExpenseEmpty` | Data berhasil dimuat namun kosong |
| `ExpenseError` | Terjadi kesalahan, menyimpan pesan error |

---

## Teknologi yang Digunakan

| Teknologi | Versi | Keterangan |
|---|---|---|
| Flutter | ^3.9.0 | Framework UI lintas platform |
| Dart | ^3.9.0 | Bahasa pemrograman |
| firebase_core | ^4.6.0 | Inisialisasi Firebase |
| cloud_firestore | ^6.2.0 | Database NoSQL real-time |
| flutter_bloc | ^9.1.1 | State management dengan pola BLoC/Cubit |
| go_router | ^17.1.0 | Navigasi deklaratif dengan StatefulShellRoute |
| fl_chart | ^1.1.1 | Visualisasi grafik dan chart |
| intl | ^0.20.2 | Internasionalisasi dan format tanggal (id_ID) |
| flutter_form_builder | ^10.2.0 | Pengelolaan formulir |
| flutter_localizations | SDK | Lokalisasi Flutter |
| toggle_switch | ^2.3.0 | Komponen toggle UI |
| provider | ^6.1.5+1 | Dependency injection |
| cupertino_icons | ^1.0.8 | Ikon gaya iOS |
