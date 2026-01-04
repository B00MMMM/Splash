# 🚀 AWS EC2 DEPLOYMENT GUIDE
# Complete step-by-step instructions for deploying to AWS

## PART 1: AWS ACCOUNT SETUP

### 1.1 Create AWS Account (if you don't have one)
- Go to: https://aws.amazon.com/
- Click "Create an AWS Account"
- Enter email, password, and account name
- Choose "Personal" account type
- Enter credit card (required but won't be charged for free tier)
- Verify phone number
- Choose "Basic Support - Free"

### 1.2 Sign In
- Go to: https://console.aws.amazon.com/
- Enter your credentials

---

## PART 2: LAUNCH EC2 INSTANCE

### 2.1 Navigate to EC2
1. In AWS Console, search for "EC2" in the top search bar
2. Click "EC2" to open EC2 Dashboard

### 2.2 Launch Instance
1. Click orange "Launch Instance" button
2. Configure the following:

**Name and tags:**
```
Name: colorization-app
```

**Application and OS Images (AMI):**
```
- Select: Ubuntu Server 22.04 LTS
- Architecture: 64-bit (x86)
- Look for "Free tier eligible" badge
```

**Instance type:**
```
- Select: t2.micro
- vCPUs: 1
- Memory: 1 GiB
- Free tier eligible: Yes
```

**Key pair (login):**
```
- Click "Create new key pair"
- Key pair name: colorization-key
- Key pair type: RSA
- Private key file format: .pem
- Click "Create key pair"
- IMPORTANT: Save the .pem file - you cannot download it again!
- Remember the location (e.g., Downloads/colorization-key.pem)
```

**Network settings:**
```
Click "Edit" and configure:

☑ Allow SSH traffic from: My IP (or Anywhere for testing)
☑ Allow HTTP traffic from the internet
☑ Allow HTTPS traffic from the internet

Then click "Add security group rule" twice to add:

Rule 1:
- Type: Custom TCP
- Port range: 5000
- Source: 0.0.0.0/0 (Anywhere)
- Description: Flask API

Rule 2:
- Type: Custom TCP
- Port range: 8000
- Source: 0.0.0.0/0 (Anywhere)
- Description: PHP Frontend
```

**Configure storage:**
```
- Size: 20 GiB (free tier allows up to 30 GiB)
- Root volume type: gp3
- Delete on termination: Yes
```

**Advanced details:**
```
- Leave all as default
```

### 2.3 Launch
1. Review your settings
2. Click "Launch Instance" (orange button)
3. Wait for "Success" message
4. Click "View all instances"

### 2.4 Get Instance Details
1. Select your instance (checkbox)
2. Look for "Instance state: running" (may take 1-2 minutes)
3. Copy the "Public IPv4 address" (e.g., 3.101.45.123)
4. Save this IP address - you'll need it!

---

## PART 3: MOBAXTERM SETUP

### 3.1 Download MobaXterm
- Go to: https://mobaxterm.mobatek.net/download.html
- Download "Home Edition (Installer edition)"
- Install on your Windows computer

### 3.2 Fix PEM File Permissions (Windows)
1. Locate your .pem file (e.g., Downloads/colorization-key.pem)
2. Right-click → Properties → Security tab
3. Click "Advanced" → "Disable inheritance"
4. Choose "Remove all inherited permissions"
5. Click "Add" → "Select a principal"
6. Type your Windows username → Check Names → OK
7. Check "Full control" → OK → Apply → OK

### 3.3 Create SSH Session
1. Open MobaXterm
2. Click "Session" button (top left)
3. Select "SSH" icon
4. Configure:
   ```
   Remote host: [Your EC2 Public IP]
   ☑ Specify username: ubuntu
   Port: 22
   ```
5. Click "Advanced SSH settings" tab
6. Check "Use private key"
7. Browse and select your .pem file
8. Click "OK"

### 3.4 Connect
1. Double-click the session in left panel
2. First time: Accept the host key (click "Yes")
3. You should see: `ubuntu@ip-xxx-xxx-xxx-xxx:~$`

**If connection fails:**
- Check your EC2 security group allows port 22
- Verify instance is running in AWS Console
- Check you're using the correct .pem file

---

## PART 4: INSTALL SOFTWARE ON EC2

Copy and paste these commands one by one into MobaXterm:

### 4.1 Update System
```bash
sudo apt update && sudo apt upgrade -y...
```
(Takes 2-5 minutes)

### 4.2 Install Python
```bash
sudo apt install python3 python3-pip python3-venv -y...
```

Verify:
```bash
python3 --version...
```
(Should show: Python 3.10.x or higher)

### 4.3 Install PHP
```bash
sudo apt install php -y...
```

Verify:
```bash
php --version...
```
(Should show: PHP 8.1.x or higher)

### 4.4 Install Additional Tools
```bash
sudo apt install wget curl git -y...
sudo apt install libgl1 libglib2.0-0 libsm6 libxext6 libxrender-dev -y
```

**Note:** Updated for Ubuntu 22.04+ (libgl1 replaces libgl1-mesa-glx)

---

## PART 5: CLONE PROJECT FROM GITHUB

### 5.1 Clone the Repository
```bash
cd ~
git clone https://github.com/B00MMMM/Splash.git
cd Splash
```

### 5.2 Verify Files
```bash
ls -la
```

You should see:
- app.py
- colorizer.py
- config.py
- requirements.txt
- download_model.sh, start.sh, stop.sh
- frontend/ folder
- database/ folder
- models/ folder (empty - will download later)

---

## ALTERNATIVE: Upload Files Manually

### Method A: Using MobaXterm

1. In MobaXterm, look at the left panel
2. You'll see a file browser showing `/home/ubuntu/`
3. Create project directory:
   ```bash
   mkdir ~/Splash
   ```
4. In left panel, navigate to `/home/ubuntu/Splash/`
5. Drag and drop all project files from your computer

### Method B: Manual Copy-Paste (for small files)

For each file:
```bash
nano ~/Splash/filename.py
# Paste content
# Press Ctrl+O to save
# Press Enter to confirm
# Press Ctrl+X to exit
```

---

## PART 6: SETUP PYTHON ENVIRONMENT

### 6.1 Navigate to Project and Create Virtual Environment
```bash
cd ~/Splash
python3 -m venv venv
```

### 6.2 Activate Virtual Environment
```bash
source venv/bin/activate
```

Your prompt should change to: `(venv) ubuntu@...`

### 6.3 Install Python Packages
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

This will take 3-5 minutes. You should see:
```
Successfully installed Flask-3.0.0 opencv-python-4.8.1.78 numpy-1.24.3 Pillow-10.1.0 Werkzeug-3.0.1
```

---

## PART 7: DOWNLOAD AI MODEL

### 7.1 Create Directories
```bash
mkdir -p uploads outputs models
chmod 755 uploads outputs
```

### 7.2 Download Model Files
```bash
chmod +x download_model.sh
bash download_model.sh
```

This downloads ~130MB and takes 2-5 minutes depending on your connection.

Expected output:
```
Downloading OpenCV Pre-trained Colorization Model...
==================================================
1/3 Downloading model architecture (prototxt)...
2/3 Downloading model weights (caffemodel) - ~130MB...
3/3 Downloading cluster centers (numpy file)...

✓ Model files downloaded successfully!
```

### 7.3 Verify Files
```bash
ls -lh models/
```

Should show:
```
total 126M
-rw-r--r-- 1 ubuntu ubuntu 125M ... colorization_release_v2.caffemodel
-rw-r--r-- 1 ubuntu ubuntu 9.1K ... colorization_deploy_v2.prototxt
-rw-r--r-- 1 ubuntu ubuntu 7.0K ... pts_in_hull.npy
```

---

## PART 8: CONFIGURE FRONTEND

### 8.1 Update API URL
Edit the JavaScript file to use your EC2 IP:

```bash
cd ~/Splash
nano frontend/script.js
```

Find line 6:
```javascript
const API_URL = 'http://localhost:5000';
```

Change to (use YOUR EC2 IP):
```javascript
const API_URL = 'http://3.101.45.123:5000';
```

Save and exit:
- Press `Ctrl+O` (save)
- Press `Enter` (confirm)
- Press `Ctrl+X` (exit)

---

## PART 9: RUN THE APPLICATION

### 9.1 Start Flask API

Make sure you're in the project directory with venv activated:
```bash
cd ~/Splash
source venv/bin/activate
python3 app.py
```

You should see:
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

**KEEP THIS TERMINAL OPEN!**

### 9.2 Start PHP Frontend

**Option A: Open new MobaXterm session**
1. In MobaXterm, create a new SSH session (same as before)
2. Connect to your EC2 instance

**Option B: Use screen (in same terminal)**
```bash
# Press Ctrl+Z to suspend Flask
bg
# Or use screen:
screen -S flask
# Start Flask here, then Ctrl+A D to detach
```

In the new terminal:
```bash
cd ~/Splash/frontend
php -S 0.0.0.0:8000
```

You should see:
```
[Sat Jan 04 2026 10:30:00] PHP 8.1.2 Development Server (http://0.0.0.0:8000) started
```

---

## PART 10: TEST THE APPLICATION

### 10.1 Open in Browser
```
http://YOUR-EC2-IP:8000
```

Example: `http://3.101.45.123:8000`

### 10.2 Test Image Upload
1. You should see the colorization interface
2. Click "Choose an image..."
3. Select a black and white image from your computer
4. Click "Colorize Image"
5. Wait 5-10 seconds
6. See the colorized result!
7. Click "Download" to save

### 10.3 If It Doesn't Work

**Check Flask API:**
```bash
# In another terminal
curl http://localhost:5000
```

Should return JSON with "status": "running"

**Check Security Groups:**
1. AWS Console → EC2 → Security Groups
2. Find your instance's security group
3. Verify ports 5000 and 8000 are open

**Check Logs:**
- Look at the terminal running Flask for error messages
- Look at the terminal running PHP for errors

---

## PART 11: RUNNING IN BACKGROUND (PERSISTENT)

To keep the app running after closing MobaXterm:

### 11.1 Stop Current Processes
Press `Ctrl+C` in both terminals

### 11.2 Use Screen

**Start Flask in screen:**
```bash
screen -S flask
cd ~/Splash
source venv/bin/activate
python3 app.py
# Press Ctrl+A then D to detach
```

**Start PHP in screen:**
```bash
screen -S php
cd ~/Splash/frontend
php -S 0.0.0.0:8000
# Press Ctrl+A then D to detach
```

### 11.3 Manage Screens

**List all screens:**
```bash
screen -ls
```

**Reattach to a screen:**
```bash
screen -r flask   # Flask API
screen -r php     # PHP Server
```

**Kill a screen:**
```bash
screen -X -S flask quit
```

---

## PART 12: STOPPING THE APPLICATION

### 12.1 If Using Screen
```bash
# Kill Flask
screen -X -S flask quit

# Kill PHP
screen -X -S php quit
```

### 12.2 If Running in Terminals
Press `Ctrl+C` in each terminal

### 12.3 Stop EC2 Instance (to save costs)
1. AWS Console → EC2 → Instances
2. Select your instance
3. Instance state → Stop instance
4. To restart: Instance state → Start instance

**NOTE:** Stopping instance changes the public IP!
You'll need to update frontend/script.js with the new IP.

---

## PART 13: COST MANAGEMENT

### 13.1 Monitor Usage
- AWS Console → Billing Dashboard
- Check "Free Tier Usage"

### 13.2 Set Billing Alerts
1. AWS Console → Billing → Budgets
2. Create budget
3. Set alert for $5
4. Enter your email

### 13.3 Best Practices
- Stop instance when not using
- Delete old snapshots
- Monitor data transfer
- Use CloudWatch for monitoring

---

## TROUBLESHOOTING CHECKLIST

### Cannot Connect to EC2
- [ ] Instance is running (AWS Console)
- [ ] Security group allows port 22
- [ ] Using correct .pem file
- [ ] .pem file has correct permissions

### Cannot Access Web Application
- [ ] Flask is running (check terminal)
- [ ] PHP is running (check terminal)
- [ ] Security group allows ports 5000, 8000
- [ ] Using correct EC2 public IP
- [ ] Updated script.js with correct IP

### Model Not Loading
- [ ] Model files exist in models/ directory
- [ ] Files are correct size (~130MB for .caffemodel)
- [ ] Virtual environment is activated
- [ ] All Python packages installed

### Image Upload Fails
- [ ] uploads/ directory exists
- [ ] Directory has write permissions
- [ ] File size < 5MB
- [ ] File is valid image format

---

## QUICK REFERENCE COMMANDS

**Connect to EC2:**
```bash
# In MobaXterm, double-click your session
```

**Activate Python environment:**
```bash
cd ~/colorization-app
source venv/bin/activate
```

**Start Flask:**
```bash
python3 app.py
```

**Start PHP:**
```bash
cd frontend
php -S 0.0.0.0:8000
```

**Check running processes:**
```bash
ps aux | grep python
ps aux | grep php
```

**View logs:**
```bash
tail -f /var/log/syslog
```

**Check disk space:**
```bash
df -h
```

**Check memory:**
```bash
free -h
```

---

## GETTING HELP

1. **Check the main README.md** for troubleshooting section
2. **Look at error messages** in the terminal
3. **Check AWS CloudWatch** for system logs
4. **Verify security groups** in AWS Console
5. **Test locally first** before deploying

---

## SUCCESS CHECKLIST

- [ ] AWS account created
- [ ] EC2 instance launched (t2.micro)
- [ ] Security groups configured (22, 5000, 8000)
- [ ] MobaXterm installed and connected
- [ ] Python and PHP installed on EC2
- [ ] Project files uploaded
- [ ] Virtual environment created
- [ ] Python packages installed
- [ ] Model files downloaded
- [ ] Frontend script.js updated with EC2 IP
- [ ] Flask API running
- [ ] PHP server running
- [ ] Application accessible in browser
- [ ] Image colorization working

---

**🎉 Congratulations! Your application is now live on AWS! 🎉**

Remember:
- EC2 Public IP: ________________
- Flask API: http://your-ip:5000
- Frontend: http://your-ip:8000
- Stop instance when not in use to save costs!
