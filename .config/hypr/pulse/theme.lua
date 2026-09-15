-- Pulse Ghost palette. Intentionally monochrome.
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

M.rgb = function(hex)
    return "rgb(" .. hex .. ")"
end

M.rgba = function(hex, alpha)
    return "rgba(" .. hex .. alpha .. ")"
end

return M
