-- Keep ten workspaces available on any monitor layout.

for workspace = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(workspace),
        persistent = true,
    })
end
