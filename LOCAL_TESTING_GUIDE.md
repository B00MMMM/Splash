# 🧪 LOCAL TESTING GUIDE
# Test the application on your local machine before deploying to AWS

---

## WINDOWS TESTING

### Prerequisites

1. **Python 3.8+**
   - Download from: https://www.python.org/downloads/
   - During installation, check "Add Python to PATH"
   - Verify: Open PowerShell and run `python --version`

2. **PHP**
   - Option A: Install XAMPP (https://www.apachefriends.org/)
   - Option B: Install PHP standalone (https://windows.php.net/download/)
   - Verify: `php --version` in PowerShell

### Step 1: Navigate to Project

```powershell
cd C:\Project\Splash\colorization-app
```

### Step 2: Create Virtual Environment

```powershell
python -m venv venv
```

### Step 3: Activate Virtual Environment

```powershell
.\venv\Scripts\activate
```

Your prompt should change to: `(venv) PS C:\...>`

### Step 4: Install Dependencies

```powershell
pip install --upgrade pip
pip install -r requirements.txt
```

Wait 3-5 minutes for installation.

### Step 5: Create Directories

```powershell
New-Item -ItemType Directory -Path uploads, outputs, models -Force
```

### Step 6: Download Model Files

**Option A: Using Git Bash (if you have Git installed)**
```bash
bash download_model.sh
```

**Option B: Manual Download**

Create a PowerShell script `download_model.ps1`:

```powershell
# download_model.ps1
New-Item -ItemType Directory -Path models -Force
cd models

Write-Host "Downloading model files..."

# Download prototxt
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/richzhang/colorization/master/colorization/models/colorization_deploy_v2.prototxt" -OutFile "colorization_deploy_v2.prototxt"

# Download caffemodel (~130MB)
Invoke-WebRequest -Uri "https://www.dropbox.com/s/dx0qvhhp5hbcx7z/colorization_release_v2.caffemodel?dl=1" -OutFile "colorization_release_v2.caffemodel"

# Download numpy file
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/richzhang/colorization/master/colorization/resources/pts_in_hull.npy" -OutFile "pts_in_hull.npy"

cd ..
Write-Host "✓ Download complete!"
```

Run it:
```powershell
.\download_model.ps1
```

### Step 7: Start Flask API

```powershell
python app.py
```

Expected output:
```
Loading colorization model...
✓ Model loaded successfully

==================================================
Starting Image Colorization API
==================================================
Host: 0.0.0.0
Port: 5000
Model loaded: True
==================================================

 * Running on http://0.0.0.0:5000
```

**Keep this PowerShell window open!**

### Step 8: Start PHP Server

Open a **NEW PowerShell window**:

```powershell
cd C:\Project\Splash\colorization-app\frontend
php -S localhost:8000
```

Expected output:
```
[Sat Jan 04 2026 10:30:00] PHP 8.1.2 Development Server (http://localhost:8000) started
```

### Step 9: Test Application

Open your browser and go to:
```
http://localhost:8000
```

Test by uploading a black and white image!

### Step 10: Stop Application

**Stop Flask:**
- Go to Flask PowerShell window
- Press `Ctrl+C`

**Stop PHP:**
- Go to PHP PowerShell window
- Press `Ctrl+C`

---

## LINUX/MAC TESTING

### Prerequisites

**Linux:**
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv php wget -y
```

**Mac:**
```bash
brew install python php wget
```

### Step 1: Navigate to Project

```bash
cd /path/to/colorization-app
```

### Step 2: Create Virtual Environment

```bash
python3 -m venv venv
```

### Step 3: Activate Virtual Environment

```bash
source venv/bin/activate
```

Your prompt should change to: `(venv) user@machine:...`

### Step 4: Install Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Step 5: Create Directories

```bash
mkdir -p uploads outputs models
chmod 755 uploads outputs
```

### Step 6: Download Model Files

```bash
chmod +x download_model.sh
bash download_model.sh
```

### Step 7: Start Flask API

```bash
python3 app.py
```

Expected output:
```
Loading colorization model...
✓ Model loaded successfully

==================================================
Starting Image Colorization API
==================================================
Host: 0.0.0.0
Port: 5000
Model loaded: True
==================================================

 * Running on http://0.0.0.0:5000
```

**Keep this terminal open!**

### Step 8: Start PHP Server

Open a **NEW terminal window**:

```bash
cd /path/to/colorization-app/frontend
php -S localhost:8000
```

### Step 9: Test Application

Open browser:
```
http://localhost:8000
```

### Step 10: Stop Application

Press `Ctrl+C` in both terminals.

---

## TESTING CHECKLIST

### Basic Functionality Tests

- [ ] Flask API starts without errors
- [ ] PHP server starts without errors
- [ ] Can access http://localhost:8000 in browser
- [ ] Page loads correctly (no missing CSS/JS)
- [ ] Can click "Choose an image..." button
- [ ] Can select an image file
- [ ] "Colorize Image" button is clickable
- [ ] Loading spinner appears during processing
- [ ] Colorized image appears after processing
- [ ] Download button works

### API Testing (Optional)

Test Flask API directly using PowerShell/curl:

**Health check:**
```powershell
# PowerShell
Invoke-RestMethod -Uri http://localhost:5000/

# Linux/Mac
curl http://localhost:5000/
```

Expected response:
```json
{
  "status": "running",
  "message": "Image Colorization API is active",
  "model_loaded": true
}
```

**Test colorization:**
```powershell
# PowerShell
$form = @{
    image = Get-Item -Path "test_image.jpg"
}
Invoke-RestMethod -Uri http://localhost:5000/colorize -Method Post -Form $form

# Linux/Mac
curl -X POST -F "image=@test_image.jpg" http://localhost:5000/colorize
```

### Error Testing

Test error handling:

- [ ] Upload file > 5MB (should show error)
- [ ] Upload non-image file (should show error)
- [ ] Upload without selecting file (should show error)
- [ ] Stop Flask API and try upload (should show network error)

---

## COMMON ISSUES & SOLUTIONS

### Issue 1: "Python not found"

**Windows:**
```powershell
# Check if Python is installed
python --version

# If not found, reinstall Python and check "Add to PATH"
```

**Linux/Mac:**
```bash
# Use python3 instead
python3 --version
```

### Issue 2: "Module not found" errors

```powershell
# Make sure virtual environment is activated
# You should see (venv) in your prompt

# Reinstall packages
pip install -r requirements.txt
```

### Issue 3: "Port already in use"

**Flask (port 5000):**
```powershell
# Windows - find and kill process
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:5000 | xargs kill
```

**PHP (port 8000):**
```powershell
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:8000 | xargs kill
```

### Issue 4: Model files not downloading

**Manual download links:**

1. **colorization_deploy_v2.prototxt** (~10KB)
   - https://raw.githubusercontent.com/richzhang/colorization/master/colorization/models/colorization_deploy_v2.prototxt
   - Save to: `models/colorization_deploy_v2.prototxt`

2. **colorization_release_v2.caffemodel** (~130MB)
   - https://www.dropbox.com/s/dx0qvhhp5hbcx7z/colorization_release_v2.caffemodel?dl=1
   - Save to: `models/colorization_release_v2.caffemodel`

3. **pts_in_hull.npy** (~7KB)
   - https://raw.githubusercontent.com/richzhang/colorization/master/colorization/resources/pts_in_hull.npy
   - Save to: `models/pts_in_hull.npy`

### Issue 5: OpenCV import error

**Windows:**
```powershell
pip uninstall opencv-python
pip install opencv-python==4.8.1.78
```

If still failing, install Visual C++ Redistributable:
- https://aka.ms/vs/17/release/vc_redist.x64.exe

**Linux:**
```bash
sudo apt install libgl1-mesa-glx libglib2.0-0
pip install opencv-python==4.8.1.78
```

### Issue 6: Permission denied (Linux/Mac)

```bash
chmod +x download_model.sh
chmod 755 uploads outputs
```

---

## TESTING WITH SAMPLE IMAGES

### Where to Find Test Images

1. **Historical photos** (public domain):
   - Library of Congress: https://www.loc.gov/
   - Unsplash (historical): https://unsplash.com/s/photos/black-and-white

2. **Convert color image to B&W:**
   - Open any color image in Paint/GIMP
   - Desaturate/Convert to grayscale
   - Save and test

### Good Test Cases

- ✅ Portrait photos
- ✅ Landscape photos
- ✅ Historical photos
- ✅ High contrast images
- ✅ Medium resolution (500x500 to 2000x2000)

### Poor Test Cases

- ❌ Very low resolution (<100x100)
- ❌ Very high resolution (>5000x5000)
- ❌ Very blurry images
- ❌ Extreme close-ups
- ❌ Abstract images

---

## PERFORMANCE BENCHMARKS

Expected processing times (t2.micro equivalent: 1 CPU, 1GB RAM):

| Image Size | Resolution | Processing Time |
|------------|------------|----------------|
| Small | 500x500 | 2-3 seconds |
| Medium | 1000x1000 | 4-6 seconds |
| Large | 2000x2000 | 8-12 seconds |
| Very Large | 3000x3000 | 15-25 seconds |

**Note:** First colorization may be slower due to model initialization.

---

## DEBUGGING TIPS

### Enable Debug Mode

Edit `config.py`:
```python
FLASK_DEBUG = True  # Change from False to True
```

This will:
- Show detailed error messages
- Auto-reload on code changes
- Provide stack traces

**Remember:** Set back to `False` for production!

### Check Logs

**Flask logs:**
- Visible in the terminal running `python app.py`
- Look for ✓ or ✗ symbols

**Browser console:**
- Open browser DevTools (F12)
- Check "Console" tab for JavaScript errors
- Check "Network" tab for API call details

### Test Step by Step

1. **Test Flask alone:**
   ```
   http://localhost:5000/
   ```
   Should return JSON status

2. **Test PHP alone:**
   ```
   http://localhost:8000/
   ```
   Should show the webpage

3. **Test file upload:**
   - Check browser Network tab
   - Look for POST to `/colorize`
   - Check response

---

## NEXT STEPS

After successful local testing:

1. ✅ Verified code works locally
2. ✅ Understood the flow
3. ✅ Ready for AWS deployment

**Proceed to:** [AWS_DEPLOYMENT_GUIDE.md](AWS_DEPLOYMENT_GUIDE.md)

---

## QUICK START REFERENCE

**Windows:**
```powershell
# Terminal 1
cd C:\Project\Splash\colorization-app
.\venv\Scripts\activate
python app.py

# Terminal 2
cd C:\Project\Splash\colorization-app\frontend
php -S localhost:8000

# Browser
http://localhost:8000
```

**Linux/Mac:**
```bash
# Terminal 1
cd /path/to/colorization-app
source venv/bin/activate
python3 app.py

# Terminal 2
cd /path/to/colorization-app/frontend
php -S localhost:8000

# Browser
http://localhost:8000
```

---

**Happy Local Testing! 🧪**
