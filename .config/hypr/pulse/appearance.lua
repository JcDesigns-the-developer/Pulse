local theme = require("pulse.theme")

-- Window appearance. Keep colors here tied to the Pulse palette.
hl.config({
    decoration = {
        rounding = 7,
        rounding_power = 2,
        active_opacity = 0.98,
        inactive_opacity = 0.90,
        fullscreen_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 8,
            render_power = 3,
            color = tonumber("0x" .. theme.black_deep .. "cc"),
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 2,
            new_optimizations = true,
        },
    },

    general = {
        col = {
            active_border = theme.rgba(theme.white, "ee"),
            inactive_border = theme.rgba(theme.gray_dark, "aa"),
        },
    },
})
