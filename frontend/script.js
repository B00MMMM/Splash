/**
 * JavaScript for Image Colorization Frontend
 * Handles form submission, drag-and-drop, API communication, and UI updates
 */

// Configuration - Update this with your Flask API URL
const API_URL = 'http://localhost:5000';  // Change to EC2 public IP in production

// Global variable to store download URL
let downloadUrl = '';

/**
 * Initialize event listeners when page loads
 */
document.addEventListener('DOMContentLoaded', function() {
    const fileInput = document.getElementById('imageInput');
    const uploadBox = document.getElementById('uploadBox');
    const uploadForm = document.getElementById('uploadForm');
    const uploadBtn = document.getElementById('uploadBtn');
    
    // File input change handler - auto-submit when file selected
    fileInput.addEventListener('change', function(e) {
        if (e.target.files && e.target.files[0]) {
            const file = e.target.files[0];
            // Automatically process the file
            handleFileSelect(file);
            // Auto-submit the form
            setTimeout(() => {
                handleSubmit(e);
            }, 100);
        }
    });
    
    // Upload button click handler
    if (uploadBtn) {
        uploadBtn.addEventListener('click', function() {
            fileInput.click();
        });
    }
    
    // Drag and drop handlers
    if (uploadBox) {
        uploadBox.addEventListener('dragover', handleDragOver);
        uploadBox.addEventListener('dragleave', handleDragLeave);
        uploadBox.addEventListener('drop', handleDrop);
        
        // Click handler for the box itself
        uploadBox.addEventListener('click', function(e) {
            // Only trigger if clicking the box, not the button
            if (e.target === uploadBox || uploadBox.contains(e.target)) {
                if (!e.target.classList.contains('btn-upload')) {
                    fileInput.click();
                }
            }
        });
    }
    
    // Add click handlers for image zoom with back button
    setupImageZoom();
});

/**
 * Handle drag over event
 */
function handleDragOver(e) {
    e.preventDefault();
    e.stopPropagation();
    this.classList.add('dragover');
}

/**
 * Handle drag leave event
 */
function handleDragLeave(e) {
    e.preventDefault();
    e.stopPropagation();
    this.classList.remove('dragover');
}

/**
 * Handle file drop event
 */
function handleDrop(e) {
    e.preventDefault();
    e.stopPropagation();
    this.classList.remove('dragover');
    
    const files = e.dataTransfer.files;
    if (files && files[0]) {
        const file = files[0];
        const fileInput = document.getElementById('imageInput');
        
        // Set file to input
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(file);
        fileInput.files = dataTransfer.files;
        
        // Process and auto-submit
        if (handleFileSelect(file)) {
            setTimeout(() => {
                handleSubmit(e);
            }, 100);
        }
    }
}

/**
 * Handle file selection
 */
function handleFileSelect(file) {
    const uploadBox = document.getElementById('uploadBox');
    
    // Validate file type
    if (!file.type.startsWith('image/')) {
        showError('Please select a valid image file');
        return false;
    }
    
    // Validate file size (10MB limit)
    const maxSize = 10 * 1024 * 1024;
    if (file.size > maxSize) {
        showError('File size must be less than 10MB');
        return false;
    }
    
    // Update UI to show file selected
    uploadBox.classList.add('has-file');
    uploadBox.querySelector('h3').textContent = file.name;
    uploadBox.querySelector('p').textContent = 'Processing...';
    
    return true;
}

/**
 * Handle form submission
 * Sends image to Flask API and displays results
 */
async function handleSubmit(e) {
    e.preventDefault();  // Prevent default form submission
    
    // Get form elements
    const fileInput = document.getElementById('imageInput');
    const loadingDiv = document.getElementById('loading');
    const resultsDiv = document.getElementById('results');
    const errorMsg = document.getElementById('errorMsg');
    const uploadBox = document.getElementById('uploadBox');
    const uploadBtn = uploadBox ? uploadBox.querySelector('.btn-upload') : null;
    
    // Validate file selection
    if (!fileInput.files || fileInput.files.length === 0) {
        showError('Please select an image file');
        return;
    }
    
    const file = fileInput.files[0];
    
    // Validate file size (10MB limit)
    const maxSize = 10 * 1024 * 1024;  // 10MB in bytes
    if (file.size > maxSize) {
        showError('File size must be less than 10MB');
        return;
    }
    
    // Validate file type
    if (!file.type.startsWith('image/')) {
        showError('Please select a valid image file');
        return;
    }
    
    try {
        // Show loading indicator
        if (loadingDiv) loadingDiv.style.display = 'block';
        if (resultsDiv) resultsDiv.style.display = 'none';
        if (errorMsg) errorMsg.style.display = 'none';
        if (uploadBox) uploadBox.style.display = 'none';
        if (uploadBtn) uploadBtn.disabled = true;
        
        // Create FormData object
        const formData = new FormData();
        formData.append('image', file);
        
        // Send request to Flask API
        const response = await fetch(`${API_URL}/colorize`, {
            method: 'POST',
            body: formData
        });
        
        // Parse JSON response
        const data = await response.json();
        
        // Hide loading indicator
        if (loadingDiv) loadingDiv.style.display = 'none';
        if (uploadBtn) uploadBtn.disabled = false;
        
        // Check if colorization was successful
        if (data.success) {
            // Display original image
            const originalImage = document.getElementById('originalImage');
            originalImage.src = URL.createObjectURL(file);
            
            // Display colorized image
            const colorizedImage = document.getElementById('colorizedImage');
            colorizedImage.src = `${API_URL}${data.download_url}`;
            
            // Store download URL
            downloadUrl = `${API_URL}${data.download_url}`;
            
            // Show results section
            resultsDiv.style.display = 'block';
            
            console.log('✓ Colorization successful');
        } else {
            // Show error message
            showError(data.error || 'Colorization failed. Please try again.');
        }
        
    } catch (error) {
        // Handle network or other errors
        console.error('Error:', error);
        if (loadingDiv) loadingDiv.style.display = 'none';
        if (uploadBox) uploadBox.style.display = 'block';
        if (uploadBtn) uploadBtn.disabled = false;
        showError('Network error. Please check if the Flask API is running.');
    }
}

/**
 * Display error message to user
 */
function showError(message) {
    if (errorMsg) {
        const errorMsg = document.getElementById('errorMsg');
    errorMsg.textContent = message;
        errorMsg.style.display = 'block';
        
        // Auto-hide error after 5 seconds
        setTimeout(() => {
            errorMsg.style.display = 'none';
        }, 5000);
    } else {
        // Fallback to alert if error div doesn't exist
        alert(message);
    }
}

/**
 * Download colorized image
 */
async function downloadImage() {
    if (downloadUrl) {
        try {
            // Fetch the image as a blob to force download
            const response = await fetch(downloadUrl);
            const blob = await response.blob();
            
            // Create object URL from blob
            const blobUrl = URL.createObjectURL(blob);
            
            // Create temporary link and trigger download
            const link = document.createElement('a');
            link.href = blobUrl;
            link.download = 'colorized_image.jpg';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            
            // Clean up the object URL
            setTimeout(() => URL.revokeObjectURL(blobUrl), 100);
            
            console.log('✓ Download initiated');
        } catch (error) {
            console.error('Download error:', error);
            showError('Failed to download image. Please try again.');
        }
    }
}

/**
 * Reset the upload form to colorize another image
 */
function resetUpload() {
    // Reset file input
    const fileInput = document.getElementById('imageInput');
    if (fileInput) {
        fileInput.value = '';
    }
    
    // Hide results section
    const resultsDiv = document.getElementById('results');
    if (resultsDiv) {
        resultsDiv.style.display = 'none';
    }
    
    // Show upload box
    const uploadBox = document.getElementById('uploadBox');
    if (uploadBox) {
        uploadBox.style.display = 'block';
        uploadBox.classList.remove('has-file');
        uploadBox.querySelector('h3').textContent = 'Upload Your Image';
        uploadBox.querySelector('p').textContent = 'Click to browse or drag and drop your black and white photo';
    }
    
    // Clear download URL
    downloadUrl = '';
    
    // Hide any error messages
    const errorMsg = document.getElementById('errorMsg');
    if (errorMsg) {
        errorMsg.style.display = 'none';
    }
    
    console.log('✓ Reset complete - ready for new upload');
}

/**
 * Back to results view from zoomed image
 */
function backToResults() {
    const backBtn = document.getElementById('backBtn');
    const backdrop = document.getElementById('backdrop');
    
    if (backBtn) {
        backBtn.style.display = 'none';
    }
    
    if (backdrop) {
        backdrop.style.display = 'none';
    }
    
    // Zoom out images if they were zoomed
    const images = document.querySelectorAll('.image-box img');
    images.forEach(img => {
        img.classList.remove('zoomed');
    });
    
    // Action buttons are always visible, no need to toggle
    
    // Show comparison view again
    const imageComparison = document.querySelector('.image-comparison');
    if (imageComparison) {
        imageComparison.style.display = 'grid';
    }
}

/**
 * Setup image zoom functionality
 */
function setupImageZoom() {
    // This will be called after images are loaded
    document.addEventListener('click', function(e) {
        if (e.target.matches('.image-box img')) {
            const img = e.target;
            const backBtn = document.getElementById('backBtn');
            const backdrop = document.getElementById('backdrop');
            const imageComparison = document.querySelector('.image-comparison');
            
            if (!img.classList.contains('zoomed')) {
                // Zoom in
                img.classList.add('zoomed');
                if (backBtn) backBtn.style.display = 'flex';
                if (backdrop) backdrop.style.display = 'block';
                if (imageComparison) imageComparison.style.display = 'block';
            } else {
                // Zoom out
                backToResults();
            }
        }
    });
}

//Check API health status
async function checkApiHealth() {
    try {
        const response = await fetch(`${API_URL}/`);
        const data = await response.json();
        console.log('API Status:', data);
        return data.model_loaded;
    } catch (error) {
        console.error('API not reachable:', error);
        return false;
    }
}

// Check API health on page load
window.addEventListener('load', function() {
    checkApiHealth().then(isReady => {
        if (!isReady) {
            console.warn('⚠ Model may not be loaded properly');
        }
    });
});
