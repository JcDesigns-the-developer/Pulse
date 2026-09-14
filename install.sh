#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config/pulse-backup-$(date +%Y%m%d-%H%M%S)"

packages=(
  hyprland waybar rofi-wayland kitty mako hyprlock hypridle
  pipewire pipewire-pulse wireplumber networkmanager
  grim slurp wl-clipboard playerctl brightnessctl
  jq curl git fastfetch cava
)

echo "== Pulse-Ware installer =="

if ! command -v pacman >/dev/null 2>&1; then
  echo "Pulse-Ware currently targets Arch Linux / EndeavourOS."
  exit 1
fi

sudo pacman -Syu --needed "${packages[@]}"

mkdir -p "$BACKUP_DIR"
for dir in hypr waybar rofi kitty mako hyprlock hypridle; do
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

systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service || true
sudo systemctl enable --now NetworkManager.service || true

echo
echo "Pulse-Ware installed."
echo "Backup: $BACKUP_DIR"
echo "Log out and select Hyprland, then log back in."
