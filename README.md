# Swaplify Queue Worker

🚀 **Queue worker service untuk memproses job face fusion dari NSQ.**

## ⚡ Quick Start

### 1. Pastikan swaplify-nest sudah berjalan
Queue worker ini connect ke NSQ yang sudah ada di project swaplify-nest.

### 2. Setup Environment
```powershell
# File .env sudah siap, edit jika perlu
notepad .env
```

### 3. Run as Administrator
**PENTING**: Buka PowerShell/Command Prompt **sebagai Administrator**

### 4. Build & Run Queue Worker Only
```powershell
# Menggunakan script
.\start.bat

# Atau manual
docker-compose up -d --build
```

## 📦 Yang Akan Berjalan

- **Queue Worker** - Memproses job dari NSQ (1 container saja)
- **Connect ke NSQ** - Yang sudah berjalan di swaplify-nest
- **NSQ Admin UI** - http://localhost:4171 (dari swaplify-nest)

## 🔧 Environment Variables

```env
NSQ_TOPIC=facefusion_jobs
NSQ_CHANNEL=facefusion_worker
NSQ_HOST=host.docker.internal
NSQ_PORT=4150
NEST_API_URL=http://host.docker.internal:3000
WORKER_URL=http://host.docker.internal:8081/worker/facefusion
WORKER_SHARED_SECRET=supersecret
INTERNAL_SECRET=internalsecret
```

## 📋 Commands

```powershell
# Lihat logs
docker logs -f swaplify-queue-worker

# Stop worker
docker stop swaplify-queue-worker

# Restart worker
docker-compose restart

# Status
docker ps
```

## 🔗 Integrasi dengan NestJS

Queue worker ini akan:
1. 📨 Terima job dari NSQ topic `facefusion_jobs` (dari swaplify-nest)
2. 🔄 Ambil asset details dari NestJS API
3. 🚀 Kirim job ke FastAPI worker
4. ✅ Update job status via callback

**Prerequisites**: Pastikan swaplify-nest berjalan dengan NSQ services di port 4150.
