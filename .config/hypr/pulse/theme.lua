-- Pulse Ghost palette.
-- One source of truth for the visual system: monochrome, high contrast,
-- and intentionally independent from wallpaper-generated color engines.

local M = {
    black = "0a0a0a",
    black_deep = "050505",
    white = "f5f5f5",
    gray = "b8b8b8",
    gray_dark = "242424",
    transparent = "00000000",
    active = "f5f5f5ee",
    inactive = "777777aa",
    panel = "090909e6",
}

-- Semantic aliases keep consumers independent from palette implementation.
M.background = M.black
M.background_deep = M.black_deep
M.foreground = M.white
M.muted = M.gray
M.border = M.white
M.border_inactive = M.inactive
M.panel_background = M.panel

function M.rgb(hex)
    return "rgb(" .. hex .. ")"
end

function M.rgba(hex, alpha)
    return "rgba(" .. hex .. alpha .. ")"
end

function M.color(name)
    local value = M[name]
    if not value then
        error("Pulse theme color does not exist: " .. tostring(name))
    end
    return M.rgb(value)
end

return M
