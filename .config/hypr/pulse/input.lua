-- Input policy. Keep keyboard/mouse behavior separate from compositor styling.

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
        },
    },

    binds = {
        drag_threshold = 10,
    },
})
