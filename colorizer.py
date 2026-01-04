import cv2
import numpy as np
import os
from config import Config

class ImageColorizer:
    """
    Handles image colorization using pre-trained OpenCV model
    Uses the Zhang et al. colorization algorithm
    """
    
    def __init__(self):
        # Initialize model variables
        self.net = None
        self.pts_in_hull = None
        self.load_model()
    
    def load_model(self):
        # Load the pre-trained colorization model from disk
        #model trained on ImageNet dataset
        try:
            # Load the model architecture (prototxt) and weights (caffemodel)
            print("Loading colorization model...")
            self.net = cv2.dnn.readNetFromCaffe(
                Config.PROTOTXT_PATH,
                Config.CAFFEMODEL_PATH
            )
            
            # Load cluster centers for ab channels
            # These are used to convert network output to color
            self.pts_in_hull = np.load(Config.KERNEL_PATH)
            
            # Add cluster centers as 1x1 convolution kernel
            class8 = self.net.getLayerId("class8_ab")
            conv8 = self.net.getLayerId("conv8_313_rh")
            self.pts_in_hull = self.pts_in_hull.transpose().reshape(2, 313, 1, 1)
            self.net.getLayer(class8).blobs = [self.pts_in_hull.astype("float32")]
            self.net.getLayer(conv8).blobs = [np.full([1, 313], 2.606, dtype="float32")]
            
            print("✓ Model loaded successfully")
            
        except Exception as e:
            print(f"✗ Error loading model: {str(e)}")
            raise
    
    def colorize_image(self, input_path, output_path):
        # Colorize the input grayscale image and save the output
        try:
            print(f"Processing image: {input_path}")
            
            # Step 1: Read the input image
            image = cv2.imread(input_path)
            if image is None:
                print("✗ Failed to read image")
                return False
            
            # Step 2: Convert image from BGR to RGB
            # OpenCV uses BGR by default, but we need RGB
            image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
            
            # Step 3: Normalize and convert to Lab color space
            # Lab color space separates luminance (L) from color (a,b)
            # L = lightness, a = green-red, b = blue-yellow
            scaled = image_rgb.astype("float32") / 255.0
            lab = cv2.cvtColor(scaled, cv2.COLOR_RGB2LAB)
            
            # Step 4: Resize Lab image for the network
            # The model expects 224x224 input
            resized = cv2.resize(lab, (224, 224))
            
            # Step 5: Extract L channel (lightness)
            # This is what the network uses as input
            L = cv2.split(resized)[0]
            L -= 50  # Mean centering (preprocessing step)
            
            # Step 6: Pass L channel through the neural network
            # Network predicts the a and b channels (color information)
            self.net.setInput(cv2.dnn.blobFromImage(L))
            ab = self.net.forward()[0, :, :, :].transpose((1, 2, 0))
            
            # Step 7: Resize predicted ab channels to match original image size
            ab = cv2.resize(ab, (image.shape[1], image.shape[0]))
            
            # Step 8: Extract original L channel (full resolution)
            L = cv2.split(lab)[0]
            
            # Step 9: Combine original L with predicted ab channels
            # This creates the final colorized Lab image
            colorized = np.concatenate((L[:, :, np.newaxis], ab), axis=2)
            
            # Step 10: Convert back from Lab to RGB
            colorized = cv2.cvtColor(colorized, cv2.COLOR_LAB2RGB)
            colorized = np.clip(colorized, 0, 1)  # Ensure values are in valid range
            
            # Step 11: Convert to 8-bit image and save
            colorized = (255 * colorized).astype("uint8")
            colorized_bgr = cv2.cvtColor(colorized, cv2.COLOR_RGB2BGR)
            cv2.imwrite(output_path, colorized_bgr)
            
            print(f"✓ Image colorized successfully: {output_path}")
            return True
            
        except Exception as e:
            print(f"✗ Error during colorization: {str(e)}")
            return False
    
    def is_model_loaded(self):
        #check if model is loaded
        return self.net is not None and self.pts_in_hull is not None
