"""
Flask API Backend for Image Colorization
Simple REST API that receives images and returns colorized versions
"""

from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import os
import uuid
from werkzeug.utils import secure_filename
from colorizer import ImageColorizer
from config import Config

# Initialize Flask application
app = Flask(__name__)

# Enable CORS to allow requests from PHP frontend
CORS(app)

# Initialize directories
Config.init_app()

# Initialize colorizer (load model once at startup)
print("Initializing colorization model...")
colorizer = ImageColorizer()

def allowed_file(filename):
    #check file extension
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in Config.ALLOWED_EXTENSIONS

def generate_unique_filename(original_filename):
    #generate unique filename using uuid4
    ext = original_filename.rsplit('.', 1)[1].lower()
    unique_id = str(uuid.uuid4())
    return f"{unique_id}.{ext}"

@app.route('/', methods=['GET'])
def index():
    # Health check endpoint
    return jsonify({
        'status': 'running',
        'message': 'Image Colorization API is active',
        'model_loaded': colorizer.is_model_loaded()
    })

@app.route('/colorize', methods=['POST'])
def colorize():
   # Colorization endpoint
    try:
        # Step 1: Validate request has file
        if 'image' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No image file provided'
            }), 400
        
        file = request.files['image']
        
        # Step 2: Validate filename exists
        if file.filename == '':
            return jsonify({
                'success': False,
                'error': 'No file selected'
            }), 400
        
        # Step 3: Validate file type
        if not allowed_file(file.filename):
            return jsonify({
                'success': False,
                'error': f'Invalid file type. Allowed: {", ".join(Config.ALLOWED_EXTENSIONS)}'
            }), 400
        
        # Step 4: Generate unique filenames
        input_filename = generate_unique_filename(file.filename)
        output_filename = f"colorized_{input_filename}"
        
        # Step 5: Save uploaded file
        input_path = os.path.join(Config.UPLOAD_FOLDER, input_filename)
        output_path = os.path.join(Config.OUTPUT_FOLDER, output_filename)
        
        file.save(input_path)
        print(f"✓ File uploaded: {input_filename}")
        
        # Step 6: Colorize the image
        success = colorizer.colorize_image(input_path, output_path)
        
        if not success:
            return jsonify({
                'success': False,
                'error': 'Colorization failed'
            }), 500
        
        # Step 7: Return success response
        return jsonify({
            'success': True,
            'message': 'Image colorized successfully',
            'output_filename': output_filename,
            'download_url': f'/download/{output_filename}'
        }), 200
        
    except Exception as e:
        print(f"✗ Error in colorize endpoint: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/download/<filename>', methods=['GET'])
def download(filename):
   # Download endpoint for colorized images
    try:
        # Security: Ensure filename is safe
        safe_filename = secure_filename(filename)
        file_path = os.path.join(Config.OUTPUT_FOLDER, safe_filename)
        
        # Check if file exists
        if not os.path.exists(file_path):
            return jsonify({
                'success': False,
                'error': 'File not found'
            }), 404
        
        # Send file to client
        return send_file(file_path, mimetype='image/jpeg')
        
    except Exception as e:
        print(f"✗ Error in download endpoint: {str(e)}")
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/cleanup', methods=['POST'])
def cleanup():
    # Cleanup endpoint to remove all uploaded and output files
    try:
        # Remove uploaded files
        for filename in os.listdir(Config.UPLOAD_FOLDER):
            if filename != '.gitkeep':
                file_path = os.path.join(Config.UPLOAD_FOLDER, filename)
                os.remove(file_path)
        
        # Remove output files
        for filename in os.listdir(Config.OUTPUT_FOLDER):
            if filename != '.gitkeep':
                file_path = os.path.join(Config.OUTPUT_FOLDER, filename)
                os.remove(file_path)
        
        return jsonify({
            'success': True,
            'message': 'Cleanup completed'
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

if __name__ == '__main__':
    """
    Start the Flask application
    Runs on all interfaces (0.0.0.0) to accept external connections
    """
    print("\n" + "="*50)
    print("Starting Image Colorization API")
    print("="*50)
    print(f"Host: {Config.FLASK_HOST}")
    print(f"Port: {Config.FLASK_PORT}")
    print(f"Model loaded: {colorizer.is_model_loaded()}")
    print("="*50 + "\n")
    
    app.run(
        host=Config.FLASK_HOST,
        port=Config.FLASK_PORT,
        debug=Config.FLASK_DEBUG
    )
