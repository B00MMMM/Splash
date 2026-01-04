#!/bin/bash

# Setup Script for Image Colorization Application
# Run this script on AWS EC2 Ubuntu instance

echo "=========================================="
echo "Image Colorization App - Setup Script"
echo "=========================================="
echo ""

# Update system packages
echo "Step 1: Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Python 3 and pip
echo ""
echo "Step 2: Installing Python 3 and pip..."
sudo apt install python3 python3-pip python3-venv -y

# Install PHP and Apache
echo ""
echo "Step 3: Installing PHP and Apache..."
sudo apt install apache2 php libapache2-mod-php -y

# Install wget for downloading models
echo ""
echo "Step 4: Installing wget..."
sudo apt install wget -y

# Create project directory
echo ""
echo "Step 5: Setting up project directory..."
mkdir -p ~/colorization-app
cd ~/colorization-app

# Create virtual environment
echo ""
echo "Step 6: Creating Python virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo ""
echo "Step 7: Activating virtual environment..."
source venv/bin/activate

# Install Python dependencies
echo ""
echo "Step 8: Installing Python dependencies..."
# Note: requirements.txt should be uploaded separately
pip install --upgrade pip
pip install Flask==3.0.0 opencv-python==4.8.1.78 numpy==1.24.3 Pillow==10.1.0 Werkzeug==3.0.1

# Create necessary directories
echo ""
echo "Step 9: Creating application directories..."
mkdir -p uploads outputs models frontend

# Create .gitkeep files
touch uploads/.gitkeep
touch outputs/.gitkeep

# Set permissions
echo ""
echo "Step 10: Setting permissions..."
chmod 755 uploads outputs

# Download model files
echo ""
echo "Step 11: Ready to download model files..."
echo "Run: bash download_model.sh"

echo ""
echo "=========================================="
echo "✓ Setup completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Upload application files to ~/colorization-app/"
echo "2. Run: bash download_model.sh"
echo "3. Start Flask API: python3 app.py"
echo "4. Configure Apache for PHP frontend"
echo ""
