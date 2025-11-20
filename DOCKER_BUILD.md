# Building TibiaAuto with Docker

This guide explains how to compile TibiaAuto using Docker.

## Prerequisites

- Docker installed on your system
- 8GB RAM recommended
- 10GB free disk space

## Option 1: Linux Docker with Wine + Visual Studio Build Tools (Recommended)

This approach uses Wine to run Visual Studio Build Tools inside a Linux container.

### Step 1: Build the Docker Image

```bash
docker build -f Dockerfile.build -t tibiaauto-build .
```

### Step 2: Download Visual Studio Build Tools

Download **Visual Studio Build Tools 2017** (Community Edition - Free):
```bash
wget https://aka.ms/vs/15/release/vs_buildtools.exe -O vs_buildtools.exe
```

Or use Build Tools 2015 if you have it.

### Step 3: Run Interactive Container and Install Build Tools

```bash
docker run -it \
  -v $(pwd):/build \
  -v $(pwd)/vs_buildtools.exe:/tmp/vs_buildtools.exe \
  --name tibiaauto-builder \
  tibiaauto-build bash
```

Inside the container, install Visual Studio Build Tools:

```bash
# Install Build Tools with Visual C++ components
wine /tmp/vs_buildtools.exe

# During installation, select:
# - Visual C++ build tools
# - Windows 10 SDK (10.0.17763.0 or similar)
# - Visual C++ MFC for x86 and x64
```

**Note**: The installer will open a GUI. You'll need X11 forwarding or use `xvfb-run`:

```bash
# Alternative: Silent install (if supported)
xvfb-run wine /tmp/vs_buildtools.exe --quiet --norestart \
  --add Microsoft.VisualStudio.Workload.VCTools \
  --includeRecommended
```

### Step 4: Build TibiaAuto

After installation completes:

```bash
# Inside the container
/usr/local/bin/docker-build.sh
```

Or from outside:

```bash
docker start tibiaauto-builder
docker exec tibiaauto-builder /usr/local/bin/docker-build.sh
```

### Step 5: Get Build Output

The compiled files will be in your project directory:
```bash
ls -lh tibiaauto-kernel/Release/tibiaauto.exe
ls -lh tibiaauto-pub/mods/*/Release/*.dll
```

## Option 2: Windows Docker Container (Windows Host Only)

If you're on Windows with Docker Desktop, you can use Windows containers:

### Create Dockerfile.windows:

```dockerfile
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Install Chocolatey
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Visual Studio Build Tools
RUN choco install -y visualstudio2017buildtools --package-parameters "--add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --quiet"

WORKDIR C:\\build

ENTRYPOINT ["cmd", "/c", "msbuild tibiaauto.sln /p:Configuration=Release /p:Platform=Win32"]
```

### Build and Run:

```bash
# Switch to Windows containers in Docker Desktop
docker build -f Dockerfile.windows -t tibiaauto-build-win .
docker run -v ${PWD}:C:\build tibiaauto-build-win
```

## Option 3: Simple Windows Build (No Docker)

**Easiest option if you have Windows:**

1. Download and install **Visual Studio Community 2017/2019** (free)
   - https://visualstudio.microsoft.com/downloads/
   - Select "Desktop development with C++"
   - Include "MFC and ATL support"

2. Open `tibiaauto.sln` in Visual Studio

3. Select **Release | Win32** configuration

4. Build → Build Solution (F7)

5. Find output:
   ```
   tibiaauto-kernel\Release\tibiaauto.exe
   tibiaauto-pub\mods\mod_cavebot\Release\mod_cavebot.dll
   ```

## Option 4: GitHub Actions / CI (Automated)

Create `.github/workflows/build.yml`:

```yaml
name: Build TibiaAuto

on: [push]

jobs:
  build:
    runs-on: windows-latest

    steps:
    - uses: actions/checkout@v2

    - name: Add MSBuild to PATH
      uses: microsoft/setup-msbuild@v1.0.2

    - name: Build
      run: msbuild tibiaauto.sln /p:Configuration=Release /p:Platform=Win32

    - name: Upload artifacts
      uses: actions/upload-artifact@v2
      with:
        name: tibiaauto-release
        path: |
          tibiaauto-kernel/Release/*.exe
          tibiaauto-kernel/Release/*.dll
          tibiaauto-pub/mods/*/Release/*.dll
```

## Troubleshooting

### Wine Build Issues

**"wine32 not found"**
```bash
# The Dockerfile.build handles this, but if building manually:
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install wine32
```

**"MSBuild.exe not found"**
```bash
# Inside container, find MSBuild:
find ~/.wine32 -name "MSBuild.exe"

# Update docker-build.sh with correct path
```

**"MFC not found during build"**
```bash
# Reinstall MFC in Wine
winetricks -q mfc42
```

### Visual Studio Installation Issues

**Silent install hangs**
- Remove `--quiet` flag and watch progress
- Check logs in `%TEMP%` directory

**MFC components missing**
- Run installer again
- Select "Modify" installation
- Check "MFC and ATL support (x86 & x64)"

### Build Errors

**"error MSB3073: Platform toolset 'v140' not found"**
- Install Visual Studio 2015 Build Tools
- Or change to v141 (VS 2017) in all .vcxproj files:
  ```bash
  find . -name "*.vcxproj" -exec sed -i 's/v120_xp/v141/g' {} \;
  ```

**"fatal error LNK1104: cannot open file 'mfc120.lib'"**
- MFC not installed or wrong version
- Install matching MFC version for toolset

## Performance Tips

1. **Use volume mounts** instead of COPY in Dockerfile for faster iteration
2. **Persist Wine prefix** between builds:
   ```bash
   docker run -v $(pwd):/build -v wine-prefix:/root/.wine32 tibiaauto-build
   ```
3. **Parallel builds**: MSBuild uses `/m` flag by default in docker-build.sh
4. **Incremental builds**: Don't clean unless necessary

## Testing the Build

After building, test on a Windows machine:

```bash
# Copy all files to Windows
tibiaauto-kernel/Release/tibiaauto.exe
tibiaauto-kernel/Release/*.dll
tibiaauto-pub/mods/*/Release/*.dll

# Run and verify:
# 1. Application launches
# 2. Can attach to Tibia client
# 3. Walker module loads
# 4. Rope spot fix works correctly
```

## Current Build Status

Your modified code is in branch: `claude/walker-fixes-012aymL2KAeBhZgix422KAXk`

Changes:
- ✅ Rope spot handling fixed in ModuleUtil.cpp
- ✅ Waypoint limit increased to 10000 in ConfigData.h

Ready to build with any of the above methods!
