#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config/pulse-backup-$(date +%Y%m%d-%H%M%S)"

packages=()
while IFS= read -r pkg; do
  [[ -n "$pkg" && "$pkg" != \#* ]] && packages+=("$pkg")
done < "$REPO_DIR/packages.txt"

echo "== Pulse Ghost installer =="
echo "Installing the Pulse desktop stack and control tools."

if ! command -v pacman >/dev/null 2>&1; then
  echo "Pulse currently targets Arch Linux / EndeavourOS."
  exit 1
fi

sudo pacman -Syu --needed "${packages[@]}"

mkdir -p "$BACKUP_DIR"
for dir in hypr waybar rofi kitty mako hyprlock hypridle gtk-3.0 gtk-4.0 qt5ct qt6ct environment.d pulse systemd; do
  if [[ -e "$CONFIG_DIR/$dir" ]]; then
    mv "$CONFIG_DIR/$dir" "$BACKUP_DIR/$dir"
  fi
done

cp -a "$REPO_DIR/.config/." "$CONFIG_DIR/"
mkdir -p "$HOME/.local/bin"
if [[ -d "$REPO_DIR/local/bin" ]]; then
  cp -a "$REPO_DIR/local/bin/." "$HOME/.local/bin/"
  chmod +x "$HOME/.local/bin/"* 2>/dev/null || true
fi

wayland_sessions="$HOME/.local/share/wayland-sessions"
mkdir -p "$wayland_sessions"
if [[ -f "$REPO_DIR/session/pulse.desktop" ]]; then
  cp -f "$REPO_DIR/session/pulse.desktop" "$wayland_sessions/pulse.desktop"
fi

mkdir -p "$HOME/Pictures/Screenshots"

# XDG_RUNTIME_DIR is owned and created by systemd-logind. Pulse deliberately
# does not manufacture it in environment.d because doing so can break PipeWire,
# D-Bus, and graphical sessions.
mkdir -p "$CONFIG_DIR/environment.d"
cat > "$CONFIG_DIR/environment.d/90-pulse.conf" <<'EOF'
XDG_SESSION_TYPE=wayland
XDG_CURRENT_DESKTOP=Hyprland
DESKTOP_SESSION=pulse
MOZ_ENABLE_WAYLAND=1
ELECTRON_OZONE_PLATFORM_HINT=auto
EOF

mkdir -p "$CONFIG_DIR/pulse"
cat > "$CONFIG_DIR/pulse/pulse.conf" <<EOF
PULSE_REPO_DIR=$REPO_DIR
PULSE_VERSION=2.0.0
EOF

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

timer_dir="$CONFIG_DIR/systemd/user/timers.target.wants"
mkdir -p "$timer_dir"
ln -sfn ../pulse-update.timer "$timer_dir/pulse-update.timer"

if [[ -n "${XDG_RUNTIME_DIR:-}" && -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
  systemctl --user daemon-reload || true
  systemctl --user enable --now pulse-update.timer || true
  systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
else
  echo "Skipping immediate user-systemd activation: no user D-Bus session is available."
  echo "The Pulse updater will activate after the next graphical user login."
fi

sudo systemctl enable --now NetworkManager.service || true

chmod +x "$REPO_DIR"/local/bin/* "$REPO_DIR"/.config/hypr/scripts/* 2>/dev/null || true

cat <<EOF

Pulse Ghost installed.
Backup: $BACKUP_DIR

CONTROL COMMANDS:
  pulse                  Control menu
  pulse start            Start through start-hyprland
  pulse network          Wi-Fi/network control
  pulse settings         Settings
  pulse doctor           Diagnostics
  pulse fix/update       Update + repair

AUTO UPDATE:
  Pulse checks GitHub main every 30 minutes.
  Update log: ~/.local/state/pulse/update.log

IMPORTANT:
  XDG_RUNTIME_DIR is supplied by systemd-logind; Pulse does not create it.
  Do not run Hyprland with sudo.

Log out and back in after installation, then choose Pulse in your display
manager or run 'pulse-session' from a properly initialized systemd user TTY.
EOF
