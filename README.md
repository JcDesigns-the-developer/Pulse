# Pulse

A complete, desktop-first Hyprland environment by **JcDesigns**.

Pulse is built to feel like an actual operating-system desktop instead of a pile of disconnected dotfiles. It combines Hyprland, Waybar, Rofi, Kitty, Mako, Hyprlock, Hypridle, GTK/Qt integration, wallpapers, shell tools, diagnostics, and an updater into one manageable installation.

The architecture is inspired by the useful parts of projects such as Hyprland Material You and Spelljinxer's dotfiles: a clean component layout, a dedicated control layer, and a session that can be maintained as one desktop. Pulse keeps its own black/red, practical, classic/hacker-desktop identity rather than copying their visual styles.

## What Pulse includes

- Hyprland desktop configuration
- Waybar panel
- Rofi application launcher/control menu
- Kitty terminal
- Mako notifications
- Hyprlock + Hypridle
- PipeWire / WirePlumber audio
- NetworkManager
- Screenshots, clipboard, wallpapers, brightness and media helpers
- Pulse session launcher
- Pulse settings/control panel
- Pulse Doctor diagnostics
- Safe Git-based updates
- Repair mode for older/broken installations
- A Wayland session entry for display managers

## Install

On Arch Linux / EndeavourOS:

```bash
git clone https://github.com/JcDesigns-the-developer/Pulse.git
cd Pulse
chmod +x install.sh
./install.sh
```

Log out and back in after installation. You can then select **Pulse** from a display manager, or start it from a TTY with:

```bash
pulse-session
```

Do **not** run Hyprland with `sudo`.

## Pulse command

Pulse now has one main control command:

```text
pulse
pulse start
pulse update
pulse fix
pulse fix/update
pulse settings
pulse wallpaper
pulse screenshot
pulse doctor
pulse version
```

Useful aliases:

```bash
pulse -u       # update
pulse -f       # repair
pulse -fu      # update + repair
```

### Doctor

Run:

```bash
pulse doctor
```

It checks the core desktop commands, managed configuration, session environment, update timer, and known stale Hyprland configuration problems.

### Repairing an old installation

If an older Pulse install has stale files or a broken configuration:

```bash
pulse fix/update
```

This updates the local Pulse checkout using a fast-forward-only Git update, creates a timestamped backup of the live Pulse-managed configuration, and then refreshes the managed files from the current `main` branch.

Local changes inside the Pulse Git checkout are never automatically destroyed.

## Automatic updates

Pulse installs a user systemd timer that checks the repository every 30 minutes. Updates only move the checkout forward when the local repository is clean and the remote `main` branch is a descendant of the local commit.

Update log:

```text
~/.local/state/pulse/update.log
```

Manual update:

```bash
pulse update
```

## Repository layout

```text
Pulse/
├── install.sh
├── packages.txt
├── session/
│   └── pulse.desktop
├── .config/
│   ├── hypr/
│   ├── waybar/
│   ├── rofi/
│   ├── kitty/
│   ├── mako/
│   ├── hyprlock/
│   ├── hypridle/
│   └── ...
└── local/bin/
    ├── pulse
    ├── pulse-session
    ├── pulse-start
    ├── pulse-menu
    ├── pulse-settings
    ├── pulse-doctor
    ├── pulse-fix
    ├── pulse-update
    ├── pulse-wallpaper
    └── pulse-screenshot
```

## Design philosophy

Pulse is intentionally **not** a Material You clone and not a generic modern rice.

The target is a recognizable JcDesigns desktop: dark, black/red, compact, sharp, practical, keyboard-friendly, and closer to a real classic desktop environment than a showcase screenshot.

## License

MIT. Wallpaper assets, fonts, and third-party software remain under their respective licenses.
