@echo off
echo ====================================
echo  Cleanup Swaplify Queue Worker
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

echo 🧹 Cleaning up containers...

REM Stop and remove any existing containers
docker stop swaplify-queue-worker 2>nul
docker rm swaplify-queue-worker 2>nul

REM Remove orphaned containers
docker stop nsqadmin nsqd nsqlookupd 2>nul
docker rm nsqadmin nsqd nsqlookupd 2>nul

REM Clean up networks
docker network rm swaplify-queue-worker_default 2>nul

REM Clean up volumes and unused images
docker volume prune -f 2>nul
docker image prune -f 2>nul

echo ✅ Cleanup completed!
echo.
echo 🚀 Now run: .\start.bat
echo.
pause
