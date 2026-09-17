-- Core Hyprland settings.

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        resize_on_border = true,
        allow_tearing = false,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        focus_on_activate = true,
    },

    cursor = {
        hide_on_key_press = true,
        inactive_timeout = 5,
    },

    xwayland = {
        enabled = true,
    },
})
