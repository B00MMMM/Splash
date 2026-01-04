#!/bin/bash

# Stop Script for Image Colorization Application
# Stops both Flask API and PHP development server

echo "=========================================="
echo "Stopping Image Colorization Application"
echo "=========================================="
echo ""

# Check if PID file exists
if [ -f ".app_pids" ]; then
    # Read PIDs
    PIDS=$(cat .app_pids)
    
    echo "Stopping processes: $PIDS"
    
    # Kill processes
    for PID in $PIDS; do
        if ps -p $PID > /dev/null; then
            kill $PID
            echo "✓ Stopped process: $PID"
        else
            echo "Process $PID not running"
        fi
    done
    
    # Remove PID file
    rm .app_pids
    
    echo ""
    echo "✓ Application stopped successfully!"
else
    echo "No running application found (.app_pids not found)"
    echo ""
    echo "Attempting to kill by port..."
    
    # Kill Flask (port 5000)
    FLASK_PID=$(lsof -ti:5000)
    if [ ! -z "$FLASK_PID" ]; then
        kill $FLASK_PID
        echo "✓ Stopped Flask API (PID: $FLASK_PID)"
    fi
    
    # Kill PHP (port 8000)
    PHP_PID=$(lsof -ti:8000)
    if [ ! -z "$PHP_PID" ]; then
        kill $PHP_PID
        echo "✓ Stopped PHP Server (PID: $PHP_PID)"
    fi
fi

echo ""
echo "=========================================="
