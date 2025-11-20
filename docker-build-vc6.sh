#!/bin/bash
set -e

echo "========================================="
echo "TibiaAuto 7.41 Docker Build Script (VC6)"
echo "========================================="
echo ""

# Check if MSDEV or VC6 is installed
MSDEV_PATH="$WINEPREFIX/drive_c/Program Files/Microsoft Visual Studio/Common/MSDev98/Bin/MSDEV.EXE"

if [ ! -f "$MSDEV_PATH" ]; then
    echo "ERROR: Visual C++ 6.0 not found!"
    echo ""
    echo "This project requires Visual C++ 6.0 (released 1998)."
    echo ""
    echo "To install VC6 in Wine:"
    echo "1. Download Visual C++ 6.0 installer"
    echo "2. Mount it to container: -v /path/to/vc6setup.exe:/tmp/vc6setup.exe"
    echo "3. Run: wine /tmp/vc6setup.exe"
    echo ""
    echo "OR use pre-compiled binaries:"
    echo "  - Debug/tibiaauto2.exe (469 KB) - already compiled!"
    echo "  - tibiaautoinject.dll"
    echo "  - tibiaautoinject2.dll"
    echo ""
    echo "To use pre-compiled binaries, just copy them to your Tibia directory."
    echo ""
    exit 1
fi

echo "Visual C++ 6.0 found!"
echo "Building TibiaAuto for Tibia 7.41..."
echo ""

# Change to build directory
cd /build

# Clean previous builds
echo "Cleaning previous builds..."
find . -name "*.obj" -delete
find . -name "*.pch" -delete
find . -name "*.idb" -delete
find . -name "*.pdb" -delete

# Build using MSDEV command line
echo "Building workspace: tibiaauto.dsw"
echo ""

wine "$MSDEV_PATH" tibiaauto.dsw /MAKE "ALL - Win32 Release" /REBUILD

echo ""
echo "========================================="
echo "Build complete!"
echo "========================================="
echo ""
echo "Output files:"
find . \( -name "*.exe" -o -name "*.dll" \) -newer /tmp/build_start 2>/dev/null | head -20

echo ""
echo "Main executable: Debug/tibiaauto.exe or Release/tibiaauto.exe"
