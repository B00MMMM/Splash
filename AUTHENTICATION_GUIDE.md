# Authentication System - Complete Guide

## 🎯 Overview

Complete user authentication system with:
- ✅ User registration with password hashing
- ✅ Secure login with session management
- ✅ Protected routes (must be logged in to colorize)
- ✅ MySQL database integration
- ✅ Remember me functionality
- ✅ Password visibility toggle
- ✅ Social login buttons (UI only - can integrate later)

## 📁 File Structure

```
colorization-app/
├── frontend/
│   ├── config/
│   │   ├── database.php       # MySQL connection & initialization
│   │   └── session.php         # Session management functions
│   ├── assets/
│   │   └── logo.png           # Your logo
│   ├── welcome.html            # Landing page (no auth required)
│   ├── login.php              # Login page
│   ├── register.php           # Registration page
│   ├── index.php              # Main colorize page (PROTECTED)
│   ├── logout.php             # Logout handler
│   ├── auth-style.css         # Authentication pages styling
│   ├── colorize-style.css     # Main app styling
│   ├── script.js              # Frontend JavaScript
│   └── ...
├── database/
│   ├── setup.sql              # Database schema
│   └── README.md              # Database setup guide
└── ...
```

## 🚀 Setup Instructions

### 1. Database Setup

**Option A: Automatic (Recommended)**
- Just open `login.php` in your browser
- Database and tables create automatically

**Option B: Manual**
```bash
mysql -u root -p < database/setup.sql
```

### 2. Configure Database Credentials

Edit `frontend/config/database.php` if needed:
```php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');  // Your MySQL password
define('DB_NAME', 'splash_colorization');
```

### 3. Start PHP Development Server

```bash
cd frontend
php -S localhost:8000
```

### 4. Access the Application

- Landing page: http://localhost:8000/welcome.html
- Login: http://localhost:8000/login.php
- Register: http://localhost:8000/register.php
- Colorize (protected): http://localhost:8000/index.php

## 🔐 How Authentication Works

### Registration Flow

1. **User visits** `register.php`
2. **Fills form**: Full name, email, password, confirm password
3. **Checks "agree to terms"** checkbox
4. **Submits form**:
   - Validates all fields
   - Checks email format
   - Verifies password length (min 6 chars)
   - Checks password match
   - Hashes password using `password_hash()`
   - Inserts into MySQL `users` table
5. **Redirects** to `login.php` after 2 seconds

### Login Flow

1. **User visits** `login.php`
2. **Enters** email and password
3. **Submits form**:
   - Queries database for email
   - Verifies password using `password_verify()`
   - Updates `last_login` timestamp
   - Creates session with user data
   - Redirects to `index.php`

### Session Management

**Session Variables Set on Login:**
```php
$_SESSION['user_id']     // User's database ID
$_SESSION['user_name']   // User's full name
$_SESSION['user_email']  // User's email
$_SESSION['login_time']  // Login timestamp
```

**Session Functions (in `config/session.php`):**
- `isLoggedIn()` - Check if user is authenticated
- `requireLogin()` - Redirect to login if not authenticated
- `getCurrentUser()` - Get current user info
- `loginUser()` - Set session variables
- `logoutUser()` - Destroy session

### Protected Routes

**index.php** (main colorize page):
```php
<?php
require_once 'config/session.php';
requireLogin();  // ← Redirects to login.php if not logged in
?>
```

## 🎨 User Interface Features

### Login Page
- Email and password fields
- Password visibility toggle (eye icon)
- "Remember me" checkbox
- "Forgot password?" link
- "Create Account" link
- Social login buttons (Google, Facebook)
- "Back to Home" link

### Registration Page
- Full name field
- Email field
- Password field with toggle
- Confirm password field with toggle
- Terms of Service checkbox
- Social signup buttons
- "Already have an account? Sign In" link
- "Back to Home" link

### Main App (index.php)
- Navigation bar with user name
- User avatar dropdown menu:
  - Colorize
  - Sign Out
- Protected upload interface
- Drag and drop support
- Modern, clean design

## 🔒 Security Features

### Password Security
- **Hashing**: Uses `password_hash()` with bcrypt
- **Verification**: Uses `password_verify()`
- **Never stored plain text**
- **Salted automatically**

### SQL Injection Prevention
- **Prepared statements** for all queries
- **Parameter binding** with `bind_param()`
- **No direct string concatenation**

### Session Security
- Session started securely
- Session variables validated
- Logout properly destroys session

### Input Validation
- Email format validation
- Password length requirements
- XSS prevention with `htmlspecialchars()`
- File type validation
- File size limits

## 📊 Database Schema

### Users Table
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);
```

## 🛠️ Customization

### Change Session Timeout
Edit `config/session.php`:
```php
// Add session timeout (example: 30 minutes)
if (isset($_SESSION['login_time']) && 
    (time() - $_SESSION['login_time'] > 1800)) {
    logoutUser();
}
```

### Add Email Verification
1. Add `email_verified` column to users table
2. Generate verification token
3. Send email with verification link
4. Create verification handler

### Add Password Reset
1. Create `password_reset` table with tokens
2. Create reset request form
3. Send reset email
4. Create password reset form

### Add Profile Page
Create `profile.php`:
```php
<?php
require_once 'config/session.php';
requireLogin();
$user = getCurrentUser();
// Display and edit user info
?>
```

## 🐛 Troubleshooting

### "Connection failed" Error
- Check MySQL is running
- Verify database credentials
- Ensure MySQLi extension is enabled in PHP

### Session Not Working
- Check `session_start()` is called before any output
- Verify cookies are enabled in browser
- Check PHP session settings

### Redirect Loop
- Clear browser cookies
- Check for multiple `header()` calls
- Verify `requireLogin()` logic

### Can't Login
- Verify password was hashed during registration
- Check email is correct in database
- Look for errors in browser console

## 📱 Mobile Responsive
All pages are fully responsive:
- Adapts to mobile, tablet, desktop
- Touch-friendly buttons
- Readable text sizes
- Proper spacing

## 🎯 Next Steps / Future Enhancements

1. **Email Verification** - Verify email addresses
2. **Password Reset** - Forgot password functionality
3. **Profile Management** - Edit user details
4. **OAuth Integration** - Real Google/Facebook login
5. **Two-Factor Authentication** - Extra security layer
6. **User Dashboard** - View colorization history
7. **Settings Page** - User preferences
8. **Admin Panel** - Manage users

## 📞 Support

For issues or questions:
1. Check database connection
2. Verify PHP and MySQL versions
3. Check error logs
4. Review configuration files

---

**Your authentication system is now complete and secure!** 🎉

Users must register/login to access the colorization feature. Sessions are managed securely, and passwords are properly hashed.
