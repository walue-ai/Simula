#!/bin/bash

# Install Simula as a Desktop Environment

set -e

echo "Installing Simula as Desktop Environment..."

if ! command -v nix >/dev/null 2>&1; then
    echo "Error: Nix is not installed. Please install Nix first."
    exit 1
fi

sudo cp simula-session.desktop /usr/share/wayland-sessions/
sudo cp simula-session /usr/local/bin/
sudo chmod +x /usr/local/bin/simula-session

if [ -f /usr/share/wayland-sessions/simula-session.desktop ] && [ -x /usr/local/bin/simula-session ]; then
    echo "✓ Session files installed successfully"
else
    echo "✗ Session file installation failed"
    exit 1
fi

sudo mkdir -p /usr/lib/systemd/user
cat << 'EOF' | sudo tee /usr/lib/systemd/user/simula-desktop.service
[Unit]
Description=Simula VR Desktop Environment
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/local/bin/simula-session
Restart=on-failure
Environment=XDG_SESSION_TYPE=wayland
Environment=XDG_CURRENT_DESKTOP=Simula

[Install]
WantedBy=graphical-session.target
EOF

echo "Simula Desktop Environment installed successfully!"
echo "You can now select 'Simula VR Desktop' from your login manager."
echo ""
echo "Note: Make sure you have:"
echo "1. Nix installed and configured"
echo "2. Graphics drivers properly installed"
echo "3. Wayland support enabled in your display manager"
echo ""
echo "To test the session script manually, run: /usr/local/bin/simula-session"
