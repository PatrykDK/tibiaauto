# TibiaAuto Build Instructions

This document explains how to build TibiaAuto from source.

## Overview

TibiaAuto is a legacy Windows application built with:
- **Microsoft Visual C++ 6.0** (1998)
- **Microsoft Foundation Classes (MFC)**
- **Python 2.4** integration
- **Xerces C++ XML Parser**

## Current Compiled Binaries

The repository includes pre-compiled binaries at commit `0076a9f`:

```
Debug/tibiaauto2.exe      - Main application (469 KB)
tibiaauto.exe             - Copy of main application
tibiaautoinject.dll       - Injection library (24 KB)
tibiaautoinject2.dll      - Injection library v2 (68 KB)
xerces-c_2_7.dll          - XML parser library (2.3 MB)
```

## Build Options

### Option 1: Windows with Visual Studio 6.0 (Recommended)

**Requirements:**
- Windows XP/Vista/7 (or Windows 10 with compatibility mode)
- Visual Studio 6.0 with Service Pack 6
- Python 2.4 installed to `E:\Python24\` (or update paths in .dsp files)
- Xerces C++ 2.7 library

**Steps:**
1. Open `tibiaauto.dsw` in Visual Studio 6.0
2. Select Build Configuration (Debug or Release)
3. Build -> Rebuild All
4. Output will be in `Debug/` or `Release/` folder

### Option 2: Wine + Visual C++ 6.0 (Linux/Mac)

**Requirements:**
- Wine (32-bit support)
- Visual C++ 6.0 installed in Wine
- Python 2.4 for Windows

**Steps:**
1. Install Wine with 32-bit support:
   ```bash
   sudo apt-get install wine32 winetricks
   ```

2. Create Wine prefix:
   ```bash
   export WINEARCH=win32
   export WINEPREFIX=$HOME/.wine-tibiaauto
   wineboot -u
   ```

3. Install VC++ 6.0 runtime components:
   ```bash
   winetricks vcrun6 mfc42 msvcirt
   ```

4. Install Visual Studio 6.0 in Wine:
   ```bash
   wine /path/to/vs6/setup.exe
   ```

5. Run the build script:
   ```bash
   ./build.sh
   ```

### Option 3: Docker Build Environment

A Dockerfile is provided for reproducible builds:

```bash
docker build -t tibiaauto-build .
docker run -v $(pwd):/build tibiaauto-build
```

**Note:** You'll need to provide Visual C++ 6.0 installation files separately.

### Option 4: Modern MinGW Cross-Compilation

**Limitations:** This requires significant code modifications because:
- MinGW doesn't support MFC
- Would need to replace MFC dialogs with Win32 API
- Python 2.4 integration may need updates

## Project Structure

```
tibiaauto/
├── tibiaauto.cpp              # Main application
├── tibiaauto.dsp              # VC++ 6.0 project file
├── tibiaauto.dsw              # VC++ 6.0 workspace
├── tibiaauto.rc               # Resource file
├── tibiaautoDlg.cpp           # Main dialog
├── PythonEngine.cpp           # Python scripting engine
├── tibiaautoinject2/          # DLL injection module
│   ├── tibiaautoinject2.cpp
│   └── tibiaautoinject2.dsp
├── tibiaauto_util/            # Utility library
│   ├── MemReader.cpp
│   ├── TibiaMap.cpp
│   └── tibiaauto_util.dsp
└── Debug/                     # Build output
    └── tibiaauto2.exe

```

## Dependencies

### Required Libraries
- **MFC42.DLL** - Microsoft Foundation Classes 4.2
- **MSVCRT.DLL** - Microsoft C Runtime
- **xerces-c_2_7.dll** - Xerces C++ XML Parser
- **Python24.dll** - Python 2.4 (optional, for scripting)

### Include Paths (from .dsp)
- `E:/Python24/include` - Python headers
- `../tibiaauto-pub/sdk` - TibiaAuto SDK headers

### Library Paths
- `e:\python24\libs` - Python libraries
- `./` - xerces.lib, detours.lib

## Troubleshooting

### "Cannot find MFC42.DLL"
- Install Visual C++ 6.0 redistributables
- Or use winetricks: `winetricks mfc42`

### "Python24.dll not found"
- Install Python 2.4 or build without Python support
- Comment out Python-related code in tibiaauto.dsp

### "xerces.lib not found"
- Download Xerces C++ 2.7
- Place xerces.lib in project root
- Place xerces-c_2_7.dll with executable

### Wine build fails
- Ensure 32-bit Wine is installed
- Check Wine prefix is initialized: `wineboot -u`
- Verify VC++ 6.0 is installed: `wine "C:\\Program Files\\Microsoft Visual Studio\\VC98\\Bin\\CL.EXE"`

## Modifying the Code

**Adding new features:**
1. Edit source files (.cpp, .h)
2. Update resources in tibiaauto.rc if needed
3. Rebuild project

**Adding new modules:**
1. Create module in `mods/` directory
2. Add module .dsp to workspace
3. Add dependency in main tibiaauto project
4. Rebuild all

**Important Notes:**
- This is a 32-bit Windows application
- Uses deprecated MFC 4.2 APIs
- Python 2.4 is end-of-life (consider upgrading to Python 3.x)
- Code uses Win32 API for game memory injection (may trigger antivirus)

## License

See LICENSE.gnu2.0 file in the repository.

## Disclaimer

This tool is for educational purposes. Game automation may violate game terms of service.
