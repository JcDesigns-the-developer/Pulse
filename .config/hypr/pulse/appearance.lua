local theme = require("pulse.theme")

hl.config({
    decoration = {
        rounding = 7,
        rounding_power = 2,
        active_opacity = 0.98,
        inactive_opacity = 0.90,
        fullscreen_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 10,
            render_power = 2,
            color = tonumber("0x" .. theme.black_deep .. "dd"),
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 2,
            vibrancy = 0,
        },
    },
    general = {
        col = {
            active_border = {
                colors = { theme.rgba(theme.white, "ee") },
                angle = 45,
            },
            inactive_border = theme.rgba(theme.gray_dark, "aa"),
        },
    },
})
