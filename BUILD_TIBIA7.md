# Building TibiaAuto for Tibia 7.41/7.72

This guide explains how to compile or use the old TibiaAuto version for **Tibia 7.41** (compatible with OT servers running 7.72 protocol).

## Quick Start - Use Pre-Compiled Binaries (No Build Required!)

**The easiest option**: Pre-compiled binaries are already included!

```bash
# Switch to the Tibia 7.41 branch
git checkout claude/tibia7-build-012aymL2KAeBhZgix422KAXk

# Binaries are ready to use:
ls -lh Debug/tibiaauto2.exe         # 469 KB - Main executable
ls -lh tibiaautoinject.dll          # 24 KB  - Injection DLL
ls -lh tibiaautoinject2.dll         # 68 KB  - Injection DLL v2
```

Copy these files to your Tibia 7.x directory and run `tibiaauto2.exe`.

---

## Option 1: Build with Docker + Wine + Visual C++ 6.0

Visual C++ 6.0 is from 1998 and very difficult to set up. This option requires significant effort.

### Step 1: Build Docker Image

```bash
docker build -f Dockerfile.vc6 -t tibiaauto-vc6 .
```

### Step 2: Install Visual C++ 6.0

You'll need a Visual C++ 6.0 installer (vc6setup.exe or similar). This is legacy software that's hard to find.

```bash
# Run interactive container
docker run -it \
  -v $(pwd):/build \
  -v /path/to/vc6setup.exe:/tmp/vc6setup.exe \
  --name tibiaauto-vc6-builder \
  tibiaauto-vc6 bash

# Inside container, install VC6
wine /tmp/vc6setup.exe

# Follow the installer - select:
# - Visual C++
# - MFC libraries
# - ATL libraries
```

### Step 3: Build

```bash
# Inside container or from outside:
docker exec tibiaauto-vc6-builder /usr/local/bin/docker-build-vc6.sh
```

---

## Option 2: Build on Windows (Simplest if you have Windows)

### Requirements

- **Visual C++ 6.0** or **Visual Studio 6.0** (1998)
  - If you don't have VC6, you can try Visual Studio 2019/2022:
    - Install "Visual C++ 6.0 compatibility" or
    - Use "Retarget Solution" to upgrade to modern toolset

### Build Steps

#### Using Visual C++ 6.0:

```cmd
REM Open workspace in VC6 IDE
msdev tibiaauto.dsw

REM Or build from command line:
cd "C:\Program Files\Microsoft Visual Studio\Common\MSDev98\Bin"
msdev.exe C:\path\to\tibiaauto.dsw /MAKE "ALL - Win32 Release" /REBUILD
```

#### Using Modern Visual Studio:

1. Open `tibiaauto.dsw` in Visual Studio 2019/2022
2. Allow Visual Studio to upgrade the project
3. Select **Release | Win32** configuration
4. Build → Build Solution (F7)

**Note**: You may encounter errors due to outdated code. The pre-compiled binaries are recommended.

---

## Option 3: Use MinGW (Experimental - Not Recommended)

Visual C++ 6.0 projects use MFC which is not compatible with MinGW. You would need to:
1. Port all MFC code to pure Win32 API
2. Rewrite resource files
3. Update project files

**Not practical** - use pre-compiled binaries instead.

---

## For Tibia 7.72 (vs 7.41)

This codebase is configured for **Tibia 7.41**. If you need **Tibia 7.72**, you'll need to:

### 1. Find Memory Addresses for 7.72

Use a memory scanner (Cheat Engine) to find:
- Player position (X, Y, Z addresses)
- HP, Mana, Level addresses
- Inventory/container addresses
- Map data structures

### 2. Update the Code

Memory addresses are hardcoded in the source. Update files:
- `MemReader.cpp` - Character data addresses
- `TibiaMap.cpp` - Map reading addresses
- `PackSender.cpp` - Packet structures (if protocol changed)

### 3. Recompile

Follow one of the build options above.

**OR**: Check if an OT server running 7.72 protocol is compatible with these 7.41 binaries. Many OT servers use protocol 7.4x for "7.72 era" servers.

---

## Project Structure

```
tibiaauto/
├── tibiaauto.dsw              # Visual C++ 6.0 workspace
├── tibiaauto.dsp              # Main project
├── Debug/
│   └── tibiaauto2.exe         # ✅ Pre-compiled binary (469 KB)
├── tibiaautoinject.dll        # ✅ Injection DLL
├── tibiaautoinject2.dll       # ✅ Injection DLL v2
├── tibiaauto_util/            # Utility library
│   └── tibiaauto_util.dsp
└── tibiaautoinject2/          # Injector project
    └── tibiaautoinject2.dsp
```

**Note**: The workspace references `../tibiaauto-pub/` for modules (mod_cavebot, mod_looter, etc.). These modules are loaded as DLLs at runtime.

---

## Features in Tibia 7.41 Version

- ✅ Walker/Cavebot (mod_cavebot.dll)
- ✅ Automatic rune maker
- ✅ Auto fish
- ✅ Auto logout on player approach
- ✅ Monster show (shows monsters on different floors)
- ✅ Full light
- ✅ Item stacker
- ✅ UH healer
- ✅ Spell caster

---

## Troubleshooting

### "VC6 is too old / hard to find"
→ **Use the pre-compiled binaries!** They're included in `Debug/tibiaauto2.exe`

### "I need to modify the code"
→ Try opening in Visual Studio 2019/2022 and let it upgrade the project
→ Or edit source files and ask someone with VC6 to compile

### "Does this work with OT server X?"
→ Test it! If the OT server uses protocol 7.4x, it should work
→ If not, you'll need to find the correct memory addresses

### "mod_cavebot.dll not found"
→ The workspace references modules in `../tibiaauto-pub/mods/`
→ These need to be compiled separately or may be included in releases

### "Build errors in modern Visual Studio"
→ Common issues:
  - Replace `#include <afxwin.h>` with proper headers
  - Update deprecated functions
  - Fix C++11+ compatibility issues
  - Consider using pre-compiled binaries instead

---

## Quick Test

After building (or using pre-compiled):

```cmd
1. Start Tibia 7.x client
2. Run tibiaauto2.exe
3. Select your character
4. Enable modules (Walker, etc.)
5. Test basic functionality
```

---

## Comparison: 7.41 vs Modern (10.x)

| Feature | Tibia 7.41 (this branch) | Tibia 10.x (walker-fixes branch) |
|---------|-------------------------|-----------------------------------|
| **Compiler** | Visual C++ 6.0 | Visual Studio 2014+ |
| **Build System** | .dsw/.dsp | .sln/.vcxproj |
| **Pre-compiled?** | ✅ Yes (469 KB) | ❌ No |
| **Walker fixes** | ❌ Not applied | ✅ Applied |
| **Docker support** | ⚠️ Difficult (VC6) | ✅ Modern tools |

---

## Recommended Approach

1. **If you just want to use it**: Use pre-compiled binaries from `Debug/tibiaauto2.exe`
2. **If you need walker fixes**: Apply fixes manually to this codebase (see walker-fixes branch for reference)
3. **If you need to recompile**: Use Windows + Visual Studio (modern or VC6)

---

## Next Steps

- Test the pre-compiled `tibiaauto2.exe` with your Tibia 7.x client
- If it works, you're done!
- If you need modifications, consider:
  - Applying walker fixes from the modern branch
  - Updating memory addresses for 7.72
  - Upgrading to modern codebase (Tibia 10.x)

Questions? Check the main `QUICK START.md` or `DOCKER_BUILD.md` for modern codebase compilation.
