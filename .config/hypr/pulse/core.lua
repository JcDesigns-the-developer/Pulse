-- Pulse core compositor policy.
-- Keep this file limited to options that define how the compositor behaves.
-- Theme, input, layout, rules, binds, and startup live in their own modules.

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        vrr = 1,
        focus_on_activate = true,
    },

    cursor = {
        hide_on_key_press = true,
        inactive_timeout = 5,
    },

    dwindle = {
        pseudotile = true,
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    ecosystem = {
        enforce_permissions_check = true,
    },
})
