# Database Setup Instructions

## Prerequisites
- MySQL Server installed (v5.7 or higher)
- PHP with MySQLi extension enabled

## Setup Steps

### Option 1: Automatic Setup (Recommended)
The database will be created automatically when you first access any page:
1. Just access `login.php` or `register.php`
2. The `database.php` file will automatically create the database and tables

### Option 2: Manual Setup
If you prefer manual setup or encounter issues:

1. **Start MySQL Server**
   ```bash
   # Windows (if using XAMPP)
   Start MySQL from XAMPP Control Panel
   
   # Or via command line
   net start MySQL
   ```

2. **Run the SQL Setup Script**
   ```bash
   mysql -u root -p < database/setup.sql
   ```
   
   Or import via phpMyAdmin:
   - Open phpMyAdmin (http://localhost/phpmyadmin)
   - Click "Import" tab
   - Choose `database/setup.sql`
   - Click "Go"

3. **Verify Database Creation**
   ```sql
   USE splash_colorization;
   SHOW TABLES;
   ```

## Database Configuration

Edit `frontend/config/database.php` if you need to change credentials:

```php
define('DB_HOST', 'localhost');    // Database host
define('DB_USER', 'root');         // Database username
define('DB_PASS', '');             // Database password
define('DB_NAME', 'splash_colorization'); // Database name
```

## Database Schema

### Users Table
- **id**: Primary key (auto-increment)
- **full_name**: User's full name (VARCHAR 100)
- **email**: User's email (VARCHAR 100, UNIQUE)
- **password**: Hashed password (VARCHAR 255)
- **created_at**: Account creation timestamp
- **last_login**: Last login timestamp (nullable)

### Colorization History Table (Optional)
Tracks user's colorization history for future features:
- **id**: Primary key
- **user_id**: Foreign key to users table
- **original_filename**: Original image filename
- **colorized_filename**: Colorized image filename
- **upload_path**: Path to uploaded image
- **output_path**: Path to colorized image
- **created_at**: Timestamp

## Troubleshooting

### "Connection failed" Error
- Verify MySQL server is running
- Check database credentials in `config/database.php`
- Ensure MySQLi PHP extension is enabled

### "Table already exists" Error
- Normal if re-running setup
- Can safely ignore or drop database first:
  ```sql
  DROP DATABASE IF EXISTS splash_colorization;
  ```

### Permission Issues
- Ensure MySQL user has CREATE, INSERT, SELECT, UPDATE privileges
- Grant permissions if needed:
  ```sql
  GRANT ALL PRIVILEGES ON splash_colorization.* TO 'root'@'localhost';
  FLUSH PRIVILEGES;
  ```

## Security Notes

**Important for Production:**
1. Change default MySQL root password
2. Create dedicated database user with limited privileges
3. Use environment variables for sensitive credentials
4. Enable SSL for database connections
5. Regularly backup the database

## Testing the Setup

1. Register a new user at `register.php`
2. Login at `login.php`
3. Should redirect to `index.php` if successful
4. Check MySQL:
   ```sql
   SELECT * FROM users;
   ```
