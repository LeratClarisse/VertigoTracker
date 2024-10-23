# Use the official Gitpod VNC workspace image as the base
FROM gitpod/workspace-full-vnc:latest

# Set environment variables
ENV ANDROID_HOME=$HOME/androidsdk \
    FLUTTER_VERSION=3.13.8-stable \
    QTWEBENGINE_DISABLE_SANDBOX=1

# Install dependencies for Flutter and Android
USER root
RUN apt-get update && \
    apt-get install -y \
        curl \
        unzip \
        xz-utils \
        openjdk-8-jdk \
        libglu1-mesa \
        libgtk-3-dev \
        libnss3-dev \
        fonts-noto \
        fonts-noto-cjk && \
    update-java-alternatives --set java-1.8.0-openjdk-amd64

# Install Flutter
RUN curl -o flutter.tar.xz "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz" && \
    tar xf flutter.tar.xz -C /home/gitpod && \
    rm flutter.tar.xz && \
    /home/gitpod/flutter/bin/flutter doctor

# Add Flutter to the PATH
ENV PATH="$HOME/flutter/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Set ownership of the Flutter directory and .config directory to the gitpod user
RUN chown -R gitpod:gitpod /home/gitpod/flutter /home/gitpod/.config

# Enable Flutter web and other configurations
USER gitpod
RUN flutter config --enable-web && \
    flutter precache && \
    for _plat in web linux-desktop; do flutter config --enable-${_plat}; done && \
    flutter config --android-sdk $ANDROID_HOME

# Install Android command line tools
RUN _file_name="commandlinetools-linux-8092744_latest.zip" && \
    wget "https://dl.google.com/android/repository/$_file_name" && \
    unzip "$_file_name" -d $ANDROID_HOME && \
    rm -f "$_file_name" && \
    mkdir -p $ANDROID_HOME/cmdline-tools/latest && \
    mv $ANDROID_HOME/cmdline-tools/{bin,lib} $ANDROID_HOME/cmdline-tools/latest

# Accept Android SDK licenses and install additional SDK components
RUN yes | flutter doctor --android-licenses && \
    yes | sdkmanager "platform-tools" "build-tools;31.0.0" "platforms;android-31"

# Perform additional Flutter setup
RUN flutter doctor

# Set the workspace
WORKDIR /workspace
