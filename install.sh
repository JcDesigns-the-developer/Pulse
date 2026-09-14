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
for dir in hypr waybar rofi kitty mako hyprlock hypridle gtk-3.0 qt5ct; do
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

# Optional environment integrations.
if command -v starship >/dev/null 2>&1; then
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

systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
sudo systemctl enable --now NetworkManager.service || true

chmod +x "$REPO_DIR"/local/bin/* "$REPO_DIR"/.config/hypr/scripts/* 2>/dev/null || true

echo
echo "Pulse-Ware installed."
echo "Backup: $BACKUP_DIR"
echo "Log out and select Hyprland, then log back in."
