Anda baru saja menerima tanggung jawab untuk melanjutkan pengembangan aplikasi FoodieQuest dari developer sebelumnya yang meninggalkan proyek secara mendadak. Sayangnya, beliau meninggalkan kode dalam keadaan yang cukup "berantakan" dan penuh dengan _bug_.

Aplikasi ini seharusnya memiliki fitur:

1.  **Daftar Resep**: Menampilkan resep masakan dari server.
2.  **Detail Resep**: Melihat detail bahan dan instruksi.
3.  **Favorit**: Menandai resep sebagai favorit.
4.  **Galeri Foto**: Menampilkan foto makanan yang diunggah pengguna.
5.  **Upload Foto**: Mengunggah foto makanan baru.

Saat ini, aplikasi tersebut **bahkan mungkin tidak bisa dijalankan (build)**, dan jika bisa dijalankan, banyak fitur yang _crash_ atau tidak berfungsi semestinya.

## Tugas Anda

Tugas Anda adalah melakukan **Debugging** dan **Refactor** (jika perlu) untuk membuat aplikasi ini berjalan dengan normal dan bebas dari _error_.

### Langkah-langkah:

1. **Setup Supabase**: ikuti langkah-langkah setup supabase dulu di [SETUP_SUPABASE.md](SETUP_SUPABASE.md).
2. **Analisis Error**: Jalankan aplikasi dan perhatikan pesan error di konsol (Console/Logcat).
3. **Perbaiki Build Error**: Pastikan aplikasi bisa di-_install_ dan dijalankan di emulator/device.
4. **Uji Fitur**: Coba setiap fitur satu per satu:
   - Apakah daftar resep muncul?
   - Apakah detail resep aman?
   - Apakah fitur favorit berfungsi (ikon berubah warna)?
   - Apakah foto bisa dilihat?
   - Apakah upload foto berhasil?
5. **Perbaiki Bug**: Temukan penyebab masalah dan perbaiki kodenya. Masalah bisa tersebar di berbagai layer:
   - _Dependency management_ (`pubspec.yaml`)
   - _Data Models_ (Parsing JSON)
   - _API & Services_ (Koneksi ke server/storage)
   - _State Management_ (Provider)
   - _UI & Validation_ (Tampilan dan Input)

## Kriteria Keberhasilan

Aplikasi dianggap "selesai" jika:

- `flutter pub get` berhasil tanpa konflik.
- Aplikasi berjalan tanpa _crash_ saat dibuka.
- Daftar resep tampil dengan gambar dan teks yang benar.
- Masuk ke detail resep tidak _crash_.
- Menekan tombol "Love/Favorite" memperbarui UI secara instan.
- Tab "Photos" menampilkan gambar, bukan _loading_ selamanya.
- Halaman "Upload Photo" memvalidasi input dengan benar (tombol aktif saat ada gambar).
- Upload foto berhasil dan muncul di galeri.

Selamat bekerja dan _happy debugging_!
