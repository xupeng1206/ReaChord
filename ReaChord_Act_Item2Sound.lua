--[[
 * ReaScript Name: ReaChord Item2Sound
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
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Reaper.lua')

local function item2sound()
    local chord, meta, notes, beats = R_SelectChordItem()
    if chord == "" then
      return
    else
        local oct = StringSplit(meta, "/")[3]
        local note_midi_index
        _, note_midi_index = T_NotePitched(notes)
        R_StopPlay()
        local midi_notes={}
        for _, midi_index in ipairs(note_midi_index) do
          table.insert(midi_notes, midi_index+36+oct*12)
        end
        R_Play(midi_notes)
    end
  end
  
  r.defer(item2sound)