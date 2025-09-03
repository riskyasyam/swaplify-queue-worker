@echo off
echo ====================================
echo  Swaplify Queue Worker ONLY
echo ====================================
echo.

REM Check if running as administrator
NET SESSION >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Script ini harus dijalankan sebagai Administrator
    echo    Klik kanan pada file ini dan pilih "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo ✅ Running as Administrator

REM Check Docker
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker tidak ditemukan. Install Docker Desktop terlebih dahulu.
    pause
    exit /b 1
)

echo ✅ Docker ditemukan

REM Cleanup old containers first
echo 🧹 Cleaning up old containers...
docker stop swaplify-queue-worker 2>nul
docker rm swaplify-queue-worker 2>nul
docker stop nsqadmin nsqd nsqlookupd 2>nul
docker rm nsqadmin nsqd nsqlookupd 2>nul

REM Build and run queue worker only
echo.
echo 🚀 Building dan menjalankan Queue Worker...
echo.
echo ℹ️  Pastikan swaplify-nest sudah berjalan dengan NSQ services
echo.

docker-compose up -d --build

if %errorlevel% equ 0 (
    echo.
    echo ✅ SUCCESS! Queue Worker berhasil dijalankan
    echo.
    echo 📋 Queue Worker Status:
    docker ps --filter "name=swaplify-queue-worker" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
    echo.
    echo 📝 Lihat logs: docker logs -f swaplify-queue-worker
    echo ⏹️  Stop worker: docker stop swaplify-queue-worker
    echo.
    echo ℹ️  NSQ Services berjalan di swaplify-nest project
    echo    NSQ Admin: http://localhost:4171 (dari swaplify-nest)
) else (
    echo.
    echo ❌ Terjadi error saat menjalankan Docker
    echo    Pastikan swaplify-nest project sudah berjalan dengan NSQ
    echo    Atau jalankan: .\cleanup.bat lalu coba lagi
)

echo.
pause
