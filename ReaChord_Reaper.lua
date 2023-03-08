r = reaper
print = r.ShowConsoleMsg

dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Theory.lua')

R_ChordTrackName = "__REACHORD_TRACK__"
R_ChordTrackMidi = "__REACHORD_MIDI__"

function GetOrCreateTrackByName(name)
    local targeTrack
    for trackIndex = 0, r.CountTracks(0) - 1 do
        local track = r.GetTrack(0, trackIndex)
        local ok, trackName = r.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
        if ok and trackName == name then
            targeTrack = track
            break
        end
    end
    if targeTrack == nil then
        r.InsertTrackAtIndex(0, true)
        local newTrack = r.GetTrack(0, 0)
        _, _ = r.GetSetMediaTrackInfo_String(newTrack, "P_NAME", name, true)
        targeTrack = newTrack
    end
    return targeTrack
end

function GetLengthForOneBar()
    local _, bpi = r.GetProjectTimeSignature2(0)
    local duration = r.TimeMap2_QNToTime(0, bpi)
    return duration
end

function R_InsertChordItem(chord, meta, notes)
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = GetOrCreateTrackByName(R_ChordTrackMidi)
    local start_position = r.GetCursorPosition()
    local end_position = start_position + GetLengthForOneBar()
    -- chord item
    local chord_item = r.AddMediaItemToTrack(chord_track)
    r.SetMediaItemPosition(chord_item, start_position, false)
    r.SetMediaItemLength(chord_item, GetLengthForOneBar(), true)
    r.ULT_SetMediaItemNote(chord_item, chord)
    r.SetMediaItemSelected(chord_item, true)
    -- midi item
    local midi_item = r.CreateNewMIDIItemInProj(midi_track, start_position, end_position, false)
    -- midi take
    local midi_take = r.GetActiveTake(midi_item)
    local _, note_midi_index = T_NotePitched(notes)
    local oct = StringSplit(meta, "/")[3]
    for _, note in ipairs(note_midi_index) do
        r.MIDI_InsertNote(
            midi_take, false, false,
            r.MIDI_GetPPQPosFromProjTime(midi_take, start_position),
            r.MIDI_GetPPQPosFromProjTime(midi_take, end_position),
            0, note+36+oct*12, 90, false
        )
    end
    local note_str = ListJoinToString(notes, ",")
    local full_meta = ListJoinToString({meta, note_str}, "|")
    _, _ = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", full_meta, true)
    r.SetMediaItemSelected(midi_item, true)
    -- group item
    r.Main_OnCommand(40032, 0)
    -- unselect
    r.SetMediaItemSelected(chord_item, false)
    r.SetMediaItemSelected(midi_item, false)
    -- move cursor
    r.SetEditCurPos(end_position, true, true)
end

function R_SelectChordItem()
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = GetOrCreateTrackByName(R_ChordTrackMidi)
    local chord_item_count =  r.CountTrackMediaItems(midi_track)
    local chord = ""
    local meta = ""
    local notes = {}
    local selectIdx = -1
    for idx = 0, chord_item_count - 1 do
        local item = r.GetTrackMediaItem(chord_track, idx)
        if r.IsMediaItemSelected(item) then
            chord = r.ULT_GetMediaItemNote(item)
            selectIdx = idx
            break
        end
    end
    if selectIdx > -1 then
        local midi_item = r.GetTrackMediaItem(midi_track, selectIdx)
        local midi_take = r.GetActiveTake(midi_item)
        local _, full_meta = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", "", false)
        local full_meta_split = StringSplit(full_meta, "|")
        meta = full_meta_split[1]
        notes = StringSplit(full_meta_split[2], ",")
    end
    return chord, meta, notes
end

function R_Play(notes)
    -- virtualKeyboardMode
    local keyboard_mode = 0  
    local channel = 0
    local note_on = 0x90 + channel
    local velocity = 90
    for _, note in ipairs(notes) do
        r.StuffMIDIMessage(keyboard_mode, note_on, note, velocity)
    end
end

function R_StopPlay()
    -- virtualKeyboardMode
    local keyboard_mode = 0  
    local channel = 0
    local note_off = 0x80 + channel
    local velocity = 0
    for note=0, 127 do
        r.StuffMIDIMessage(keyboard_mode, note_off, note, velocity)
    end
end