-- Window decoration and Pulse's monochrome palette.

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
            color = tonumber("0x" .. PULSE.colors.black_deep .. "cc"),
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
            active_border = {
                colors = { pulse_rgba(PULSE.colors.white, "ee") },
                angle = 45,
            },
            inactive_border = pulse_rgba(PULSE.colors.gray_dark, "aa"),
        },
    },
})
