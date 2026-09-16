# Pulse Ghost

A full desktop-first Hyprland environment by **JcDesigns**.

Pulse is not meant to be a screenshot-only rice. It is a maintainable desktop layer built around the current Hyprland Lua configuration model, with Waybar, Rofi, Kitty, Mako, Hyprlock, Hypridle, PipeWire, NetworkManager/iwd, wallpapers, diagnostics, repair tools, and automatic updates.

The visual identity is deliberately simple:

> **Black. White. Anime ghost.**

No Material You rainbow palette. No generic gray template. No unnecessary UI clutter.

## Architecture

Pulse 3.x uses a small public Lua namespace instead of making `hyprland.lua` know the physical layout of every module.

```text
.config/hypr/
├── hyprland.lua                 # tiny entry point
├── custom.lua.example            # machine-local override template
├── hypridle.conf
├── hyprlock.conf
├── pulse/
│   ├── init.lua                  # Pulse namespace + lifecycle
│   ├── theme.lua                 # semantic visual tokens
│   ├── env.lua
│   ├── core.lua
│   ├── settings.lua
│   ├── apps.lua                  # application registry
│   ├── monitors.lua
│   ├── input.lua
│   ├── layout.lua
│   ├── appearance.lua
│   ├── animations.lua
│   ├── rules.lua
│   ├── workspaces.lua
│   ├── binds.lua
│   └── startup.lua
├── scripts/
└── wallpapers/
    └── pulse-ghost.svg
```

### Pulse API

The public namespace is intentionally shaped like a small framework:

```lua
local Pulse = require("pulse")

Pulse.bootstrap()

Pulse.command("SUPER + SHIFT + O", "your-command")
Pulse.monitor({ output = "DP-1", mode = "preferred" })
Pulse.config({ misc = { disable_hyprland_logo = true } })

local Theme = Pulse.load("theme")
local foreground = Theme.color("foreground")
```

`Pulse.bootstrap()` owns module order. Built-in modules load first, then `~/.config/hypr/custom.lua` is loaded as the machine-local override layer. Users therefore do not need to edit Pulse's core files for monitor, bind, or hardware-specific changes.

The underlying Hyprland Lua API is still exposed through `Pulse.hl` for features that Pulse has not wrapped yet.

## Desktop components

- Hyprland Lua configuration
- Pulse Lua API and module loader
- Waybar panel
- Rofi launcher/control center
- Kitty terminal
- Mako notifications
- Hyprlock + Hypridle
- PipeWire + WirePlumber
- NetworkManager + `iwctl`/iwd support
- Ghost wallpaper generation through ImageMagick + swww
- Screenshot and clipboard helpers
- Pulse settings
- Pulse Doctor
- Pulse repair/update system
- Wayland session entry

## Install

Arch Linux / EndeavourOS:

```bash
git clone https://github.com/JcDesigns-the-developer/Pulse.git
cd Pulse
chmod +x install.sh
./install.sh
```

Log out and back in after installation. Select **Pulse** in your display manager, or from a properly initialized systemd TTY:

```bash
pulse-session
```

**Never run Hyprland with `sudo`.**

`XDG_RUNTIME_DIR` is owned and created by systemd-logind. Pulse intentionally does not create or fake `/run/user/$UID`.

## Pulse commands

```text
pulse                  Control center
pulse start            Start the desktop
pulse network          Wi-Fi / network control
pulse settings         Settings
pulse wallpaper        Change Ghost wallpaper
pulse screenshot       Screenshot
pulse update           Update Pulse
pulse fix              Repair Pulse
pulse fix/update       Update + repair
pulse doctor           Diagnostics
pulse version          Version
```

Shortcuts:

```bash
pulse -u
pulse -f
pulse -fu
```

## Wi-Fi

Pulse uses NetworkManager as its primary backend and keeps `iwctl` available for systems using iwd directly.

Terminal:

```bash
nmcli device wifi list
nmcli device wifi connect "Your WiFi" password "Your Password"
```

Or:

```bash
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "Your WiFi"
```

The graphical Pulse network menu is:

```bash
pulse network
```

## Repair

For an older Pulse installation or a machine with stale configuration:

```bash
pulse fix/update
```

Pulse updates the Git checkout using fast-forward-only Git behavior, creates a timestamped backup of managed configuration, and refreshes the installed desktop files.

Local Git changes are never silently overwritten.

## Doctor

Run:

```bash
pulse doctor
```

Doctor checks:

- Hyprland and `start-hyprland`
- Waybar/Rofi/Kitty/Mako
- NetworkManager/iwd
- Lua configuration files, including the Pulse API
- Hypridle/Hyprlock
- Pulse theme/settings
- wallpaper assets
- XDG session state
- update timer
- known legacy Hyprland configuration problems

## Automatic updates

Pulse installs a user systemd timer that checks the GitHub `main` branch every 30 minutes.

```text
~/.local/state/pulse/update.log
```

The updater refuses to overwrite local Git changes or merge divergent history automatically.

## Design

Pulse Ghost is intentionally:

- black and white
- anime-ghost themed
- compact
- sharp
- slightly creepy
- practical
- keyboard friendly
- transparent where useful
- closer to a real desktop than a showcase rice

The architecture is informed by patterns found across modern Hyprland configuration projects, while Pulse keeps its own implementation and visual identity.

## License

MIT. Third-party software, fonts, and any future external artwork remain under their respective licenses.
