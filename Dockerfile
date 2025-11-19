# Dockerfile for building TibiaAuto with Wine + MSVC
# This provides a reproducible build environment for the legacy VC++ 6.0 project

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win32
ENV WINEPREFIX=/root/.wine

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        wine32 \
        wine64 \
        winetricks \
        wget \
        curl \
        unzip \
        cabextract \
        p7zip-full \
        xvfb \
        && rm -rf /var/lib/apt/lists/*

# Initialize Wine
RUN wine wineboot --init && \
    wineserver -w

# Install Visual C++ 6.0 runtime and MFC components
RUN winetricks -q vcrun6 mfc42 msvcirt

# Install Python 2.4 (required by the project)
# Note: You'll need to provide python-2.4.msi or build without Python support
# RUN wget -O /tmp/python24.msi "URL_TO_PYTHON_2.4_INSTALLER" && \
#     wine msiexec /i /tmp/python24.msi /qn && \
#     rm /tmp/python24.msi

# Set up build environment
WORKDIR /build

# Copy project files
COPY . /build/

# Build script
COPY build.sh /build/
RUN chmod +x /build/build.sh

# Default command
CMD ["/build/build.sh"]
