# Quick Start Guide - Building TibiaAuto Walker Fixes

## What Was Changed

Branch: `claude/walker-fixes-012aymL2KAeBhZgix422KAXk`

**Changes:**
1. **Rope Spot Fix** - Walker now steps beside rope spots before using rope (like it does for shoveling)
2. **Waypoint Limit** - Increased from 1000 to 10000 waypoints

**Modified Files:**
- `tibiaauto-kernel/tibiaauto_util/ModuleUtil.cpp` (lines 1480-1523)
- `tibiaauto-pub/mods/mod_cavebot/ConfigData.h` (line 13)

## Fastest Way to Build

### On Windows (5 minutes)

1. **Install Visual Studio Community** (free)
   - Download: https://visualstudio.microsoft.com/downloads/
   - Select: "Desktop development with C++"
   - Include: "MFC and ATL support"

2. **Open and Build**
   ```cmd
   # Open the solution
   start tibiaauto.sln

   # Or build from command line:
   "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe" tibiaauto.sln /p:Configuration=Release /p:Platform=Win32
   ```

3. **Get Output**
   ```
   tibiaauto-kernel\Release\tibiaauto.exe
   tibiaauto-pub\mods\mod_cavebot\Release\mod_cavebot.dll
   ```

### With Docker (15 minutes)

1. **Build Docker Image**
   ```bash
   docker build -f Dockerfile.build -t tibiaauto-build .
   ```

2. **Download Visual Studio Build Tools**
   ```bash
   wget https://aka.ms/vs/15/release/vs_buildtools.exe
   ```

3. **Run Container & Install**
   ```bash
   docker run -it \
     -v $(pwd):/build \
     -v $(pwd)/vs_buildtools.exe:/tmp/vs_buildtools.exe \
     --name tibiaauto-builder \
     tibiaauto-build bash

   # Inside container:
   xvfb-run wine /tmp/vs_buildtools.exe
   # Select: Visual C++ build tools + MFC
   ```

4. **Build**
   ```bash
   # Inside container or from outside:
   docker exec tibiaauto-builder /usr/local/bin/docker-build.sh
   ```

See `DOCKER_BUILD.md` for detailed Docker instructions and alternatives.

## View Changes (No Build Required)

To see exactly what changed without building:

```bash
# View the rope spot fix
git diff origin/master -- tibiaauto-kernel/tibiaauto_util/ModuleUtil.cpp

# View waypoint limit change
git diff origin/master -- tibiaauto-pub/mods/mod_cavebot/ConfigData.h
```

## Testing the Fixes

After building:

1. **Test Rope Spot Fix:**
   - Create a waypoint path that goes up a rope spot
   - Observe: Character should step beside the hole first
   - Then: Character uses rope from the adjacent tile
   - Previously: Character would stand ON the hole

2. **Test Waypoint Limit:**
   - Try creating paths with more than 1000 waypoints
   - Should now support up to 10,000 waypoints

## Troubleshooting

**"Platform toolset v120_xp not found"**
- Update all .vcxproj files to use v141 or v142:
  ```bash
  find . -name "*.vcxproj" -exec sed -i 's/v120_xp/v141/g' {} \;
  ```

**"Cannot find MFC"**
- Reinstall Visual Studio with "MFC and ATL support" option

**Docker build fails**
- Check Docker is running: `docker ps`
- Check network access for package downloads
- See DOCKER_BUILD.md for detailed troubleshooting

## Files in This Repo

- `QUICKSTART.md` (this file) - Fast build guide
- `DOCKER_BUILD.md` - Comprehensive Docker build guide (4 options)
- `COMPILE_INSTRUCTIONS.md` - General compilation instructions
- `Dockerfile.build` - Docker image for Wine + VS Build Tools
- `docker-build.sh` - Build script for Docker container
- `tibiaauto.sln` - Visual Studio solution file

## Next Steps

After successful build:
1. Copy tibiaauto.exe and all .dll files to your Tibia Auto directory
2. Test the rope spot fix in-game
3. Test creating larger waypoint paths (1000+ waypoints)
4. Report any issues!

## Questions?

- Check the detailed guides: `DOCKER_BUILD.md` or `COMPILE_INSTRUCTIONS.md`
- See git diff to understand code changes
- Review the commit messages for implementation details
