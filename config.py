# Configuration file for the colorization application
import os

class Config:
    """
    Application configuration class
    Simple and readable configuration for all components
    """
    
    # Base directory
    BASE_DIR = os.path.abspath(os.path.dirname(__file__))
    
    # Flask settings
    FLASK_HOST = '0.0.0.0'  # Allow external connections
    FLASK_PORT = 5000
    FLASK_DEBUG = False  # Set to False in production
    
    # Upload settings
    UPLOAD_FOLDER = os.path.join(BASE_DIR, 'uploads')
    OUTPUT_FOLDER = os.path.join(BASE_DIR, 'outputs')
    ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'bmp'}
    MAX_FILE_SIZE = 5 * 1024 * 1024  # 5MB limit
    
    # Model paths (pre-trained OpenCV colorization model)
    MODEL_DIR = os.path.join(BASE_DIR, 'models')
    PROTOTXT_PATH = os.path.join(MODEL_DIR, 'colorization_deploy_v2.prototxt')
    CAFFEMODEL_PATH = os.path.join(MODEL_DIR, 'colorization_release_v2.caffemodel')
    KERNEL_PATH = os.path.join(MODEL_DIR, 'pts_in_hull.npy')
    
    # PHP frontend settings
    PHP_HOST = 'localhost'
    PHP_PORT = 8000
    
    @staticmethod
    def init_app():
        """Create necessary directories if they don't exist"""
        os.makedirs(Config.UPLOAD_FOLDER, exist_ok=True)
        os.makedirs(Config.OUTPUT_FOLDER, exist_ok=True)
        os.makedirs(Config.MODEL_DIR, exist_ok=True)
        print(f"✓ Directories initialized")
