# 🚀 Quick Start Guide - Splash Colorization App

## ✅ Complete Features Implemented

1. **Landing Page** (`welcome.html`) - Beautiful welcome page with features showcase
2. **User Registration** (`register.php`) - Create new accounts with validation
3. **User Login** (`login.php`) - Secure authentication with sessions
4. **Protected Colorize Page** (`index.php`) - Only accessible when logged in
5. **MySQL Database** - User credentials stored securely
6. **Session Management** - Users stay logged in across pages
7. **Modern UI Design** - Matching your design specifications

## 📋 Prerequisites

- PHP 7.4+ with MySQLi extension
- MySQL 5.7+ or MariaDB
- Web server (Apache/Nginx) or PHP built-in server

## 🎬 Getting Started (5 Minutes)

### Step 1: Start MySQL Server
```bash
# Windows (XAMPP)
Start MySQL from XAMPP Control Panel

# Or command line
net start MySQL
```

### Step 2: Navigate to Frontend Folder
```bash
cd c:\Project\Splash\colorization-app\frontend
```

### Step 3: Start PHP Server
```bash
php -S localhost:8000
```

### Step 4: Open Browser
Visit: **http://localhost:8000/welcome.html**

### Step 5: Test the Flow

1. **Click "Try It Out Now"** or **"Create Free Account"**
2. **Register** a new account:
   - Enter your name: `John Doe`
   - Enter email: `john@example.com`
   - Create password: `password123`
   - Confirm password: `password123`
   - Check "I agree to terms"
   - Click **"Create Account"**
3. **Login** with your credentials:
   - Email: `john@example.com`
   - Password: `password123`
   - Click **"Sign In"**
4. **You're now on the colorize page!**
   - Upload a black & white image
   - Watch it colorize
   - Download the result

## 🎯 Application Flow

```
welcome.html (Public)
    ↓
[Try It Out Now] or [Create Account]
    ↓
register.php (Public) ──→ Create Account
    ↓
login.php (Public) ──→ Enter Credentials
    ↓
Session Created ✓
    ↓
index.php (Protected) ──→ Upload & Colorize Images
    ↓
[Sign Out] → Destroys Session
```

## 🔐 Authentication System

### User Registration
- **Validates**: Email format, password length (min 6), password match
- **Hashes**: Password using bcrypt
- **Stores**: In MySQL `users` table
- **Redirects**: To login page after success

### User Login
- **Verifies**: Email and password against database
- **Creates**: PHP session with user data
- **Updates**: Last login timestamp
- **Redirects**: To colorize page (index.php)

### Protected Routes
- **index.php**: Requires login, redirects to login.php if not authenticated
- **welcome.html**: Public, no authentication needed
- **login.php**: Public, redirects to index.php if already logged in
- **register.php**: Public, redirects to index.php if already logged in

## 📁 Key Files Explained

### Configuration
- **`config/database.php`** - MySQL connection & database initialization
- **`config/session.php`** - Session management functions

### Pages
- **`welcome.html`** - Landing page (no PHP, static)
- **`login.php`** - Login form with authentication logic
- **`register.php`** - Registration form with validation
- **`index.php`** - Main colorize interface (protected)
- **`logout.php`** - Destroys session and redirects

### Styles
- **`welcome-style.css`** - Landing page styling
- **`auth-style.css`** - Login/register page styling
- **`colorize-style.css`** - Main app styling

### Scripts
- **`script.js`** - Frontend logic (drag-drop, API calls)

## 🗄️ Database

**Auto-created on first run!**

### Tables
1. **users**
   - id (Primary Key)
   - full_name
   - email (Unique)
   - password (Hashed)
   - created_at
   - last_login

### Manual Setup (Optional)
```bash
mysql -u root -p < database/setup.sql
```

## 🎨 Design Features

### Landing Page
- ✅ Hero section with CTA
- ✅ Features showcase (Upload, Crop, Download)
- ✅ How It Works (4 steps)
- ✅ Footer with columns & social links
- ✅ Your color scheme (pastel blues/greens)

### Login/Register Pages
- ✅ Centered card design
- ✅ Password visibility toggle
- ✅ Social login buttons (UI)
- ✅ Form validation
- ✅ Error/success messages
- ✅ Responsive design

### Colorize Page
- ✅ Navigation with user avatar
- ✅ Dropdown menu (Colorize, Sign Out)
- ✅ Drag & drop upload
- ✅ File type/size validation
- ✅ Loading indicator
- ✅ Before/After comparison
- ✅ Download button

## 🔧 Configuration

### Change Database Credentials
Edit `frontend/config/database.php`:
```php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', 'your_password');
define('DB_NAME', 'splash_colorization');
```

### Change Flask API URL
Edit `frontend/script.js`:
```javascript
const API_URL = 'http://localhost:5000';
// Change to: 'http://your-ec2-ip:5000'
```

## 🚀 Running with Flask Backend

### Terminal 1: Start Flask API
```bash
cd c:\Project\Splash\colorization-app
python app.py
```

### Terminal 2: Start PHP Server
```bash
cd frontend
php -S localhost:8000
```

### Access
- Frontend: http://localhost:8000/welcome.html
- API: http://localhost:5000

## 📱 Testing Checklist

- [ ] Can access landing page
- [ ] Can create new account
- [ ] Can login with credentials
- [ ] Redirects to colorize page after login
- [ ] Cannot access colorize page without login
- [ ] Can upload and colorize image
- [ ] Can download colorized image
- [ ] Can sign out
- [ ] After sign out, redirects to login
- [ ] Cannot access index.php when logged out

## 🐛 Troubleshooting

### "Connection failed"
- ✅ Check MySQL is running
- ✅ Verify credentials in `config/database.php`
- ✅ Ensure MySQLi extension enabled

### "Cannot access index.php"
- ✅ Must be logged in first
- ✅ Create account and login
- ✅ Check session is working

### "Email already registered"
- ✅ Use different email
- ✅ Or login with existing account

### Images not colorizing
- ✅ Ensure Flask API is running
- ✅ Check `API_URL` in script.js
- ✅ Verify model files exist

## 📞 Support Resources

- **Authentication Guide**: `AUTHENTICATION_GUIDE.md`
- **Database Setup**: `database/README.md`
- **Flask Setup**: `QUICKSTART.md`

## 🎉 You're Ready!

Your complete application with authentication is now set up!

**Flow**: Landing → Register → Login → Colorize → Download → Logout

All pages are styled, responsive, and secure! 🚀
