#!/bin/bash
set -e

echo "TibiaAuto Docker Build Script"
echo "=============================="

# Check if MSBuild is installed
MSBUILD_PATH="$WINEPREFIX/drive_c/Program Files/MSBuild/14.0/Bin/MSBuild.exe"

if [ ! -f "$MSBUILD_PATH" ]; then
    echo ""
    echo "ERROR: MSBuild not found at: $MSBUILD_PATH"
    echo ""
    echo "You need to install Visual Studio Build Tools 2015/2017 first:"
    echo "1. Download Build Tools: https://aka.ms/vs/15/release/vs_buildtools.exe"
    echo "2. Mount it to the container: -v /path/to/vs_buildtools.exe:/tmp/vs_buildtools.exe"
    echo "3. Run: wine /tmp/vs_buildtools.exe"
    echo "4. Select: Visual C++ build tools"
    echo ""
    echo "OR use the interactive setup:"
    echo "docker run -it -v \$(pwd):/build tibiaauto-build bash"
    echo ""
    exit 1
fi

echo "MSBuild found!"
echo "Building TibiaAuto..."
echo ""

# Change to build directory
cd /build

# Clean previous builds
echo "Cleaning previous builds..."
find . -name "*.obj" -delete
find . -name "*.pch" -delete

# Build solution
echo "Starting build with MSBuild..."
wine "$MSBUILD_PATH" tibiaauto.sln \
    /p:Configuration=Release \
    /p:Platform=Win32 \
    /p:PlatformToolset=v140 \
    /m \
    /v:minimal

echo ""
echo "Build complete!"
echo "Output files:"
find . -name "*.exe" -o -name "*.dll" | grep -E "(Release|Debug)" | grep -v "/obj/"
