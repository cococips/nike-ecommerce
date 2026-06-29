# 🛒 Nike E-Commerce App (Flutter)

Aplikasi *e-commerce* premium modern untuk katalog dan penjualan sepatu Nike. Proyek ini dibangun menggunakan standar industri teratas (State of the Art) untuk ekosistem Flutter modern.

## 🚀 Tech Stack & Arsitektur
- **Framework:** Flutter SDK 3.x
- **State Management:** Riverpod 2.x dengan *Code Generation* (`riverpod_annotation`).
- **Routing:** `go_router` untuk navigasi berbasis URL dan perlindungan halaman (*Route Guarding*).
- **Data Modeling:** `freezed` & `json_serializable` untuk menjamin keamanan tipe data (*Immutable Classes*).
- **Backend:** Firebase (Authentication, Cloud Firestore, Cloud Storage).
- **Arsitektur Kode:** **Clean Architecture** berlapis (`Domain`, `Data`, `Presentation`) yang dikelompokkan berdasarkan fitur (*Feature-First*).

---

## 📈 Progress Saat Ini (Telah Diselesaikan)

- ✅ **Pondasi Arsitektur:** Setup Riverpod, GoRouter, dan Firebase.
- ✅ **Panel Admin Rahasia:** Fitur CRUD produk, termasuk *upload* gambar ke Firebase Storage.
- ✅ **Katalog Home Screen:** Daftar produk tersinkronisasi *real-time* dengan Firestore.
- ✅ **Navigasi Utama (Bottom Nav):** Struktur 5 Menu Utama (Home, Shop, Search, Bag, Profile) menggunakan *IndexedStack* untuk performa memori.
- ✅ **Sistem Autentikasi:** Integrasi *Firebase Auth* untuk Login/Daftar via Email & Google Sign-In.
- ✅ **Halaman Profil:** Menampilkan Foto Profil dan Nama secara *live* dari akun Google pengguna.

---

## 📝 To-Do List & Roadmap Pengembangan

Berikut adalah rencana fitur yang harus dikerjakan selanjutnya secara bertahap:

### [x] Tahap 2: Keranjang Belanja (Shopping Cart)
- [x] Ubah halaman **Bag** menjadi daftar keranjang sungguhan.
- [x] Buat logika *state management* untuk menyimpan produk yang ditambahkan ke keranjang.
- [x] Tambahkan fungsionalitas tambah (+), kurangi (-), dan hapus barang di keranjang.
- [x] Kalkulasi total harga otomatis.

### [x] Tahap 3: Sistem Pencarian & Filter (Search)
- [x] Ubah halaman **Search** menjadi fungsional.
- [x] Tambahkan bilah pencarian untuk mencari nama sepatu.
- [x] Tambahkan tombol filter kategori (misal: *Running, Basketball, Lifestyle*).

### [ ] Tahap 4: Sistem Favorit (Wishlist)
- [ ] Fungsikan tombol *Love* (Favorit) di setiap kartu/detail produk.
- [ ] Simpan daftar produk yang disukai ke Firestore (berdasarkan akun *user*).
- [ ] Tampilkan produk favorit tersebut di dalam menu **Favorit** (di halaman Profile).

### [ ] Tahap 5: Checkout & Riwayat Pesanan
- [ ] Buat alur konfirmasi *Checkout* saat menekan tombol beli di keranjang.
- [ ] Buat form pengisian alamat simulasi.
- [ ] Pindahkan produk yang di-*checkout* ke koleksi "Riwayat Pesanan".
- [ ] Tampilkan data riwayat belanja di dalam menu **Pesanan Saya** (di halaman Profile).

### [ ] Tahap 6: Poles UI Premium & Animasi
- [ ] **Hero Animations:** Transisi membesar saat menekan gambar sepatu dari *Home* ke *Detail*.
- [ ] **Shimmer Effect:** Animasi abu-abu berkedip saat menunggu data memuat dari internet (menggantikan *loading* bundar biasa).
- [ ] Tambahkan efek *Micro-animations* (animasi pantulan) pada tombol.
- [ ] *(Opsional)* Dukungan fitur **Dark Mode**.

---

*File ini (`README.md`) akan menjadi acuan kerja kita. Centang kotak To-Do List di atas seiring dengan berjalannya proses pengembangan.*
