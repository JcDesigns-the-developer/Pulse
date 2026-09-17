-- Pulse animation policy.

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("pulseEase", {
    type = "bezier",
    points = {
        { 0.16, 1.0 },
        { 0.30, 1.0 },
    },
})

hl.animation({ leaf = "global", enabled = true, speed = 8, curve = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 5, curve = "pulseEase" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, curve = "pulseEase", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, curve = "pulseEase", style = "popin 85%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, curve = "pulseEase" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, curve = "pulseEase" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, curve = "pulseEase", style = "slide" })
