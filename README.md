# Pulse Ghost

A practical, readable Hyprland desktop by **JcDesigns**.

Pulse is a normal dotfiles repository first. The installer, update tools, and diagnostics exist to make the dots easy to install and maintain; they do not replace the underlying configuration language.

> **Black. White. Anime ghost.**

## Layout

```text
Pulse/
├── .config/
│   ├── hypr/
│   │   ├── hyprland.lua          # entry point
│   │   ├── variables.lua          # user-facing defaults
│   │   ├── environment.lua
│   │   ├── general.lua
│   │   ├── monitors.lua
│   │   ├── input.lua
│   │   ├── layout.lua
│   │   ├── decoration.lua
│   │   ├── animations.lua
│   │   ├── rules.lua
│   │   ├── workspaces.lua
│   │   ├── keybinds.lua
│   │   ├── startup.lua
│   │   ├── hypridle.conf
│   │   ├── hyprlock.conf
│   │   ├── scripts/
│   │   └── wallpapers/
│   ├── waybar/
│   ├── rofi/
│   ├── kitty/
│   ├── mako/
│   └── ...
├── local/bin/                     # Pulse commands
├── packages.txt
├── install.sh
├── uninstall.sh
└── session/
```

There is deliberately **no Pulse Lua framework or module API**. Hyprland's Lua API is the configuration API.

## Customize

The normal defaults are visible in:

```text
~/.config/hypr/variables.lua
```

For machine-specific changes, copy:

```text
.config/hypr/hypr-user.lua.example
```

to:

```text
~/.config/hypr/hypr-user.lua
```

Pulse never overwrites `hypr-user.lua`.

For example, a monitor override is just normal Hyprland Lua:

```lua
hl.monitor({
    output = "DP-1",
    mode = "1920x1080@165",
    position = "0x0",
    scale = 1,
})
```

## Install

Arch Linux / EndeavourOS:

```bash
git clone https://github.com/JcDesigns-the-developer/Pulse.git ~/Pulse
cd ~/Pulse
./install.sh
```

Preview the installation first:

```bash
./install.sh --dry-run
```

The installer:

- installs the package list
- backs up existing configuration
- symlinks `.config/*` into `~/.config`
- symlinks Pulse commands into `~/.local/bin`
- makes `~/.local/bin` persistent in the normal shell startup files
- installs the Pulse Wayland session
- enables the update timer

Because the installed files are symlinks, editing the repository immediately changes the active dotfiles. `git pull` updates them without a second copy step.

## Commands

```text
pulse                  Control center
pulse start            Start the desktop
pulse network          Network control
pulse settings         Settings
pulse wallpaper       Wallpaper
pulse screenshot       Screenshot
pulse update           Update Pulse
pulse fix              Repair Pulse
pulse fix/update       Update + repair
pulse doctor           Diagnostics
pulse version          Version
```

## Backups and uninstall

Pulse keeps installation backups under:

```text
~/.local/state/pulse/backups/
```

The installer only moves an existing target out of the way when it needs to create a Pulse link. It does not blindly delete unrelated configuration.

## Runtime

`XDG_RUNTIME_DIR` is supplied by systemd-logind. Pulse does not create or fake `/run/user/$UID`.

Do not run Hyprland with `sudo`.

## Components

- Hyprland 0.55+ Lua configuration
- Waybar
- Rofi
- Kitty
- Mako
- Hyprlock
- Hypridle
- PipeWire / WirePlumber
- NetworkManager
- Pulse wallpaper and screenshot helpers
- Pulse Doctor and update/repair commands

## Design goal

Pulse follows the useful parts of modern dotfile projects: a readable file layout, a repository as the source of truth, symlink-based updates, optional components, backups, and a straightforward installer.

The actual desktop configuration stays ordinary Hyprland configuration so users can open a file and understand what it does.

## License

MIT. Third-party software, fonts, and external artwork remain under their respective licenses.
