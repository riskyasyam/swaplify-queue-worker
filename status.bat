@echo off
echo ====================================
echo  Swaplify Queue Worker - Status & Logs
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
echo.

echo 📋 Container Status:
docker ps --filter "name=swaplify-queue-worker" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
echo.

echo 📝 Queue Worker Logs (Last 20 lines):
echo =====================================
docker logs --tail 20 swaplify-queue-worker
echo =====================================
echo.

echo 🔄 Commands:
echo   - Live logs: docker logs -f swaplify-queue-worker
echo   - Stop: docker stop swaplify-queue-worker
echo   - Restart: docker restart swaplify-queue-worker
echo.
pause
