-- Pulse core compositor settings.
-- Keep only global behavior here. Input, layout, appearance, rules, binds,
-- and startup are configured in their own files.

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
        snap = {
            enabled = false,
        },
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        focus_on_activate = true,
        animate_manual_resizes = true,
        animate_mouse_windowdragging = true,
    },

    cursor = {
        hide_on_key_press = true,
        hide_on_touch = true,
        inactive_timeout = 5,
    },

    dwindle = {
        pseudotile = true,
        preserve_split = true,
        smart_split = true,
        smart_resizing = true,
    },

    xwayland = {
        enabled = true,
    },
})
