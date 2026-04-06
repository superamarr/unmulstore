# Project Overview

[TODO: Saya membutuhkan konteks lebih lanjut mengenai aplikasi apa yang ingin Anda bangun. Apakah ini aplikasi e-commerce, sosial media, manajemen stok, atau yang lainnya? Apa saja fitur utama yang diharapkan?]

## Teknologi Utama
- **Frontend:** Flutter (Dart)
- **Backend/Database:** Supabase (Authentication, PostgreSQL Database, Storage, Realtime)
- **State Management:** [TODO: Mohon konfirmasi State Management yang ingin Anda gunakan, contoh: Riverpod, BLoC, Provider, atau GetX]
- **Routing:** [TODO: Mohon konfirmasi untuk Routing, contoh: GoRouter, AutoRoute]

---

# Standard Code

## Arsitektur & Struktur Direktori (Feature-Driven / Clean Architecture)
Aplikasi akan distrukturkan ke dalam beberapa folder berbasis fitur agar rapi dan scalable:

```text
lib/
 ├── core/              # Utilitas, konfigurasi, tema, konstanta, network/Supabase client
 ├── features/          # Berisi modul/fitur dalam aplikasi
 │   ├── auth/          # Contoh fitur autentikasi
 │   │   ├── data/      # Models, Repositories, Data Sources (Query Supabase)
 │   │   ├── domain/    # Entities, Use Cases (Logic bisnis)
 │   │   └── presentation/ # UI (Screens, Widgets), State Management Controllers
 ├── shared/            # Reusable widgets (Tombol kustom, dialog, dll)
 └── main.dart          # Entry point aplikasi
```

## Best Practices
1. **Pemisahan Logika (Separation of Concerns):** Jangan memanggil Supabase/database langsung dari UI/Widget. Lakukan pemanggilan data (`Supabase.instance.client...`) di dalam layer repository/data source dan teruskan ke State Management.
2. **Kinerja (Performance):** Selalu gunakan `const` constructor dan `const` keyword pada widget untuk meminimalisir re-build UI yang tidak perlu. Ekstrak logic build yang panjang ke dalam widget terpisah.
3. **Linter & Formatting:** Patuhi panduan `flutter_lints` di `analysis_options.yaml`. Hindari peringatan linter sebisa mungkin dan jalankan `dart format` sebelum commit.
4. **Penamaan:**
   - Gunakan `PascalCase` untuk nama Class (contoh: `UserProfileScreen`).
   - Gunakan `camelCase` untuk variabel dan fungsi (contoh: `fetchUserData()`).
   - Gunakan `snake_case` untuk penamaan file dan folder (contoh: `user_profile_screen.dart`).
5. **Penanganan Error (Error Handling):** Jangan telan error tanpa log (contoh `catch(e) {}`). Berikan feedback kepada pengguna bila hal seperti gagal fetch data terjadi.

---

# Standar Security

## 1. Supabase Row Level Security (RLS)
- **Wajib Aktif RLS:** Semua tabel di database Postgres Supabase harus mengaktifkan RLS (Row Level Security).
- **Pembatasan Akses:** Hanya berikan akses (Policies) ke entitas data yang relevan. Contoh: Baris/Row tertentu hanya dapat dibaca/diedit oleh pengguna yang membuat baris tersebut (`auth.uid() = user_id`).
- Keamanan datamurni bertumpu pada Supabase RLS, tidak boleh mengandalkan filter query dari sisi Flutter sebagai pertahanan sekuriti karena query frontend bisa dimanipulasi.

## 2. API Keys & Pengaturan Lingkungan (Environment Variables)
- **Kunci Publik (Anon Key):** Gunakan Supabase URI dan `anon_key` untuk inisialisasi client Flutter.
- **Service Role Key:** **Sangat Dilarang** meletakkan atau menggunakan `service_role_key` (kunci super admin) Supabase di dalam kode Flutter. Service Key hanya boleh berada di backend/server tertutup.
- Untuk secret keys lain (misalnya API Key Google Maps, dll), letakkan dalam file `.env` menggunakan library `flutter_dotenv` dan pastikan file `.env` masuk dalam `.gitignore`.

## 3. Data Storage & Authentication
- SDK Supabase Flutter akan mendangani sesi Token Authentication (JWT) secara otomatis dan aman di local device, namun jika Anda perlu menyimpan autentikasi/token dari layanan lain pihak ketiga, gunakan library seperti `flutter_secure_storage`.
- Data sensitif seperti password dari layar regitrasi jangan pernah dilog/di-print (`print()` atau `debugPrint()`) ke terminal aplikasi.

## 4. Validasi Data
- **Sisi Frontend:** Lakukan validasi input pengguna secara menyeluruh saat pengisian form di Flutter (misal: panjang password minimal, format email) menggunakan `FormBuilder` atau standar form validasi.
- **Sisi Backend:** Tambahkan database constraints dan check rules di PostgreSQL/Supabase untuk keamanan berlapis jika API di-hit dari luar aplikasi Flutter.
