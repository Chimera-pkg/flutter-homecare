# Precision Nutrition Module

Modul ini menyediakan fitur lengkap untuk assessment nutrisi presisi dengan alur yang terstruktur dan state management menggunakan Cubit.

## Fitur Utama

- **Main Concern Selection**: Pemilihan concern utama (Sub-Health, Chronic Disease, Anti-aging)
- **Health History Form**: Form lengkap untuk informasi kesehatan dasar
- **Self-Rated Health**: Rating kesehatan diri dengan slider dan emoji
- **Lifestyle & Habits**: Input kebiasaan gaya hidup harian
- **Nutrition Habits**: Preferensi dan kebiasaan nutrisi
- **Biomarker Upload**: Upload file medis dan koneksi device wearable

## Struktur File

```
lib/cubit/precision/
├── precision_cubit.dart          # Cubit untuk state management
├── precision_page.dart           # Halaman utama Precision Nutrition
├── widgets/
│   └── precision_widgets.dart   # Widget yang dapat digunakan kembali
├── screens/
│   ├── index.dart               # Export semua screens
│   ├── main_concern_screen.dart # Screen pemilihan concern utama
│   ├── health_history_screen.dart # Form riwayat kesehatan
│   ├── self_rated_health_screen.dart # Rating kesehatan diri
│   ├── lifestyle_habits_screen.dart # Form kebiasaan gaya hidup
│   ├── nutrition_habits_screen.dart # Form kebiasaan nutrisi
│   └── biomarker_upload_screen.dart # Upload biomarker dan device
└── README.md                     # Dokumentasi ini
```

## State Management

Modul menggunakan `NutritionAssessmentCubit` untuk mengelola state dengan properti:

- `mainConcern`: Concern utama yang dipilih user
- `healthProfile`: Profil kesehatan lengkap
- `selfRatedHealth`: Rating kesehatan diri (1.0 - 5.0)
- `lifestyleHabits`: Kebiasaan gaya hidup
- `nutritionHabits`: Kebiasaan nutrisi
- `uploadedFiles`: Daftar file yang diupload
- `isLoading`: Status loading
- `errorMessage`: Pesan error jika ada

## Alur Navigasi

1. **PrecisionNutritionPage** → **MainConcernScreen**
2. **MainConcernScreen** → **HealthHistoryScreen**
3. **HealthHistoryScreen** → **SelfRatedHealthScreen**
4. **SelfRatedHealthScreen** → **LifestyleHabitsScreen**
5. **LifestyleHabitsScreen** → **NutritionHabitsScreen**
6. **NutritionHabitsScreen** → **BiomarkerUploadScreen**

## Widget yang Dapat Digunakan Kembali

- `CustomAppBar`: AppBar dengan tombol kembali dan judul tengah
- `PrimaryButton`: Tombol utama berwarna teal
- `SecondaryButton`: Tombol sekunder dengan border teal
- `CustomTextField`: TextField dengan label dan styling konsisten
- `CustomDropdown`: Dropdown untuk pilihan
- `CustomCheckbox`: Checkbox dengan label
- `SelectionCard`: Card untuk pilihan concern

## Data Dummy

Modul ini menggunakan data dummy untuk demonstrasi:

- File upload disimulasikan dengan nama file dummy
- Koneksi wearable device menampilkan snackbar
- Submit assessment menggunakan delay 2 detik

## Cara Penggunaan

1. Import modul:

```dart
import 'package:m2health/cubit/precision/precision_page.dart';
```

2. Navigasi ke halaman utama:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => PrecisionNutritionPage()),
);
```

3. Untuk menggunakan Cubit di screen lain:

```dart
BlocProvider(
  create: (context) => NutritionAssessmentCubit(),
  child: YourScreen(),
);
```

## Dependencies

- `flutter_bloc`: State management
- `equatable`: Comparison untuk state objects
- `flutter`: Framework utama

## Catatan

- Semua form memiliki validasi input
- State tersimpan di Cubit selama alur assessment
- Error handling untuk submit assessment
- UI responsif dan modern dengan tema konsisten
- Menggunakan warna teal (#00B4D8) sebagai primary color
