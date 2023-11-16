--[[
 * ReaScript Name: ReaChord Reader
 * Instructions:  Chord Track Kit
 * Author: xupeng
 * Author URI: https://github.com/xupeng1206
 * REAPER: 7.0
 * Version: v1.0.10
 * Description: Chord Track Kit
 * Donation: https://www.paypal.com/paypalme/xupeng1206
--]]

--[[
 * Changelog:
 * v1.0.10 (2023-11-16)
  + Update
--]]

local r = reaper
print = r.ShowConsoleMsg

-- ReaChord Reader
cmd_id = r.NamedCommandLookup('_RSad9c0796b8fa7aa904e091a76bc2d78b3cf6dfe3')
cmd_state = r.GetToggleCommandStateEx(0, cmd_id)
if cmd_state ~= 1 then
   r.Main_OnCommand(cmd_id, 0)
end
