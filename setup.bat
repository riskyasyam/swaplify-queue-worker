@echo off
echo 🚀 Swaplify Queue Worker - Windows Quick Start
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker not found. Please install Docker Desktop first.
    echo Download from: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

echo ✅ Docker found

REM Check if Docker is running
docker version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker Desktop.
    pause
    exit /b 1
)

echo ✅ Docker is running
echo.
echo 🔧 Setup complete! Ready to build and run.
echo.
echo Next steps:
echo 1. Create .env file: copy .env.example .env
echo 2. Build and run: docker-compose up -d
echo 3. View logs: docker-compose logs -f app
echo.
pause
