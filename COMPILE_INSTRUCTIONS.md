# Compilation Instructions for TibiaAuto

## Changes Made
The following modifications have been committed to branch `claude/walker-fixes-012aymL2KAeBhZgix422KAXk`:

1. **Rope Spot Fix** (tibiaauto-kernel/tibiaauto_util/ModuleUtil.cpp)
   - Modified walker to step beside rope spots before using rope
   - Mirrors the existing shovel behavior for closed holes
   - Prevents character from standing on the hole when using ropes

2. **Waypoint Limit Increase** (tibiaauto-pub/mods/mod_cavebot/ConfigData.h)
   - Increased MAX_WAYPOINTCOUNT from 1000 to 10000
   - Allows for more complex walking paths

## Compilation Requirements

This project requires:
- **Visual Studio 2014** (or newer with v140 platform toolset)
- **Windows SDK** for Win32 development
- **MFC (Microsoft Foundation Classes)** libraries

## Building on Windows

### Option 1: Visual Studio IDE
1. Open `tibiaauto.sln` in Visual Studio 2014 or newer
2. Select configuration: `Release | Win32` (recommended) or `Debug | Win32`
3. Build > Build Solution (or press F7)
4. Output will be in:
   - Main executable: `tibiaauto-kernel/Release/tibiaauto.exe`
   - Modules (DLLs): `tibiaauto-pub/mods/*/Release/*.dll`

### Option 2: MSBuild Command Line
```cmd
"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
msbuild tibiaauto.sln /p:Configuration=Release /p:Platform=Win32
```

## Building on Linux (Advanced)

### Requirements
- Wine with 32-bit support
- Visual Studio Build Tools installed in Wine
- Or use Docker with Windows build environment

### Using Wine + Visual Studio Build Tools
1. Install Wine with 32-bit support:
   ```bash
   sudo dpkg --add-architecture i386
   sudo apt-get update
   sudo apt-get install wine32 wine64 winetricks
   ```

2. Initialize Wine prefix:
   ```bash
   WINEARCH=win32 WINEPREFIX=~/.wine32 wine wineboot
   ```

3. Install Visual Studio Build Tools in Wine (requires MSVC installer)

4. Build using Wine:
   ```bash
   WINEPREFIX=~/.wine32 wine MSBuild.exe tibiaauto.sln /p:Configuration=Release /p:Platform=Win32
   ```

## Testing the Changes

After compilation:
1. Run `tibiaauto.exe`
2. Configure the cavebot/walker module
3. Test rope spot navigation:
   - Add a waypoint with a rope spot
   - Verify the character steps beside the rope spot before using rope
   - Character should not stand directly on the hole
4. Test waypoint limits:
   - Create paths with more than 1000 waypoints (up to 10000 now supported)

## Troubleshooting

### Build Errors
- **Missing MFC**: Install Visual Studio with C++ MFC components
- **Platform toolset v140 not found**: Install Visual Studio 2015 build tools or retarget solution
- **Windows SDK not found**: Install Windows 10 SDK or retarget solution

### Runtime Errors
- **DLL not found**: Ensure all module DLLs are in the same directory as tibiaauto.exe
- **Access violations**: Run as administrator (required for Tibia process injection)

## Modified Files
```
tibiaauto-kernel/tibiaauto_util/ModuleUtil.cpp  (rope spot handling)
tibiaauto-pub/mods/mod_cavebot/ConfigData.h     (waypoint limit)
```

## Commit Information
- Branch: `claude/walker-fixes-012aymL2KAeBhZgix422KAXk`
- Commit: a7d2e4c
- Changes: Fix walker rope spot handling and increase waypoint limit
