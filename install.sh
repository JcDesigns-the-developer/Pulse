#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config/pulse-backup-$(date +%Y%m%d-%H%M%S)"

packages=()
while IFS= read -r pkg; do
  [[ -n "$pkg" && "$pkg" != \#* ]] && packages+=("$pkg")
done < "$REPO_DIR/packages.txt"

echo "== Pulse installer =="
echo "Installing the Pulse desktop stack and its control tools."

if ! command -v pacman >/dev/null 2>&1; then
  echo "Pulse currently targets Arch Linux / EndeavourOS."
  exit 1
fi

sudo pacman -Syu --needed "${packages[@]}"

mkdir -p "$BACKUP_DIR"
for dir in hypr waybar rofi kitty mako hyprlock hypridle gtk-3.0 gtk-4.0 qt5ct qt6ct environment.d systemd; do
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

# Install a real Wayland session entry so display managers can offer Pulse.
wayland_sessions="$HOME/.local/share/wayland-sessions"
mkdir -p "$wayland_sessions"
if [[ -f "$REPO_DIR/session/pulse.desktop" ]]; then
  cp -f "$REPO_DIR/session/pulse.desktop" "$wayland_sessions/pulse.desktop"
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
DESKTOP_SESSION=pulse
MOZ_ENABLE_WAYLAND=1
ELECTRON_OZONE_PLATFORM_HINT=auto
EOF

# Remember where this checkout lives so the background updater can pull it.
mkdir -p "$CONFIG_DIR/pulse"
cat > "$CONFIG_DIR/pulse/pulse.conf" <<EOF
PULSE_REPO_DIR=$REPO_DIR
PULSE_VERSION=1.0.0
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

# Enable the Pulse updater even when the installer is run from a TTY without
# a user D-Bus session. systemd will start the timer on the next user login.
timer_dir="$CONFIG_DIR/systemd/user/timers.target.wants"
mkdir -p "$timer_dir"
ln -sfn ../pulse-update.timer "$timer_dir/pulse-update.timer"

# Only talk to the user systemd instance when this shell is already inside a
# graphical/logind session. A TTY installer should not emit a D-Bus failure.
if [[ -n "${XDG_RUNTIME_DIR:-}" && -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
  systemctl --user daemon-reload || true
  systemctl --user enable --now pulse-update.timer || true
  systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
else
  echo "Skipping immediate user-systemd activation: no user D-Bus session is available."
  echo "The Pulse updater is enabled and will start with the next user session."
fi

sudo systemctl enable --now NetworkManager.service || true

chmod +x "$REPO_DIR"/local/bin/* "$REPO_DIR"/.config/hypr/scripts/* 2>/dev/null || true

cat <<EOF

Pulse installed.
Backup: $BACKUP_DIR

CONTROL COMMANDS:
  pulse                 Open the Pulse control menu
  pulse start           Start the Pulse session
  pulse update          Update Pulse
  pulse fix             Repair Pulse
  pulse fix/update      Update + repair everything
  pulse settings        Pulse settings/control panel
  pulse doctor          Diagnose the installation

AUTO UPDATE:
  Pulse checks the GitHub main branch every 30 minutes.
  Updates are fast-forward-only and local repo changes are never overwritten.
  Updated config files are applied automatically after a successful pull.
  Update log: ~/.local/state/pulse/update.log

Log out and back in so systemd/logind creates the normal user session.
From a TTY, use:
  pulse-session

Do NOT run Hyprland with sudo and do NOT manually create /run/user/$uid.
EOF
