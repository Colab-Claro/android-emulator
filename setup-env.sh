#!/bin/bash

# Update package lists
sudo apt update

# Install dependencies
sudo apt install -y wget curl unzip openjdk-17-jdk

# Install Node.js and npm using NodeSource PPA
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify Node.js and npm installation
node -v
npm -v

# Install Appium globally
npm install -g appium

# Verify Appium installation
appium -v

# Install Appium Inspector
APP_IMAGE_URL="https://github.com/appium/appium-inspector/releases/latest/download/Appium-Inspector-linux.AppImage"
APP_IMAGE_PATH="$HOME/Downloads/Appium-Inspector-linux.AppImage"

wget -O "$APP_IMAGE_PATH" "$APP_IMAGE_URL"
chmod a+x "$APP_IMAGE_PATH"

echo "Appium Inspector downloaded to $APP_IMAGE_PATH"
echo "You can run it using: $APP_IMAGE_PATH"

# Install Android Emulator
sudo apt install -y google-android-emulator-installer

# Verify Android Emulator installation
emulator -version
