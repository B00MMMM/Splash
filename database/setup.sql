-- Splash Colorization App Database Schema
-- MySQL Database Setup

-- Create database
CREATE DATABASE IF NOT EXISTS splash_colorization;
USE splash_colorization;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Optional: Create colorization history table (for future feature)
CREATE TABLE IF NOT EXISTS colorization_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    colorized_filename VARCHAR(255) NOT NULL,
    upload_path VARCHAR(500) NOT NULL,
    output_path VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Display tables
SHOW TABLES;

-- Display users table structure
DESCRIBE users;

-- Display colorization_history table structure (if created)
DESCRIBE colorization_history;
