# Download Pre-trained Model Script
# Downloads the OpenCV colorization model files

echo "Downloading OpenCV Pre-trained Colorization Model..."
echo "=================================================="

# Create models directory
mkdir -p models
cd models

# Download prototxt (model architecture)
echo "1/3 Downloading model architecture (prototxt)..."
wget -q --show-progress https://raw.githubusercontent.com/richzhang/colorization/master/colorization/models/colorization_deploy_v2.prototxt

# Download caffemodel (trained weights)
echo "2/3 Downloading model weights (caffemodel) - ~130MB..."
wget -q --show-progress https://www.dropbox.com/s/dx0qvhhp5hbcx7z/colorization_release_v2.caffemodel?dl=1 -O colorization_release_v2.caffemodel

# Download cluster centers
echo "3/3 Downloading cluster centers (numpy file)..."
wget -q --show-progress https://raw.githubusercontent.com/richzhang/colorization/master/colorization/resources/pts_in_hull.npy

cd ..

echo ""
echo "✓ Model files downloaded successfully!"
echo "=================================================="
echo "Files saved in ./models/ directory:"
echo "  - colorization_deploy_v2.prototxt"
echo "  - colorization_release_v2.caffemodel"
echo "  - pts_in_hull.npy"
echo "=================================================="
