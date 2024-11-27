#!/bin/bash

# Update and Upgrade System
echo "Updating and upgrading system packages..."
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y

# Install Apache2
echo "Installing Apache2..."
sudo apt install apache2 -y

# Install MySQL Server without user input
echo "Installing MySQL Server..."
sudo apt install mysql-server -y

# Secure MySQL and set root password (non-interactive)
echo "Configuring MySQL root password..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'ntf12345';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install PHP 8.3 and required modules
echo "Adding PHP repository..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y

echo "Installing PHP 8.3 and necessary extensions..."
sudo apt install php8.3 php8.3-cli php8.3-fpm php8.3-mysql php8.3-mbstring php8.3-xml php8.3-curl php8.3-zip -y

echo "Installing PHP and Apache2 modules..."
sudo apt install php libapache2-mod-php php-mysql -y

# Set PHP ownership for web directory
echo "Setting ownership for /var/www/html directory..."
sudo chown -R $USER:$USER /var/www/html

# Install wget, curl, unzip for phpMyAdmin
echo "Installing wget, curl, and unzip..."
sudo apt install wget curl unzip -y

# Download phpMyAdmin and unzip it
echo "Downloading phpMyAdmin..."
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip

echo "Unzipping and moving phpMyAdmin..."
unzip phpMyAdmin-5.2.1-all-languages.zip
mv phpMyAdmin-5.2.1-all-languages /var/www/html/padmin

# Restart Apache to apply changes
echo "Restarting Apache2..."
sudo systemctl restart apache2

# Configure PHP settings to increase limits
echo "Configuring PHP settings..."
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/8.3/apache2/php.ini
sudo sed -i 's/max_input_time = 60/max_input_time = 300/' /etc/php/8.3/apache2/php.ini
sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/8.3/apache2/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /etc/php/8.3/apache2/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 1024M/' /etc/php/8.3/apache2/php.ini

# Configure Apache to allow .htaccess overrides
echo "Configuring Apache2 to allow .htaccess overrides..."
sudo sed -i '/<Directory \/var\/www\/html>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Restart Apache to apply changes
echo "Restarting Apache2..."
sudo systemctl restart apache2

# Install Composer non-interactively
echo "Installing Composer..."
sudo apt install curl php-cli php-mbstring unzip -y
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Verify Composer installation
echo "Composer installed successfully, checking version..."
composer --version

# Install curl if not already installed
echo "Installing curl..."
sudo apt install curl -y

# Install NVM (Node Version Manager)
echo "Installing NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# Load nvm (required for the current shell session)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Install Node.js version 22 using NVM
echo "Installing Node.js version 22 using NVM..."
nvm install 22

# Verify Node.js installation
echo "Verifying Node.js installation..."
node -v # Should print v22.x.x

# Verify npm installation
echo "Verifying npm installation..."
npm -v # Should print npm version 10.x.x

# Install MongoDB 7.0
echo "Installing MongoDB 7.0..."

# Import MongoDB public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Add MongoDB repository
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | \
   sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update package database
sudo apt update

# Install MongoDB server
sudo apt install mongodb-org -y

# Verify MongoDB installation
echo "Verifying MongoDB installation..."
mongod --version

# Start MongoDB service
echo "Starting MongoDB service..."
sudo systemctl start mongod

# Enable MongoDB service to start on boot
echo "Enabling MongoDB to start on boot..."
sudo systemctl enable mongod

# Verify MongoDB service status
echo "Verifying MongoDB service status..."
sudo systemctl status mongod

# Start MongoDB shell
echo "Starting MongoDB shell..."
mongosh

# Install Snap if not already installed
echo "Installing Snap package manager..."
sudo apt install snapd -y

# Install Slack via Snap
echo "Installing Slack via Snap..."
sudo snap install slack --classic

# Install IPTux via Snap
echo "Installing IPTux via Snap..."
sudo snap install iptux

# Install FileZilla via Snap
echo "Installing FileZilla via Snap..."
sudo snap install filezilla

# Install OpenJDK 17 and JRE
echo "Installing OpenJDK 17 and JRE..."
sudo apt install openjdk-17-jdk openjdk-17-jre -y

# Verify the installation of OpenJDK 17
echo "Verifying OpenJDK 17 installation..."
java -version
javac -version

# Change the default editor in FileZilla
echo "Changing the default code editor in FileZilla..."

# Define the desired code editor (for example, VSCode)
EDITOR_PATH="/usr/bin/code"  # Path to your desired code editor (VSCode in this case)

# Check if FileZilla's configuration directory exists
if [ ! -d "$HOME/.config/filezilla" ]; then
  echo "FileZilla configuration directory not found! FileZilla might not be installed."
  exit 1
fi

# Check if filezilla.xml exists
FILEZILLA_CONFIG="$HOME/.config/filezilla/filezilla.xml"
if [ ! -f "$FILEZILLA_CONFIG" ]; then
  echo "FileZilla configuration file (filezilla.xml) not found!"
  exit 1
fi

# Use sed to modify the XML configuration and change the editor path
echo "Changing the default code editor in FileZilla to $EDITOR_PATH..."

# We are updating the Editor path in filezilla.xml (non-interactive edit using sed)
sed -i "s|<EditorPath>.*</EditorPath>|<EditorPath>$EDITOR_PATH</EditorPath>|" "$FILEZILLA_CONFIG"

# Verify the change
if grep -q "<EditorPath>$EDITOR_PATH</EditorPath>" "$FILEZILLA_CONFIG"; then
  echo "Editor changed successfully to $EDITOR_PATH."
else
  echo "Failed to change the editor in FileZilla."
  exit 1
fi

# Final message
echo "Installation complete!"
echo "LAMP stack (Apache, MySQL, PHP) and phpMyAdmin have been installed."
echo "Node.js version 22, npm, and MongoDB 7.0 have been installed."
echo "MongoDB service is running and enabled to start on boot."
echo "Snap packages (Slack, IPTux, FileZilla) have been installed."
echo "OpenJDK 17 and JRE have been installed."
echo "FileZilla's default editor has been changed to $EDITOR_PATH."
