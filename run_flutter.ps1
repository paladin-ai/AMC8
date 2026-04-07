# run_flutter.ps1
Write-Host "Step 1: Terminating locking processes..." -ForegroundColor Cyan
$processes = @('flutter', 'dart', 'chrome', 'msedge')
foreach ($proc in $processes) {
    Get-Process -Name $proc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

# Save the root directory (where this script is located, or use current location)
$rootDir = Get-Location

Write-Host "Step 2: Cleaning Flutter build files in 'frontend' folder..." -ForegroundColor Cyan
Set-Location -Path "frontend"
flutter clean

Write-Host "Step 3: Returning to root and starting Python proxy listener..." -ForegroundColor Cyan
Set-Location -Path $rootDir
$pythonScript = "tool/dev_api_proxy.py"
$pythonWindow = Start-Process powershell -ArgumentList "-NoExit -Command `"python $pythonScript; Read-Host 'Press Enter to close this proxy window'`"" -WindowStyle Normal -PassThru

# Wait a moment for the proxy to initialize
Start-Sleep -Seconds 2

Write-Host "Step 4: Running Flutter in Chrome (frontend folder)..." -ForegroundColor Cyan
Set-Location -Path "frontend"
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8787

# Optional: After flutter exits, you can kill the proxy window
Write-Host "Flutter process finished. Closing proxy window..." -ForegroundColor Yellow
Stop-Process -Id $pythonWindow.Id -Force -ErrorAction SilentlyContinue