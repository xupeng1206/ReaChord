--@noindex
--NoIndex: true


local r = reaper
print = r.ShowConsoleMsg

-- ReaChord Reader
cmd_id_1 = r.NamedCommandLookup('_RSad9c0796b8fa7aa904e091a76bc2d78b3cf6dfe3')
cmd_state_1 = r.GetToggleCommandStateEx(0, cmd_id_1)
if cmd_state_1 ~= 1 then
   r.Main_OnCommand(cmd_id_1, 0)
end

-- ReaChord NoteReader
cmd_id_2 = r.NamedCommandLookup('_RS841bff5cc0311b6b9d200933d38aaafa5c089e1b')
cmd_state_2 = r.GetToggleCommandStateEx(0, cmd_id_2)
if cmd_state_2 ~= 1 then
   r.Main_OnCommand(cmd_id_2, 0)
end