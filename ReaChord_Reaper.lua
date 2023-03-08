dofile(reaper.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')

R_ChordTrackName = "__CHORD_TRACK__"
R_ChordTrackMeta = "__CHORD_META__"
R_ChordTrackMidi = "__CHORD_MIDI__"

function GetOrCreateTrackByName(name)
    local targeTrack
    for trackIndex = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, trackIndex)
        local ok, trackName = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
        if ok and trackName == name then
            targeTrack = track
            break
        end
    end
    if targeTrack == nil then
        reaper.InsertTrackAtIndex(0, true)
        local newTrack = reaper.GetTrack(0, 0)
        _, _ = reaper.GetSetMediaTrackInfo_String(newTrack, "P_NAME", name, true)
        targeTrack = newTrack
    end
    return targeTrack
end

function GetLengthForOneBar()
    local _, bpi = reaper.GetProjectTimeSignature2(0)
    local duration = reaper.TimeMap2_QNToTime(0, bpi)
    return duration
end

function G_InsertChordItem(chord, meta, notes)
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local meta_track = GetOrCreateTrackByName(R_ChordTrackMeta)
    local midi_track = GetOrCreateTrackByName(R_ChordTrackMidi)
    local start_position = reaper.GetCursorPosition()
    local end_position = start_position + GetLengthForOneBar()
    -- chord item
    local chord_item = reaper.AddMediaItemToTrack(chord_track)
    reaper.SetMediaItemPosition(chord_item, start_position, false)
    reaper.SetMediaItemLength(chord_item, GetLengthForOneBar(), true)
    reaper.ULT_SetMediaItemNote(chord_item, chord)
    -- meta item
    local meta_item = reaper.AddMediaItemToTrack(meta_track)
    reaper.SetMediaItemPosition(meta_item, start_position, false)
    reaper.SetMediaItemLength(meta_item, GetLengthForOneBar(), true)
    local note_str = ListJoinToString(notes, ",")
    local full_meta = ListJoinToString({meta, note_str}, "/")
    reaper.ULT_SetMediaItemNote(meta_item, full_meta)
    -- midi item
    local midi_item = reaper.CreateNewMIDIItemInProj(midi_track, start_position, end_position, false)
    -- midi take
    local midi_take = reaper.GetActiveTake(midi_item)
    for _, note in ipairs(notes) do
        reaper.MIDI_InsertNote(
            midi_take, false, false,
            reaper.MIDI_GetPPQPosFromProjTime(midi_take, start_position),
            reaper.MIDI_GetPPQPosFromProjTime(midi_take, end_position),
            0, note, 90, false
        )
    end
    reaper.SetEditCurPos(end_position, true, true)
end

G_InsertChordItem("C", "sdag2fsa", {1,2,3})