-- Pulse Ghost desktop API / module loader.
--
-- Pulse modules intentionally remain small and side-effect based: each module
-- applies one compositor concern when loaded. This file is the stable namespace
-- and lifecycle entry point so the rest of Pulse does not need to know the
-- physical module layout.

local Pulse = {
    version = "3.0.0",
    name = "Pulse Ghost",
    modules = {
        "theme",
        "env",
        "core",
        "settings",
        "monitors",
        "input",
        "layout",
        "appearance",
        "animations",
        "rules",
        "workspaces",
        "binds",
        "startup",
    },
}

function Pulse.load(name)
    local ok, module = pcall(require, "pulse." .. name)
    if not ok then
        error("Pulse failed to load module '" .. name .. "': " .. tostring(module))
    end
    return module
end

function Pulse.bootstrap()
    for _, name in ipairs(Pulse.modules) do
        Pulse.load(name)
    end

    -- Machine-local configuration is deliberately last so it can override
    -- Pulse defaults without requiring users to edit the distribution.
    local ok, err = pcall(require, "custom")
    if not ok and err and not tostring(err):match("module 'custom' not found") then
        io.stderr:write("Pulse custom config failed: " .. tostring(err) .. "\n")
    end
end

-- Small, stable helpers for custom.lua and future Pulse modules.
Pulse.hl = hl

function Pulse.exec(command)
    return hl.dsp.exec_cmd(command)
end

function Pulse.bind(key, action, options)
    return hl.bind(key, action, options or {})
end

function Pulse.command(key, command, options)
    return Pulse.bind(key, Pulse.exec(command), options)
end

function Pulse.config(values)
    return hl.config(values)
end

function Pulse.monitor(values)
    return hl.monitor(values)
end

function Pulse.window_rule(values)
    return hl.window_rule(values)
end

function Pulse.workspace(value)
    return hl.workspace(value)
end

return Pulse
