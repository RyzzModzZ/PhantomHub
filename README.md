# Seraphin UI (UI-only preview)

**Seraphin UI (Ronix-style)** adalah versi *UI-only* dari tampilan executor Seraphin — dibuat untuk keperluan preview, desain, dan distribusi di GitHub.  
> ⚠️ **Catatan penting:** ini adalah *UI-only preview*. Script ini **tidak** mengeksekusi kode Roblox eksternal dan **tidak** berfungsi sebagai executor. Tidak ada `loadstring`, tidak ada pembentukan Script di ServerScriptService, dan tidak ada bypass.

## Fitur
- Desain Ronix-like: sidebar kiri, area script cards, header, search.
- Logo toggle di pojok kiri atas (asset id `135748028632686`) untuk buka/tutup UI.
- Animasi slide + fade saat buka/tutup.
- Demo cards dan modal preview untuk masing-masing script.
- Safe copy ke clipboard bila fungsi `setclipboard` tersedia.
- Simpan snippet sementara via `getgenv()` (fallback).

## Cara pakai
1. Salin file `Seraphin_UI_Ronix_safe.lua` ke komputer/HP-mu.  
2. (Opsional) Jalankan di environment yang aman hanya untuk tampilan — **ingat** file ini tidak menjalankan script Roblox.  
3. Untuk developer: gunakan file ini sebagai referensi UI / tema ketika mengembangkan frontend.

## Cara publish ke GitHub
1. Buat repository baru (mis. `seraphin-ui-ronix`).
2. Upload file `Seraphin_UI_Ronix_safe.lua`, `README.md`, dan file web preview (`index.html`, `style.css`, `script.js`) jika ingin GitHub Pages.
3. Commit & Push.

## GitHub Pages (opsional)
Untuk menampilkan preview di web:
1. Upload `index.html`, `style.css`, `script.js` ke repo.
2. Aktifkan **Settings → Pages** dan pilih branch `main` (atau `gh-pages`) dan folder `/ (root)`.
3. Tunggu beberapa menit, lalu buka URL yang diberikan GitHub Pages.

## Lisensi
Gunakan untuk keperluan desain & edukasi. Tidak diperkenankan menggunakan file ini untuk mendistribusikan atau membuat tools yang mengeksekusi skrip pihak ketiga di Roblox.
