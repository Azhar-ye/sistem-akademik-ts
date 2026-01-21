# 📚 Sistem Akademik Flutter + Firebase (Realtime)

Aplikasi **Sistem Akademik** berbasis **Flutter** yang terhubung dengan **Firebase Authentication** dan **Cloud Firestore** secara **real-time**.

Project ini memiliki fitur login seperti aplikasi modern, manajemen nilai mahasiswa (CRUD), manajemen mata kuliah dari Firestore, serta dashboard statistik akademik.

---

## ✨ Fitur Utama

### 🔐 Authentication
- Login & Register menggunakan **Firebase Auth (Email/Password)**

### 👤 Role User
- **Admin**
  - CRUD Nilai Mahasiswa
  - CRUD Mata Kuliah
- **User**
  - Hanya bisa melihat data (Read Only)

### 📝 Nilai Mahasiswa (Realtime)
- Tambah / Edit / Hapus nilai mahasiswa (khusus admin)
- Data realtime update menggunakan **StreamBuilder + Firestore snapshots**
- Search **NIM / Nama**
- Filter berdasarkan **Mata Kuliah**

### 📌 Mata Kuliah (Realtime)
- Data mata kuliah diambil dari **Firestore** (bukan list manual)
- Dropdown matkul otomatis muncul saat input nilai

### 📊 Dashboard Statistik
- Total Mahasiswa (unik berdasarkan NIM)
- Total Data Nilai
- Total Nilai (akumulasi)
- Rata-rata Nilai keseluruhan

### 🎨 UI Modern
- Material 3 Theme
- Card modern
- Drawer menu navigasi

---

## 🛠️ Tech Stack
- Flutter
- Firebase Core
- Firebase Authentication
- Cloud Firestore
