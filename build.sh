#!/bin/bash
# Build script for TibiaAuto
# This script builds the project using Wine + MSVC

set -e

echo "TibiaAuto Build Script"
echo "======================"

# Check if Wine is available
if ! command -v wine &> /dev/null; then
    echo "Error: Wine is not installed"
    exit 1
fi

# Set Wine environment
export WINEARCH=win32
export WINEPREFIX=${WINEPREFIX:-$HOME/.wine-tibiaauto}
export WINEDEBUG=-all

# Initialize Wine prefix if needed
if [ ! -d "$WINEPREFIX" ]; then
    echo "Initializing Wine prefix..."
    wineboot -u
    wineserver -w
fi

# Check for MSVC
MSVC_PATH="$WINEPREFIX/drive_c/Program Files/Microsoft Visual Studio/VC98/Bin/CL.EXE"
if [ ! -f "$MSVC_PATH" ]; then
    echo "Error: Visual C++ 6.0 not found in Wine prefix"
    echo "Please install Visual Studio 6.0 first"
    echo ""
    echo "You can install it with:"
    echo "  1. Mount VS6 CD/ISO"
    echo "  2. Run: wine setup.exe"
    echo "  3. Or use a modern alternative like Visual Studio Build Tools"
    exit 1
fi

# Build the project
echo "Building tibiaauto..."

# Navigate to project directory
cd "$(dirname "$0")"

# Option 1: Use nmake (if makefile exists)
if [ -f "tibiaauto.mak" ]; then
    wine "C:\\Program Files\\Microsoft Visual Studio\\VC98\\Bin\\NMAKE.EXE" /f tibiaauto.mak CFG="tibiaauto - Win32 Release"
else
    # Option 2: Use msdev (Visual Studio 6.0 IDE)
    echo "Building with msdev..."
    wine "C:\\Program Files\\Microsoft Visual Studio\\Common\\MSDev98\\Bin\\MSDEV.EXE" tibiaauto.dsw /MAKE "tibiaauto - Win32 Release" /REBUILD
fi

# Check if build succeeded
if [ -f "Release/tibiaauto.exe" ] || [ -f "Debug/tibiaauto2.exe" ]; then
    echo "Build successful!"
    echo "Output files:"
    ls -lh Release/*.exe Debug/*.exe 2>/dev/null || true
else
    echo "Build failed - no executable found"
    exit 1
fi

echo "Done!"
