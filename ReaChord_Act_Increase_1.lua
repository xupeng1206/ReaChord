r = reaper
print = r.ShowConsoleMsg
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Reaper.lua')

local function trans()
    R_ChordItemTrans(-1)    
end

r.defer(trans)