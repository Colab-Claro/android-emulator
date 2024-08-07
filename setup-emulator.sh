#!/bin/bash

# Debug output to confirm paths
echo "ANDROID_HOME: $ANDROID_HOME"
echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
echo "ANDROID_AVD_HOME: $ANDROID_AVD_HOME"

# Ensure the AVD home directory exists
mkdir -p /home/mobiledevops/.android/avd

# Start VNC server
vncserver :1 -geometry 1280x800 -depth 24

# Set VNC display
export DISPLAY=:1

# Ensure the emulator directory exists
if [ ! -d "$ANDROID_HOME/emulator" ]; then
    echo "Emulator directory not found!"
    exit 1
fi

# Clean up any existing AVD configurations
echo "Cleaning up existing AVD configurations..."
rm -rf /home/mobiledevops/.android/avd/android30.avd
rm -rf /home/mobiledevops/.android/avd/android30.ini

# Create a new AVD
echo "Creating a new AVD..."
echo no | avdmanager create avd -n android30 -k "system-images;android-30;google_apis;arm64-v8a" --device "pixel" -f

# Verify that the AVD was created successfully
echo "Available AVDs:"
emulator -list-avds

# Start the emulator
echo "Starting the emulator..."
nohup emulator -avd android30 -noaudio -no-boot-anim -gpu off -verbose &

# Wait for the emulator to boot
echo "Waiting for the emulator to boot..."
adb wait-for-device
adb shell input keyevent 82  # Unlock screen
adb shell input keyevent 3   # Home screen

# Run the WhatsApp automation script
sleep 30
./automate-whatsapp.sh