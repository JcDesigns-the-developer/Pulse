#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="$HOME/.local/state/pulse/backups/$(date +%Y%m%d-%H%M%S)"
PULSE_VERSION="3.1.0"

packages=()
while IFS= read -r pkg; do
    [[ -n "$pkg" && "$pkg" != \#* ]] && packages+=("$pkg")
done < "$REPO_DIR/packages.txt"

dry_run=false
if [[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]]; then
    dry_run=true
fi

echo "== Pulse Ghost $PULSE_VERSION =="
echo "Readable dotfiles. Simple installer."
echo

if ! command -v pacman >/dev/null 2>&1; then
    echo "Pulse currently targets Arch Linux / EndeavourOS."
    exit 1
fi

if [[ "$dry_run" == true ]]; then
    echo "DRY RUN - nothing will be changed."
    echo
    printf 'Packages:\n'
    printf '  + %s\n' "${packages[@]}"
    echo
    printf 'Config source:\n  %s\n' "$REPO_DIR/.config"
    printf 'Local commands:\n  %s\n' "$REPO_DIR/local/bin"
    echo
    printf 'Would link:\n'
    for path in "$REPO_DIR/.config"/*; do
        [[ -e "$path" ]] || continue
        printf '  ~/.config/%s -> %s\n' "$(basename "$path")" "$path"
    done
    printf '  ~/.local/bin/* -> %s/*\n' "$REPO_DIR/local/bin"
    exit 0
fi

sudo pacman -Syu --needed "${packages[@]}"

mkdir -p "$BACKUP_DIR" "$HOME/.local/state/pulse" "$HOME/.local/bin"

backup_path() {
    local target="$1"
    [[ -e "$target" || -L "$target" ]] || return 0
    mkdir -p "$(dirname "$BACKUP_DIR/$target")"
    mv "$target" "$BACKUP_DIR/$target"
}

link_path() {
    local source="$1"
    local target="$2"

    if [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
        return
    fi

    backup_path "$target"
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
}

# The repository is the source of truth, like a normal dotfiles checkout.
for source in "$REPO_DIR/.config"/*; do
    [[ -e "$source" ]] || continue
    link_path "$source" "$CONFIG_DIR/$(basename "$source")"
done

# Commands are linked instead of copied, so git pull updates the installed tools.
for source in "$REPO_DIR/local/bin"/*; do
    [[ -f "$source" ]] || continue
    link_path "$source" "$HOME/.local/bin/$(basename "$source")"
done
chmod +x "$REPO_DIR/local/bin/"* "$REPO_DIR/.config/hypr/scripts/"* 2>/dev/null || true

add_path_line() {
    local file="$1"
    touch "$file"
    grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$file" 2>/dev/null || \
        printf '\n# Pulse local commands\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$file"
}

add_path_line "$HOME/.bashrc"
if [[ -f "$HOME/.zshrc" || "${SHELL:-}" == */zsh ]]; then
    add_path_line "$HOME/.zshrc"
fi

wayland_sessions="$HOME/.local/share/wayland-sessions"
mkdir -p "$wayland_sessions"
if [[ -f "$REPO_DIR/session/pulse.desktop" ]]; then
    cp -f "$REPO_DIR/session/pulse.desktop" "$wayland_sessions/pulse.desktop"
fi

mkdir -p "$HOME/Pictures/Screenshots"

# XDG_RUNTIME_DIR belongs to systemd-logind. Never create or fake it here.
mkdir -p "$CONFIG_DIR/environment.d"
cat > "$CONFIG_DIR/environment.d/90-pulse.conf" <<'EOF'
XDG_SESSION_TYPE=wayland
XDG_CURRENT_DESKTOP=Hyprland
DESKTOP_SESSION=pulse
MOZ_ENABLE_WAYLAND=1
ELECTRON_OZONE_PLATFORM_HINT=auto
EOF

if command -v starship >/dev/null 2>&1; then
    touch "$HOME/.bashrc"
    grep -qxF 'eval "$(starship init bash)"' "$HOME/.bashrc" 2>/dev/null || \
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
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
fi

sudo systemctl enable --now NetworkManager.service || true

cat <<EOF

Pulse Ghost $PULSE_VERSION installed.
Backup: $BACKUP_DIR

Repository is the source of truth:
  ~/.config/*       -> $REPO_DIR/.config/*
  ~/.local/bin/*    -> $REPO_DIR/local/bin/*

Hyprland:
  ~/.config/hypr/hyprland.lua
  ~/.config/hypr/variables.lua
  ~/.config/hypr/general.lua
  ~/.config/hypr/monitors.lua
  ~/.config/hypr/input.lua
  ~/.config/hypr/layout.lua
  ~/.config/hypr/decoration.lua
  ~/.config/hypr/animations.lua
  ~/.config/hypr/rules.lua
  ~/.config/hypr/workspaces.lua
  ~/.config/hypr/keybinds.lua
  ~/.config/hypr/startup.lua
  ~/.config/hypr/hypr-user.lua  (optional, never overwritten)

Commands:
  pulse
  pulse start
  pulse doctor
  pulse update
  pulse fix

Log out and back in after installation so the new PATH is loaded.
EOF
