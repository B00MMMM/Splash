<?php
require_once 'config/session.php';

// Require user to be logged in
requireLogin();

// Get current user info
$user = getCurrentUser();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Colorize Your Photos - Splash</title>
    <link rel="stylesheet" href="colorize-style.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="welcome.html" class="logo">
                <img src="assets/logo.png" alt="Splash Logo" width="40" height="40">
                <span class="brand-name">Splash</span>
            </a>
            <div class="nav-right">
                <span class="user-name">Welcome, <?php echo htmlspecialchars($user['name']); ?></span>
                <div class="user-menu">
                    <button class="user-avatar">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                    </button>
                    <div class="dropdown-menu">
                        <a href="index.php">Colorize</a>
                        <a href="logout.php">Sign Out</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Main Content -->
        <main>
            <!-- Upload Section -->
            <div class="upload-section">
                <div class="upload-box" id="uploadBox">
                    <div class="upload-icon">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                            <polyline points="17 8 12 3 7 8"></polyline>
                            <line x1="12" y1="3" x2="12" y2="15"></line>
                        </svg>
                    </div>
                    <h3>Upload Your Image</h3>
                    <p>Click to browse or drag and drop your black and white photo</p>
                    <p class="file-info">Supports: JPG, PNG, WEBP (Max 10MB)</p>
                    
                    <form id="uploadForm" method="POST" enctype="multipart/form-data">
                        <input 
                            type="file" 
                            id="imageInput" 
                            name="image" 
                            accept="image/*" 
                            required
                            hidden
                        >
                    </form>
                    
                    <button type="button" class="btn-upload" id="uploadBtn">
                        Browse Files
                    </button>
                </div>
            </div>

            <!-- Loading Indicator -->
            <div id="loading" class="loading" style="display: none;">
                <div class="spinner"></div>
                <p>Processing your image...</p>
            </div>

            <!-- Error Message -->
            <div id="errorMsg" class="error-message" style="display: none;"></div>

            <!-- Results Section -->
            <div id="results" class="results" style="display: none;">
                <button onclick="resetUpload()" class="btn-reset-top">
                    Colorize Another Image
                </button>
                <h2>Results</h2>
                <div class="image-comparison">
                    <!-- Original Image -->
                    <div class="image-box">
                        <h3>Original Image</h3>
                        <img id="originalImage" src="" alt="Original">
                    </div>
                    
                    <!-- Colorized Image -->
                    <div class="image-box">
                        <h3>Colorized Image</h3>
                        <img id="colorizedImage" src="" alt="Colorized">
                    </div>
                </div>
                
                <!-- Download Button -->
                <button onclick="downloadImage()" class="btn-download">
                    Download Colorized Image
                </button>
                
                <!-- Back Button (hidden by default) -->
                <button id="backBtn" onclick="backToResults()" class="btn-back" style="display: none;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M19 12H5M12 19l-7-7 7-7"/>
                    </svg>
                    Back to Results
                </button>
            </div>
        </main>
    </div>

    <!-- Backdrop for zoomed images -->
    <div id="backdrop" class="backdrop" style="display: none;" onclick="backToResults()"></div>

    <script src="script.js"></script>
</body>
</html>
