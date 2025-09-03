@echo off
echo ====================================
echo  Stopping Swaplify Queue Worker
echo ====================================
echo.

docker-compose down

if %errorlevel% equ 0 (
    echo ✅ Queue Worker berhasil dihentikan
) else (
    echo ❌ Terjadi error saat menghentikan services
)

echo.
pause
