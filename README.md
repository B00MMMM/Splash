# 🎨 Black and White Image Colorization Web Application

**100% Free AWS EC2 Deployment** | **OpenCV Pre-trained Model** | **PHP + Python Flask**

---

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Technology Stack](#technology-stack)
3. [Prerequisites](#prerequisites)
4. [Local Testing (Optional)](#local-testing-optional)
5. [AWS EC2 Deployment](#aws-ec2-deployment)
6. [Usage Guide](#usage-guide)
7. [Project Structure](#project-structure)
8. [How It Works](#how-it-works)
9. [Troubleshooting](#troubleshooting)
10. [Cost Analysis](#cost-analysis)

---

## 🎯 Project Overview

This project transforms black and white images into colorized versions using a **pre-trained OpenCV colorization model**. The application consists of:
- **Python Flask API**: Handles image processing with OpenCV
- **PHP Frontend**: User interface for uploading images
- **AWS EC2**: Free tier hosting

**Key Features:**
- ✅ 100% Free (AWS Free Tier)
- ✅ No GPU required
- ✅ No training needed (pre-trained model)
- ✅ Simple, well-commented code
- ✅ Easy deployment

---

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Frontend** | PHP + HTML + CSS | User interface |
| **Backend** | Python + Flask | API and processing |
| **Image Processing** | OpenCV | Colorization algorithm |
| **Deployment** | AWS EC2 (Ubuntu) | Free hosting |
| **Access** | MobaXterm | SSH connection |

---

## 📦 Prerequisites

### For Local Testing:
- Python 3.8+
- PHP 7.4+
- pip (Python package manager)

### For AWS Deployment:
- AWS Account (Free Tier)
- MobaXterm installed
- SSH key pair (.pem file)

---

## 💻 Local Testing (Optional)

### Step 1: Install Dependencies

**Python packages:**
```bash
pip install -r requirements.txt
```

**PHP:**
- Windows: Install [XAMPP](https://www.apachefriends.org/)
- Linux: `sudo apt install php`
- Mac: `brew install php`

### Step 2: Download Model Files

```bash
bash download_model.sh
```

This downloads (~130MB):
- `colorization_deploy_v2.prototxt` (model architecture)
- `colorization_release_v2.caffemodel` (trained weights)
- `pts_in_hull.npy` (cluster centers)

### Step 3: Start Flask API

```bash
python app.py
```

Expected output:
```
==================================================
Starting Image Colorization API
==================================================
Host: 0.0.0.0
Port: 5000
Model loaded: True
==================================================

 * Running on http://0.0.0.0:5000
```

### Step 4: Start PHP Frontend

Open a new terminal:
```bash
cd frontend
php -S localhost:8000
```

### Step 5: Test Application

Open browser: `http://localhost:8000`

---

## ☁️ AWS EC2 Deployment

### Part A: Launch EC2 Instance

#### 1. Sign in to AWS Console
- Go to [AWS Console](https://console.aws.amazon.com/)
- Navigate to **EC2 Dashboard**

#### 2. Launch Instance

**Click "Launch Instance"** and configure:

| Setting | Value | Notes |
|---------|-------|-------|
| **Name** | `colorization-app` | Any name you prefer |
| **AMI** | Ubuntu Server 22.04 LTS | Free tier eligible |
| **Instance Type** | `t2.micro` | 1 vCPU, 1GB RAM (Free tier) |
| **Key Pair** | Create new or use existing | Download `.pem` file (SAVE THIS!) |
| **Network Settings** | Allow SSH (22), HTTP (80), Custom TCP (5000, 8000) | See security config below |
| **Storage** | 8-30 GB gp3 | Free tier: 30GB |

**Security Group Configuration:**

| Type | Protocol | Port | Source | Purpose |
|------|----------|------|--------|---------|
| SSH | TCP | 22 | My IP | MobaXterm access |
| Custom TCP | TCP | 5000 | 0.0.0.0/0 | Flask API |
| Custom TCP | TCP | 8000 | 0.0.0.0/0 | PHP Frontend |
| HTTP | TCP | 80 | 0.0.0.0/0 | Optional |

#### 3. Launch and Note Details
- Click **"Launch Instance"**
- Wait 2-3 minutes for instance to start
- Copy **Public IPv4 address** (e.g., `3.101.45.123`)

---

### Part B: Connect with MobaXterm

#### 1. Open MobaXterm

#### 2. Create New SSH Session
- Click **"Session"** → **"SSH"**
- **Remote host:** Your EC2 public IP
- **Username:** `ubuntu`
- **Advanced SSH settings:**
  - Check "Use private key"
  - Browse and select your `.pem` file

#### 3. Connect
- Click **OK**
- First connection: Accept host key
- You should see: `ubuntu@ip-xxx-xxx-xxx-xxx:~$`

---

### Part C: Setup Application on EC2

#### 1. Update System

```bash
sudo apt update && sudo apt upgrade -y
```

#### 2. Install Required Software

```bash
# Install Python and pip
sudo apt install python3 python3-pip python3-venv -y

# Install PHP
sudo apt install php -y

# Install wget for downloading models
sudo apt install wget -y

# Install required system libraries for OpenCV
sudo apt install libgl1-mesa-glx libglib2.0-0 -y
```

#### 3. Create Project Directory

```bash
mkdir ~/colorization-app
cd ~/colorization-app
```

#### 4. Upload Project Files

**Option A: Using MobaXterm (Recommended)**
- In MobaXterm left panel, you'll see the file browser
- Navigate to `~/colorization-app`
- Drag and drop these files from your local machine:
  - `app.py`
  - `config.py`
  - `colorizer.py`
  - `requirements.txt`
  - `download_model.sh`
  - `start.sh`
  - `stop.sh`
  - `frontend/` (entire folder)

**Option B: Using Git**
```bash
# If you have the project in GitHub
git clone your-repo-url
cd your-repo-name
```

**Option C: Manual Upload with SCP**
```bash
# From your local machine (Windows PowerShell)
scp -i your-key.pem -r colorization-app/* ubuntu@your-ec2-ip:~/colorization-app/
```

#### 5. Create Virtual Environment

```bash
cd ~/colorization-app
python3 -m venv venv
source venv/bin/activate
```

Your prompt should change to: `(venv) ubuntu@ip-xxx:~/colorization-app$`

#### 6. Install Python Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

This will take 3-5 minutes. You should see:
```
Successfully installed Flask-3.0.0 opencv-python-4.8.1.78 numpy-1.24.3 ...
```

#### 7. Create Necessary Directories

```bash
mkdir -p uploads outputs models
chmod 755 uploads outputs
```

#### 8. Download Pre-trained Model

```bash
chmod +x download_model.sh
bash download_model.sh
```

Expected output:
```
Downloading OpenCV Pre-trained Colorization Model...
==================================================
1/3 Downloading model architecture (prototxt)...
2/3 Downloading model weights (caffemodel) - ~130MB...
3/3 Downloading cluster centers (numpy file)...

✓ Model files downloaded successfully!
```

**Verify model files:**
```bash
ls -lh models/
```

You should see:
```
colorization_deploy_v2.prototxt  (~10KB)
colorization_release_v2.caffemodel  (~130MB)
pts_in_hull.npy  (~7KB)
```

#### 9. Update Frontend Configuration

Edit the API URL in frontend JavaScript:

```bash
nano frontend/script.js
```

Find this line:
```javascript
const API_URL = 'http://localhost:5000';
```

Change to your EC2 public IP:
```javascript
const API_URL = 'http://3.101.45.123:5000';  // Use YOUR EC2 IP
```

Save: `Ctrl+O`, `Enter`, `Ctrl+X`

---

### Part D: Run the Application

#### 1. Start Flask API

```bash
cd ~/colorization-app
source venv/bin/activate
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

#### 2. Start PHP Frontend

Open a **new SSH session** in MobaXterm (or use `screen`/`tmux`):

```bash
cd ~/colorization-app/frontend
php -S 0.0.0.0:8000
```

Expected output:
```
[Sat Jan 04 2026 10:30:00] PHP 8.1.2 Development Server (http://0.0.0.0:8000) started
```

#### 3. Access Application

Open your web browser:
```
http://YOUR-EC2-PUBLIC-IP:8000
```

Example: `http://3.101.45.123:8000`

You should see the colorization web interface! 🎉

---

## 📖 Usage Guide

### Step-by-Step Image Colorization

1. **Open the application** in your browser
2. **Click "Choose an image..."**
3. **Select a black & white image** from your computer
   - Supported formats: JPG, PNG, JPEG, BMP
   - Maximum size: 5MB
4. **Click "Colorize Image"**
5. **Wait for processing** (typically 3-10 seconds)
6. **View results** - Original vs Colorized side-by-side
7. **Click "Download Colorized Image"** to save the result

### Tips for Best Results:
- Use clear, high-contrast B&W images
- Historical photos work great
- Avoid very blurry or low-quality images
- Landscape and portrait photos work well

---

## 📁 Project Structure

```
colorization-app/
├── app.py                  # Flask API (main backend)
├── colorizer.py            # OpenCV colorization logic
├── config.py               # Configuration settings
├── requirements.txt        # Python dependencies
├── download_model.sh       # Script to download model files
├── setup.sh                # Automated setup script
├── start.sh                # Start both services
├── stop.sh                 # Stop both services
├── .gitignore              # Git ignore rules
│
├── frontend/               # PHP Frontend
│   ├── index.php          # Main HTML page
│   ├── script.js          # JavaScript logic
│   └── style.css          # CSS styling
│
├── models/                 # Pre-trained model files
│   ├── colorization_deploy_v2.prototxt
│   ├── colorization_release_v2.caffemodel
│   └── pts_in_hull.npy
│
├── uploads/                # Temporary upload storage
└── outputs/                # Colorized image outputs
```

---

## 🧠 How It Works

### Backend Flow (Python + OpenCV)

```
1. User uploads B&W image
   ↓
2. Flask receives image via POST request
   ↓
3. Save image to uploads/ directory
   ↓
4. Load image with OpenCV
   ↓
5. Convert to Lab color space (L=lightness, a/b=color)
   ↓
6. Extract L channel (grayscale information)
   ↓
7. Pass L channel through neural network
   ↓
8. Network predicts a & b channels (color)
   ↓
9. Combine original L + predicted ab
   ↓
10. Convert back to RGB color space
   ↓
11. Save colorized image to outputs/
   ↓
12. Return download URL to frontend
```

### Frontend Flow (PHP + JavaScript)

```
1. User selects image file
   ↓
2. JavaScript validates file (type, size)
   ↓
3. Create FormData with image
   ↓
4. Send POST request to Flask API
   ↓
5. Show loading spinner
   ↓
6. Receive response with output URL
   ↓
7. Display original and colorized images
   ↓
8. Enable download button
```

### The Colorization Model

**Model:** Zhang et al. (2016) - Colorful Image Colorization
- **Type:** CNN trained on ImageNet
- **Input:** Grayscale (L channel)
- **Output:** Color predictions (ab channels)
- **Framework:** Caffe (via OpenCV DNN)
- **Size:** ~130MB
- **No GPU needed:** Runs on CPU

**Technical Details:**
- Uses Lab color space (perceptually uniform)
- Predicts 313 color bins
- Trained on 1.3M images
- Publication: [arxiv.org/abs/1603.08511](https://arxiv.org/abs/1603.08511)

---

## 🔧 Troubleshooting

### Issue 1: Cannot Connect to EC2

**Symptoms:** MobaXterm connection times out

**Solutions:**
1. Check security group allows port 22 from your IP
2. Verify instance is running (AWS Console)
3. Confirm you're using correct `.pem` file
4. Check your internet connection

### Issue 2: Model Files Not Found

**Symptoms:** Error: "Model files not found"

**Solutions:**
```bash
cd ~/colorization-app
bash download_model.sh

# Verify files exist
ls -lh models/
```

### Issue 3: Flask API Not Running

**Symptoms:** "Network error" in browser

**Solutions:**
1. Check Flask is running:
   ```bash
   ps aux | grep python
   ```
2. Restart Flask:
   ```bash
   cd ~/colorization-app
   source venv/bin/activate
   python3 app.py
   ```
3. Check security group allows port 5000

### Issue 4: Frontend Not Loading

**Symptoms:** Browser shows "Connection refused"

**Solutions:**
1. Check PHP is running:
   ```bash
   ps aux | grep php
   ```
2. Restart PHP:
   ```bash
   cd ~/colorization-app/frontend
   php -S 0.0.0.0:8000
   ```
3. Check security group allows port 8000

### Issue 5: "Module not found" Error

**Symptoms:** ImportError when starting Flask

**Solutions:**
```bash
source venv/bin/activate
pip install -r requirements.txt
```

### Issue 6: Out of Memory

**Symptoms:** Process killed or freezes

**Solutions:**
- t2.micro has only 1GB RAM
- Process smaller images (resize before upload)
- Consider upgrading to t2.small (still free tier eligible)

### Issue 7: Permission Denied

**Symptoms:** Cannot write to uploads/outputs

**Solutions:**
```bash
chmod 755 uploads outputs
chown -R ubuntu:ubuntu ~/colorization-app
```

---

## 💰 Cost Analysis

### AWS Free Tier (First 12 Months)

| Service | Free Tier Limit | This Project Usage | Cost |
|---------|----------------|-------------------|------|
| EC2 t2.micro | 750 hours/month | ~720 hours/month | **$0** |
| EBS Storage | 30 GB | ~15 GB | **$0** |
| Data Transfer Out | 15 GB/month | ~5 GB/month | **$0** |

**Total Monthly Cost: $0** ✅

### After Free Tier (Month 13+)

| Service | Rate | Monthly Estimate |
|---------|------|-----------------|
| EC2 t2.micro | $0.0116/hour | ~$8.35/month |
| EBS Storage | $0.10/GB-month | ~$1.50/month |
| Data Transfer | $0.09/GB | ~$0.45/month |

**Total: ~$10.30/month**

### Cost Optimization Tips:
1. **Stop instance when not in use** (AWS Console → Stop)
2. **Use only during demonstrations**
3. **Delete snapshots regularly**
4. **Monitor AWS billing dashboard**

---

## 🚀 Running in Background (Production)

For persistent operation, use `screen` or `systemd`:

### Using Screen (Simple)

**Start Flask API:**
```bash
screen -S flask
cd ~/colorization-app
source venv/bin/activate
python3 app.py
# Press Ctrl+A then D to detach
```

**Start PHP Server:**
```bash
screen -S php
cd ~/colorization-app/frontend
php -S 0.0.0.0:8000
# Press Ctrl+A then D to detach
```

**Reattach to screens:**
```bash
screen -r flask   # Flask API
screen -r php     # PHP Server
```

**List all screens:**
```bash
screen -ls
```

---

## 📚 Additional Resources

### Documentation:
- [Flask Documentation](https://flask.palletsprojects.com/)
- [OpenCV Python Tutorials](https://docs.opencv.org/4.x/d6/d00/tutorial_py_root.html)
- [AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/)

### Model Paper:
- Zhang et al., "Colorful Image Colorization", ECCV 2016
- [Paper Link](https://arxiv.org/abs/1603.08511)

### MobaXterm:
- [Download MobaXterm](https://mobaxterm.mobatek.net/)
- [MobaXterm Documentation](https://mobaxterm.mobatek.net/documentation.html)

---

## 🎓 Learning Objectives Achieved

✅ **Cloud Deployment:** AWS EC2 setup and configuration  
✅ **Backend Development:** Flask REST API  
✅ **Image Processing:** OpenCV with pre-trained models  
✅ **Frontend Integration:** PHP + JavaScript communication  
✅ **System Integration:** Multiple services working together  
✅ **DevOps Basics:** Deployment, monitoring, troubleshooting  

---

## 📝 Next Steps for Enhancement

1. **Add Apache/Nginx** for production web server
2. **Implement user authentication**
3. **Add image gallery** to store results
4. **Batch processing** for multiple images
5. **Docker containerization**
6. **CI/CD pipeline** with GitHub Actions
7. **Database integration** (SQLite/PostgreSQL)
8. **Image quality comparison** metrics

---

## 🤝 Contributing

This project is designed for educational purposes. Feel free to:
- Report issues
- Suggest improvements
- Fork and modify for your needs

---

## 📄 License

This project uses:
- OpenCV (Apache 2.0 License)
- Flask (BSD License)
- Pre-trained model by Zhang et al. (research use)

Free to use for educational and non-commercial purposes.

---

## 💡 Tips for Success

1. **Read error messages carefully** - they tell you what's wrong
2. **Check logs** - use `tail -f` to monitor real-time logs
3. **Test locally first** - easier to debug
4. **Keep EC2 instance updated** - security patches
5. **Monitor AWS costs** - set billing alerts
6. **Backup your .pem file** - you'll need it!
7. **Document changes** - keep notes of modifications

---

## ✨ Credits

**Colorization Model:**
- Richard Zhang, Phillip Isola, Alexei A. Efros
- Berkeley AI Research (BAIR) Laboratory

**Project Structure:**
- Designed for cloud engineering education
- Focus on practical deployment skills

---

**Happy Colorizing! 🎨✨**

For questions or issues, refer to the troubleshooting section or check the logs.
