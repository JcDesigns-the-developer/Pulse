-- Persistent workspace policy. Monitor names are intentionally omitted so
-- Pulse remains usable on laptops, desktops, and VMware guests.
for workspace = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(workspace),
        persistent = true,
    })
end
