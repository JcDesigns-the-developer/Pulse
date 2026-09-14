# Pulse-Ware

A complete Hyprland desktop configuration by **JcDesigns**.

Pulse-Ware is designed as a cohesive daily-driver setup rather than a single `hyprland.conf`: Hyprland, Waybar, Rofi, Mako, Kitty, Hyprlock, Hypridle, GTK settings, wallpapers, shell helpers, and installation tooling are included.

## Stack

- Hyprland
- Waybar
- Rofi-Wayland
- Kitty
- Mako
- Hyprlock
- Hypridle
- SwayNC-compatible notification workflow
- PipeWire / WirePlumber
- NetworkManager
- grim + slurp + wl-clipboard
- playerctl
- brightnessctl
- cava
- fastfetch

## Install

On a fresh Arch/EndeavourOS install:

```bash
git clone https://github.com/JcDesigns-the-developer/Pulse.git
cd Pulse
chmod +x install.sh
./install.sh
```

Then log into the **Hyprland** session.

The installer backs up existing `~/.config/hypr`, `waybar`, `rofi`, `kitty`, `mako`, `hyprlock`, and `hypridle` directories before installing Pulse-Ware.

## Layout

```text
.config/
├── hypr/
│   ├── hyprland.conf
│   ├── monitors.conf
│   ├── keybinds.conf
│   ├── rules.conf
│   ├── startup.conf
│   ├── scripts/
│   └── wallpapers/
├── waybar/
├── rofi/
├── kitty/
├── mako/
├── hyprlock/
└── hypridle/

local/bin/
└── pulse-*
```

## Design

Pulse-Ware uses a dark black/red Pulse identity with restrained transparency, sharp borders, compact panels, and practical keyboard-first controls. It intentionally avoids a generic stock rice look.

## License

MIT. Wallpaper assets, fonts, and third-party software remain under their respective licenses.
