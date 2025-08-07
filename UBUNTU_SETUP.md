# Simula on Ubuntu: Complete Setup Guide

This document provides a comprehensive guide for running Simula VR compositor on Ubuntu systems, including desktop environment integration.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Desktop Environment Integration](#desktop-environment-integration)
- [Troubleshooting](#troubleshooting)
- [Changelog](#changelog)

## Prerequisites

### System Requirements
- Ubuntu 20.04 LTS or newer
- Graphics drivers properly installed (NVIDIA/AMD/Intel)
- Wayland support enabled
- At least 4GB RAM
- OpenGL ES 3.0 compatible graphics card

### Required Software
1. **Nix Package Manager**
   ```bash
   curl -L https://nixos.org/nix/install | sh
   source ~/.nix-profile/etc/profile.d/nix.sh
   ```

2. **Enable Nix Flakes** (required for Simula)
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

3. **Graphics Acceleration (nixGL)**
   ```bash
   nix profile install github:guibou/nixGL
   ```

## Installation

### Quick Start
Run Simula directly without installation:
```bash
# Source Nix environment
source ~/.nix-profile/etc/profile.d/nix.sh

# Run Simula
nix run github:walue-ai/Simula
```

### Desktop Environment Integration
To make Simula selectable as a desktop environment at login:

1. **Clone the repository**
   ```bash
   git clone https://github.com/walue-ai/Simula.git
   cd Simula
   ```

2. **Install as desktop environment**
   ```bash
   sudo ./install-desktop-environment.sh
   ```

3. **Log out and select "Simula VR Desktop" from your login manager**

## Desktop Environment Integration

### Session Files
The desktop environment integration includes:

- **Session Script**: `/usr/local/bin/simula-session`
  - Handles Nix environment setup
  - Configures Wayland session variables
  - Launches Simula in desktop mode

- **Desktop Entry**: `/usr/share/wayland-sessions/simula-session.desktop`
  - Makes Simula appear in login manager
  - Configured as XSession type for proper integration

- **Desktop Configuration**: `config/desktop-config.dhall`
  - Defaults to "Pancake" (non-VR) mode
  - Optimized for desktop environment use

### Features Available in Desktop Mode

#### Window Management
- **Window Grabbing**: `Super + Alt` - Grab and move windows
- **Multi-window Grab**: `Super + M` - Grab all windows
- **Workspace Grab**: `Super + Shift + M` - Grab all workspaces

#### Application Management
- **App Launcher**: `Super + A` - Launch Synapse application launcher
- **Terminal**: `Super + Enter` - Launch terminal
- **Environment Cycling**: `Super + E` - Cycle background environments

#### System Controls
- **Escape Simula**: `Super + Z` - Return control to host system
- **Screenshot**: `Super + PrtSc` - Take screenshot
- **Video Recording**: `Super + Shift + PrtSc` - Toggle recording

## Troubleshooting

### Common Issues

#### 1. nixGL Compatibility Errors
**Problem**: `error: installable does not correspond to a Nix language value`

**Solution**: This has been fixed in recent updates. Ensure you're using the latest version:
```bash
git pull origin master
nix run github:walue-ai/Simula
```

#### 2. X11 Display Not Available (Headless Systems)
**Problem**: `X11 Display is not available`

**Solution**: This is expected on headless servers. Simula requires a graphics environment.

#### 3. Audio Driver Errors
**Problem**: ALSA/PulseAudio errors in console

**Solution**: These are non-critical warnings. Simula will fall back to dummy audio driver.

#### 4. Session Not Appearing in Login Manager
**Problem**: "Simula VR Desktop" doesn't appear in session selection

**Solutions**:
- Verify files are installed: `ls /usr/share/wayland-sessions/simula-session.desktop /usr/share/xsessions/simula-session.desktop`
- Check script permissions: `ls -la /usr/local/bin/simula-session`
- Restart display manager: 
  - For GDM: `sudo systemctl restart gdm`
  - For LightDM: `sudo systemctl restart lightdm`
  - For SDDM: `sudo systemctl restart sddm`
- Check display manager logs: `journalctl -u gdm -f` (replace gdm with your display manager)
- Verify session file format: `cat /usr/share/xsessions/simula-session.desktop`

**Manual Installation**:
If automatic installation fails, manually copy files:
```bash
sudo cp simula-session.desktop /usr/share/xsessions/
sudo cp simula-session.desktop /usr/share/wayland-sessions/
sudo cp simula-session /usr/local/bin/
sudo chmod +x /usr/local/bin/simula-session
```

### Manual Testing
Test the session script directly:
```bash
/usr/local/bin/simula-session
```

## Changelog

### Recent Updates (2025-08-07)

#### Desktop Environment Integration
- ✅ **Added desktop environment session files**
  - Created `simula-session` script with robust Nix environment handling
  - Added `simula-session.desktop` for display manager integration
  - Created `install-desktop-environment.sh` installation script

- ✅ **Desktop-optimized configuration**
  - Added `config/desktop-config.dhall` with Pancake mode defaults
  - Configured for non-VR desktop use
  - Optimized keyboard shortcuts for desktop workflow

#### Stability Fixes
- ✅ **Fixed nixGL compatibility issues** (PR #1, #2)
  - Resolved unfree package access problems
  - Improved nixGL detection and integration
  - Fixed `NIXPKGS_ALLOW_UNFREE` environment variable propagation

- ✅ **Fixed runtime stability issues** (PR #3)
  - Fixed log directory creation errors
  - Resolved Haskell exit handling warnings
  - Improved error handling in `SimulaServer.hs`

#### Architecture Improvements
- ✅ **Enhanced session management**
  - Multiple Nix installation path support
  - Proper Wayland session variable setup
  - Experimental features configuration

- ✅ **Improved error handling**
  - Better prerequisite checking
  - Installation verification
  - Graceful fallbacks for missing components

### Technical Details

#### Simula as Desktop Environment
Simula functions as a complete desktop environment through:

1. **Wayland Compositor**: Built on wlroots, providing full window management
2. **Application Launcher**: Integrated Synapse launcher (`Super + A`)
3. **Session Management**: xpra integration for persistent application sessions
4. **Pancake Mode**: Non-VR desktop rendering via PancakeCamera
5. **Input Handling**: Complete keyboard and mouse input processing

#### Session Integration
The desktop environment integration works by:

1. **Display Manager Detection**: Session files in `/usr/share/wayland-sessions/`
2. **Environment Setup**: Proper Nix and Wayland environment configuration
3. **Configuration Override**: Desktop-specific config with Pancake mode
4. **Process Management**: Systemd integration for session lifecycle

## Support

For issues or questions:
- GitHub Issues: https://github.com/walue-ai/Simula/issues
- Documentation: https://github.com/walue-ai/Simula/blob/master/README.org

## Contributing

When contributing to Ubuntu compatibility:
1. Test on multiple Ubuntu versions (20.04, 22.04, 24.04)
2. Verify both X11 and Wayland compatibility
3. Test with different display managers (GDM, SDDM, LightDM)
4. Document any new dependencies or requirements
