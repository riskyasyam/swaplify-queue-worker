# Script untuk copy queue-worker ke project swaplify-nest
param(
    [Parameter(Mandatory=$true)]
    [string]$NestProjectPath
)

Write-Host "🚀 Mengintegrasikan Queue Worker ke project NestJS..." -ForegroundColor Green

# Validasi path project NestJS
if (-not (Test-Path $NestProjectPath)) {
    Write-Host "❌ Path project NestJS tidak ditemukan: $NestProjectPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "$NestProjectPath\package.json")) {
    Write-Host "❌ Tidak ada package.json di path tersebut. Pastikan path menuju ke root project NestJS." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Project NestJS ditemukan di: $NestProjectPath" -ForegroundColor Green

# Buat folder queue-worker
$queueWorkerPath = Join-Path $NestProjectPath "queue-worker"
if (-not (Test-Path $queueWorkerPath)) {
    New-Item -ItemType Directory -Path $queueWorkerPath -Force
    Write-Host "📁 Folder queue-worker dibuat" -ForegroundColor Green
}

# Copy files queue-worker
Copy-Item "index.js" "$queueWorkerPath\" -Force
Copy-Item "package.json" "$queueWorkerPath\" -Force
Write-Host "📄 Files queue-worker berhasil di-copy" -ForegroundColor Green

# Copy ecosystem config
Copy-Item "ecosystem.config.js" "$NestProjectPath\" -Force
Write-Host "📄 ecosystem.config.js berhasil di-copy" -ForegroundColor Green

# Copy start script
Copy-Item "start.sh" "$NestProjectPath\" -Force
Write-Host "📄 start.sh berhasil di-copy" -ForegroundColor Green

# Copy Dockerfile
Copy-Item "Dockerfile-for-swaplify-nest" "$NestProjectPath\Dockerfile" -Force
Write-Host "📄 Dockerfile berhasil di-copy" -ForegroundColor Green

# Backup dan update package.json NestJS untuk menambah PM2
$nestPackageJson = Get-Content "$NestProjectPath\package.json" | ConvertFrom-Json
if (-not $nestPackageJson.dependencies.pm2) {
    $nestPackageJson.dependencies | Add-Member -NotePropertyName "pm2" -NotePropertyValue "^5.3.0"
    $nestPackageJson | ConvertTo-Json -Depth 10 | Set-Content "$NestProjectPath\package.json"
    Write-Host "📦 PM2 dependency ditambahkan ke package.json" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ INTEGRASI SELESAI!" -ForegroundColor Green
Write-Host ""
Write-Host "Langkah selanjutnya:" -ForegroundColor Cyan
Write-Host "1. cd `"$NestProjectPath`"" -ForegroundColor White
Write-Host "2. docker build -t swaplify-nest ." -ForegroundColor White
Write-Host "3. docker run -d --name swaplify -p 3000:3000 --env-file .env swaplify-nest" -ForegroundColor White
Write-Host ""
Write-Host "Atau gunakan docker-compose jika ada." -ForegroundColor Yellow
