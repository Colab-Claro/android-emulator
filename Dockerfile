# Use the Android SDK base image
FROM mobiledevops/android-sdk-image:latest

# Install required packages (adjust based on your needs)
RUN apt-get update && \
    apt-get install -y wget unzip libqt5gui5 libqt5webkit5 libqt5x11extras5 libgl1-mesa-dri libglu1-mesa \
    xfce4 xfce4-goodies tightvncserver locales expect curl qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Install Appium globally using npm
RUN npm install -g appium

# Set environment variables for Android SDK and locales
ENV ANDROID_AVD_HOME=/root/.android/avd/
ENV PATH=$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/cmdline-tools/bin/bin
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV USER=root

# Create a working directory
WORKDIR /workspace

# Install Android SDK packages
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/bin && \
    ln -s ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin ${ANDROID_SDK_ROOT}/cmdline-tools/bin && \
    yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \
    sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "platforms;android-30" "system-images;android-30;google_apis;x86_64" "emulator" && \
    sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --update

# Copy the setup and automation scripts
COPY setup-emulator.sh /workspace/setup-emulator.sh
COPY automate-whatsapp.sh /workspace/automate-whatsapp.sh

# Make scripts executable
RUN chmod +x /workspace/setup-emulator.sh /workspace/automate-whatsapp.sh

# Set up the VNC server (consider using environment variables for password)
RUN mkdir -p ~/.vnc && \
    echo "mypassword" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Expose ports for VNC and ADB
EXPOSE 5901 5554 5555

# Start VNC server and then run the setup script
ENTRYPOINT ["/bin/bash", "-c", "tightvncserver :1 -geometry 1280x800 -depth 24 && /workspace/setup-emulator.sh"]