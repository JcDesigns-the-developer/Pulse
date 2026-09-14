#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config/pulse-backup-$(date +%Y%m%d-%H%M%S)"

packages=()
while IFS= read -r pkg; do
  [[ -n "$pkg" && "$pkg" != \#* ]] && packages+=("$pkg")
done < "$REPO_DIR/packages.txt"

echo "== Pulse-Ware installer =="
echo "This will install the Pulse-Ware desktop configuration."

if ! command -v pacman >/dev/null 2>&1; then
  echo "Pulse-Ware currently targets Arch Linux / EndeavourOS."
  exit 1
fi

sudo pacman -Syu --needed "${packages[@]}"

mkdir -p "$BACKUP_DIR"
for dir in hypr waybar rofi kitty mako hyprlock hypridle gtk-3.0 gtk-4.0 qt5ct qt6ct environment.d; do
  if [[ -d "$CONFIG_DIR/$dir" ]]; then
    mv "$CONFIG_DIR/$dir" "$BACKUP_DIR/$dir"
  fi
done

cp -a "$REPO_DIR/.config/." "$CONFIG_DIR/"
mkdir -p "$HOME/.local/bin"
if [[ -d "$REPO_DIR/local/bin" ]]; then
  cp -a "$REPO_DIR/local/bin/." "$HOME/.local/bin/"
  chmod +x "$HOME/.local/bin/"* 2>/dev/null || true
fi

mkdir -p "$HOME/Pictures/Screenshots"

# XDG_RUNTIME_DIR is normally provided by systemd-logind. The generated
# environment file makes the value explicit for the user's next graphical
# session without hard-coding a UID into the Hyprland config.
uid="$(id -u)"
mkdir -p "$CONFIG_DIR/environment.d"
cat > "$CONFIG_DIR/environment.d/90-pulse.conf" <<EOF
XDG_RUNTIME_DIR=/run/user/$uid
XDG_SESSION_TYPE=wayland
XDG_CURRENT_DESKTOP=Hyprland
DESKTOP_SESSION=hyprland
MOZ_ENABLE_WAYLAND=1
ELECTRON_OZONE_PLATFORM_HINT=auto
EOF

# Optional environment integrations.
if command -v starship >/dev/null 2>&1; then
  touch "$HOME/.bashrc"
  grep -qxF 'eval "$(starship init bash)"' "$HOME/.bashrc" 2>/dev/null || echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
fi

autostart_dir="$CONFIG_DIR/autostart"
mkdir -p "$autostart_dir"
cat > "$autostart_dir/pulse-nm-applet.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Pulse Network Applet
Exec=nm-applet --indicator
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

# Only talk to the user systemd instance when this shell is already inside a
# graphical/logind session. A TTY installer should not emit a D-Bus failure.
if [[ -n "${XDG_RUNTIME_DIR:-}" && -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
  systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
else
  echo "Skipping user PipeWire activation: no user D-Bus session is available."
  echo "It will be available automatically after logging into the Pulse session."
fi

sudo systemctl enable --now NetworkManager.service || true

chmod +x "$REPO_DIR"/local/bin/* "$REPO_DIR"/.config/hypr/scripts/* 2>/dev/null || true

cat <<EOF

Pulse-Ware installed.
Backup: $BACKUP_DIR

Your previous Hyprland launch failed because XDG_RUNTIME_DIR was not set.
The installer now configures it and provides a safe launcher.

Log out and back in so systemd/logind creates the normal user session.
Then launch Hyprland normally, or from a TTY use:
  pulse-session

Do NOT manually create /run/user/$uid; systemd owns that directory.
EOF
