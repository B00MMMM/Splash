#!/bin/bash

# Start Script for Image Colorization Application
# Starts both Flask API and PHP development server

echo "=========================================="
echo "Starting Image Colorization Application"
echo "=========================================="
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "✗ Virtual environment not found!"
    echo "Please run setup.sh first"
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Check if model files exist
if [ ! -f "models/colorization_release_v2.caffemodel" ]; then
    echo "✗ Model files not found!"
    echo "Please run: bash download_model.sh"
    exit 1
fi

# Start Flask API in background
echo ""
echo "Starting Flask API on port 5000..."
python3 app.py &
FLASK_PID=$!
echo "Flask API PID: $FLASK_PID"

# Wait for Flask to start
sleep 3

# Start PHP development server in background
echo ""
echo "Starting PHP server on port 8000..."
cd frontend
php -S 0.0.0.0:8000 &
PHP_PID=$!
echo "PHP Server PID: $PHP_PID"

cd ..

echo ""
echo "=========================================="
echo "✓ Application started successfully!"
echo "=========================================="
echo ""
echo "Access the application:"
echo "  - Frontend: http://your-ec2-ip:8000"
echo "  - API: http://your-ec2-ip:5000"
echo ""
echo "To stop the application:"
echo "  kill $FLASK_PID $PHP_PID"
echo ""
echo "Saving PIDs to .app_pids..."
echo "$FLASK_PID $PHP_PID" > .app_pids
echo ""
