# PowerShell Script to Download OpenCV Colorization Model Files
# Run this in PowerShell: .\download_model.ps1

Write-Host "=========================================="
Write-Host "Downloading OpenCV Colorization Model"
Write-Host "=========================================="
Write-Host ""

# Create models directory if it doesn't exist
$modelsDir = "models"
if (!(Test-Path $modelsDir)) {
    New-Item -ItemType Directory -Path $modelsDir -Force | Out-Null
    Write-Host "[OK] Created models directory"
}

Set-Location $modelsDir

# File 1: Model Architecture (prototxt) - ~10KB
Write-Host "1/3 Downloading model architecture (prototxt)..."
$prototxtUrl = "https://raw.githubusercontent.com/richzhang/colorization/caffe/models/colorization_deploy_v2.prototxt"
$prototxtFile = "colorization_deploy_v2.prototxt"

try {
    Invoke-WebRequest -Uri $prototxtUrl -OutFile $prototxtFile -UseBasicParsing
    Write-Host "    [OK] Downloaded: $prototxtFile" -ForegroundColor Green
} catch {
    Write-Host "    [ERROR] Failed to download prototxt" -ForegroundColor Red
    Write-Host "    Error: $_" -ForegroundColor Red
}

# File 2: Model Weights (caffemodel) - ~130MB
Write-Host ""
Write-Host "2/3 Downloading model weights (caffemodel) - ~130MB..."
Write-Host "    This may take a few minutes depending on your connection..."
$caffemodelUrl = "https://www.dropbox.com/s/dx0qvhhp5hbcx7z/colorization_release_v2.caffemodel?dl=1"
$caffemodelFile = "colorization_release_v2.caffemodel"

try {
    Invoke-WebRequest -Uri $caffemodelUrl -OutFile $caffemodelFile -UseBasicParsing
    Write-Host "    [OK] Downloaded: $caffemodelFile" -ForegroundColor Green
} catch {
    Write-Host "    [ERROR] Failed to download caffemodel" -ForegroundColor Red
    Write-Host "    Error: $_" -ForegroundColor Red
}

# File 3: Cluster Centers (numpy file) - ~7KB
Write-Host ""
Write-Host "3/3 Downloading cluster centers (numpy file)..."
$numpyUrl = "https://raw.githubusercontent.com/richzhang/colorization/caffe/resources/pts_in_hull.npy"
$numpyFile = "pts_in_hull.npy"

try {
    Invoke-WebRequest -Uri $numpyUrl -OutFile $numpyFile -UseBasicParsing
    Write-Host "    [OK] Downloaded: $numpyFile" -ForegroundColor Green
} catch {
    Write-Host "    [ERROR] Failed to download numpy file" -ForegroundColor Red
    Write-Host "    Error: $_" -ForegroundColor Red
}

Set-Location ..

# Verify all files
Write-Host ""
Write-Host "=========================================="
Write-Host "Verifying downloaded files..."
Write-Host "=========================================="

$allFilesPresent = $true

if (Test-Path "$modelsDir\$prototxtFile") {
    $size = (Get-Item "$modelsDir\$prototxtFile").Length / 1KB
    $sizeFormatted = "{0:N2}" -f $size
    Write-Host "[OK] $prototxtFile ($sizeFormatted KB)" -ForegroundColor Green
} else {
    Write-Host "[MISSING] $prototxtFile" -ForegroundColor Red
    $allFilesPresent = $false
}

if (Test-Path "$modelsDir\$caffemodelFile") {
    $size = (Get-Item "$modelsDir\$caffemodelFile").Length / 1MB
    $sizeFormatted = "{0:N2}" -f $size
    Write-Host "[OK] $caffemodelFile ($sizeFormatted MB)" -ForegroundColor Green
} else {
    Write-Host "[MISSING] $caffemodelFile" -ForegroundColor Red
    $allFilesPresent = $false
}

if (Test-Path "$modelsDir\$numpyFile") {
    $size = (Get-Item "$modelsDir\$numpyFile").Length / 1KB
    $sizeFormatted = "{0:N2}" -f $size
    Write-Host "[OK] $numpyFile ($sizeFormatted KB)" -ForegroundColor Green
} else {
    Write-Host "[MISSING] $numpyFile" -ForegroundColor Red
    $allFilesPresent = $false
}

Write-Host ""
if ($allFilesPresent) {
    Write-Host "=========================================="
    Write-Host "[SUCCESS] All model files downloaded!" -ForegroundColor Green
    Write-Host "=========================================="
    Write-Host ""
    Write-Host "You can now run: python app.py"
} else {
    Write-Host "=========================================="
    Write-Host "[ERROR] Some files are missing!" -ForegroundColor Red
    Write-Host "=========================================="
    Write-Host ""
    Write-Host "Try manual download method (see DOWNLOAD_MODELS_GUIDE.md)"
}
