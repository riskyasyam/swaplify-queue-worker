# ============================================
# INSTRUKSI: Copy files ini ke project swaplify-nest
# ============================================

## File yang perlu di-copy ke swaplify-nest:

1. **queue-worker/** (folder baru)
   - index.js
   - package.json

2. **ecosystem.config.js** (update/ganti yang ada)

3. **start.sh** (update/ganti yang ada)

## Langkah-langkah:

### 1. Buat folder queue-worker di project swaplify-nest
```bash
mkdir queue-worker
```

### 2. Copy file queue-worker
Copy files berikut ke folder queue-worker/:
- index.js
- package.json

### 3. Update Dockerfile di swaplify-nest
Tambahkan dependencies queue-worker dan PM2

### 4. Update ecosystem.config.js di swaplify-nest
Untuk menjalankan kedua service

### 5. Update start script di swaplify-nest
Untuk menggunakan PM2

## Struktur target di swaplify-nest:
```
swaplify-nest/
├── src/
├── queue-worker/
│   ├── index.js
│   └── package.json
├── ecosystem.config.js
├── Dockerfile
├── start.sh
└── package.json
```
