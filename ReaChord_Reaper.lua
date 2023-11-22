--@noindex
--NoIndex: true

local r = reaper
print = r.ShowConsoleMsg

R_ChordTrackName = "REACHORD_TRACK"
R_ChordTrackMidi = "REACHORD_MIDI"

R_BankPath = r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Banks.txt'

function NewLineTag()
    return "\r\n"
    -- if package.config:sub(1, 1) == "/" then
    --     -- mac or linux?
    --     return "\n"
    -- else
    --     return "\r\n"
    -- end
end

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

function GetTrackByName(name)
    local targeTrack
    for trackIndex = 0, r.CountTracks(0) - 1 do
        local track = r.GetTrack(0, trackIndex)
        local ok, trackName = r.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
        if ok and trackName == name then
            targeTrack = track
            break
        end
    end
    return targeTrack
end

function GetLengthForOneBeat()
    local bpm_base, _ = r.GetProjectTimeSignature(0)
    local bpm_now = bpm_base
    tempoIdx = r.FindTempoTimeSigMarker(0, r.GetCursorPosition())
    if tempoIdx > -1 then
        _, _, _, _, bpm_now, _, _, _ = r.GetTempoTimeSigMarker(0, tempoIdx)
    end
    local duration = r.TimeMap2_QNToTime(0, 1) * bpm_base / bpm_now
    return duration
end

function R_DeleteFirstSelectChordItem()
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = GetOrCreateTrackByName(R_ChordTrackMidi)
    local item_count = r.CountTrackMediaItems(midi_track)
    local deleted = false
    local position = -1
    local length = -1
    local beat = -1
    for idx = 0, item_count - 1 do
        local midi_item = r.GetTrackMediaItem(midi_track, idx)
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        if r.IsMediaItemSelected(midi_item) then
            deleted = true
            position = r.GetMediaItemInfo_Value(midi_item, "D_POSITION")
            length = r.GetMediaItemInfo_Value(midi_item, "D_LENGTH")

            local midi_take = r.GetActiveTake(midi_item)
            local _, full_meta = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", "", false)
            local full_meta_split = StringSplit(full_meta, "|")
            beats = tonumber(full_meta_split[4])

            r.DeleteTrackMediaItem(midi_track, midi_item)
            r.DeleteTrackMediaItem(chord_track, chord_item)
            break
        end
    end
    return deleted, position, length, beats
end

function R_InsertChordItem(chord, meta, notes, beats)
    local full_split = StringSplit(chord, "/")
    local scale_root = StringSplit(meta, "/")[1]
    local _, chord_pattern = T_SplitChordRootAndPattern(full_split[1])
    local s_chord = T_NoteName2Num(notes[2], scale_root) .. "'" .. chord_pattern
    if #full_split == 2 then
        local s_bass = T_NoteName2Num(notes[1], scale_root)
        s_chord = s_chord .. "/" .. s_bass .. "'"
    end

    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = GetOrCreateTrackByName(R_ChordTrackMidi)

    local deleted, d_position, d_length, d_beats = R_DeleteFirstSelectChordItem()

    r.SelectAllMediaItems(0, false)

    local item_length = -1
    local start_position = -1
    local end_position = -1

    if deleted then
        -- replace the select item
        item_length = d_length
        start_position = d_position
        end_position = start_position + item_length
        -- use the delete beats
        beats = d_beats
    else
        -- insert item at cursor
        item_length = GetLengthForOneBeat() * beats
        start_position = r.GetCursorPosition()
        end_position = start_position + item_length
    end

    -- chord item
    local chord_item = r.AddMediaItemToTrack(chord_track)
    r.SetMediaItemPosition(chord_item, start_position, false)
    r.SetMediaItemLength(chord_item, item_length, true)
    r.ULT_SetMediaItemNote(chord_item, chord .. NewLineTag() .. s_chord)
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
            0, note + 36 + oct * 12, 90, false
        )
    end
    local note_str = ListJoinToString(notes, ",")
    local full_meta = ListJoinToString({ meta, note_str, chord, beats }, "|")
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
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    local chord = ""
    local meta = ""
    local beats = 0
    local notes = {}
    local selectIdx = -1
    for idx = 0, chord_item_count - 1 do
        local item = r.GetTrackMediaItem(chord_track, idx)
        if r.IsMediaItemSelected(item) then
            chord = r.ULT_GetMediaItemNote(item)
            chord = StringSplit(chord, NewLineTag())[1]
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
        beats = tonumber(full_meta_split[4])
        notes = StringSplit(full_meta_split[2], ",")
    end
    return chord, meta, notes, beats
end

function R_SelectChordItems()
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = GetOrCreateTrackByName(R_ChordTrackMidi)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    local chords = {}
    local found = "false"
    for idx = 0, chord_item_count - 1 do
        local item = r.GetTrackMediaItem(chord_track, idx)
        if r.IsMediaItemSelected(item) then
            found = "true"
            local midi_item = r.GetTrackMediaItem(midi_track, idx)
            local midi_take = r.GetActiveTake(midi_item)
            local _, full_meta = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", "", false)
            table.insert(chords, full_meta)
        else
            if found == "true" then
                break
            end
        end
    end
    local ret = ListJoinToString(chords, "~")
    return ret
end

function R_ChordItemTrans(diff)
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = GetOrCreateTrackByName(R_ChordTrackMidi)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        if r.IsMediaItemSelected(chord_item) then
            local chord = r.ULT_GetMediaItemNote(chord_item)
            local chord_s = StringSplit(chord, NewLineTag())
            chord = chord_s[1]
            local s_chord = chord_s[2]
            local midi_item = r.GetTrackMediaItem(midi_track, idx)
            local midi_take = r.GetActiveTake(midi_item)
            local _, full_meta = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", "", false)
            local full_meta_split = StringSplit(full_meta, "|")
            local meta = full_meta_split[1]
            local notes = StringSplit(full_meta_split[2], ",")
            local beats = full_meta_split[4]
            local pure_voicing = {}
            for idx, v in ipairs(notes) do
                if idx > 1 then
                    table.insert(pure_voicing, v)
                end
            end
            local meta_split = StringSplit(meta, "/")
            local scale_root = meta_split[1]
            local scale_name = meta_split[2]
            local oct = meta_split[3]
            local chord_split = StringSplit(chord, "/")
            local new_chord = ''
            local new_pure_chord = ''
            local new_chord_bass = ''
            if #chord_split == 1 then
                new_chord = T_ChordTrans(chord, scale_root .. "/" .. scale_name, diff)
                new_pure_chord = new_chord
                new_chord_bass = string.sub(new_chord, 1, 1)
                if string.sub(new_chord, 2, 2) == "#" or string.sub(new_chord, 2, 2) == "b" then
                    new_chord_bass = string.sub(new_chord, 1, 2)
                end
            else
                new_pure_chord = T_ChordTrans(chord_split[1], scale_root .. "/" .. scale_name, diff)
                new_chord_bass = T_NoteTrans(chord_split[2], scale_root .. "/" .. scale_name, diff)
                new_chord = new_pure_chord .. "/" .. new_chord_bass
            end
            local new_scale = T_ScaleTrans(scale_root .. "/" .. scale_name, diff)
            local new_pure_voicing = T_VoicingTrans(new_pure_chord, pure_voicing, diff)
            local new_full_meta = new_scale ..
            "/" .. oct .. "|" ..
            new_chord_bass .. "," .. ListJoinToString(new_pure_voicing, ",") .. "|" .. new_chord .. "|" .. beats

            local _, notecnt, _, _ = r.MIDI_CountEvts(midi_take)
            for idx = 0, notecnt - 1 do
                local _, selected, muted, startppqpos, endppqpos, chan, pitch, vel = r.MIDI_GetNote(midi_take, idx)
                r.MIDI_SetNote(midi_take, idx, selected, muted, startppqpos, endppqpos, chan, pitch + diff, vel, false)
            end
            r.ULT_SetMediaItemNote(chord_item, new_chord .. NewLineTag() .. s_chord)
            _, _ = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", new_full_meta, true)
        end
    end
end

function R_ChordItemRefresh()
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = GetOrCreateTrackByName(R_ChordTrackMidi)
    local chord_item_count = r.CountTrackMediaItems(midi_track)
    local chord_lst = {}
    for _ = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, 0)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        table.insert(chord_lst, chord)
        r.DeleteTrackMediaItem(chord_track, chord_item)
    end
    for idx = 0, chord_item_count - 1 do
        local midi_item = r.GetTrackMediaItem(midi_track, idx)
        local pos = r.GetMediaItemInfo_Value(midi_item, "D_POSITION")
        local len = r.GetMediaItemInfo_Value(midi_item, "D_LENGTH")
        local beats = len / GetLengthForOneBeat()
        local midi_take = r.GetActiveTake(midi_item)
        local _, full_meta = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", "", false)
        local full_meta_split = StringSplit(full_meta, "|")
        full_meta_split[4] = tostring(beats)
        local new_full_meta = ListJoinToString(full_meta_split, "|")
        _, _ = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", new_full_meta, true)

        local chord_item = r.AddMediaItemToTrack(chord_track)
        r.SetMediaItemPosition(chord_item, pos, false)
        r.SetMediaItemLength(chord_item, len, true)
        r.ULT_SetMediaItemNote(chord_item, chord_lst[idx + 1])
        r.SetMediaItemSelected(chord_item, true)

        r.SetMediaItemSelected(midi_item, true)
        -- group item
        r.Main_OnCommand(40032, 0)
        -- unselect
        r.SetMediaItemSelected(chord_item, false)
        r.SetMediaItemSelected(midi_item, false)
    end
end

function R_DeleteMarkerByName(target)
    local project = r.EnumProjects(0)
    local count = r.CountProjectMarkers(project)
    for j = 0, count - 1 do
        local _, _, _, _, name, idx, _ = r.EnumProjectMarkers3(project, j)
        if name == target then
            r.DeleteProjectMarker(project, idx, false)
        end
    end
end

function R_DeleteRegionByName(target)
    local project = r.EnumProjects(0)
    local count = r.CountProjectMarkers(project)
    for j = 0, count - 1 do
        local _, _, _, _, name, idx, _ = r.EnumProjectMarkers3(project, j)
        if name == target then
            r.DeleteProjectMarker(project, idx, true)
        end
    end
end

function R_ChordItem2Marker()
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        chord = StringSplit(chord, NewLineTag())[1]
        local pos = r.GetMediaItemInfo_Value(chord_item, "D_POSITION")
        local len = r.GetMediaItemInfo_Value(chord_item, "D_LENGTH")
        r.AddProjectMarker(0, false, pos, pos + len, chord, -1)
    end
end

function R_DeleteAllChordMarker()
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        chord = StringSplit(chord, NewLineTag())[1]
        R_DeleteMarkerByName(chord)
    end
end

function R_ChordItem2Region()
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        chord = StringSplit(chord, NewLineTag())[1]
        local pos = r.GetMediaItemInfo_Value(chord_item, "D_POSITION")
        local len = r.GetMediaItemInfo_Value(chord_item, "D_LENGTH")
        r.AddProjectMarker(0, true, pos, pos + len, chord, -1)
    end
end

function R_DeleteAllChordRegion()
    local chord_track = GetOrCreateTrackByName(R_ChordTrackName)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        chord = StringSplit(chord, NewLineTag())[1]
        R_DeleteRegionByName(chord)
    end
end

function R_GetChordItemInfoByPosition(position)
    local chord_track = GetTrackByName(R_ChordTrackName)
    if chord_track == nil then
        return false, 0, 0, ""
    end
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord_item_start = r.GetMediaItemInfo_Value(chord_item, "D_POSITION")
        local chord_item_end = chord_item_start + r.GetMediaItemInfo_Value(chord_item, "D_LENGTH")
        if position >= chord_item_start and position <= chord_item_end then
            local chord = r.ULT_GetMediaItemNote(chord_item)
            return true, chord_item_start, chord_item_end, chord
        end
    end
    return false, 0, 0, ""
end

function R_ArmOnlyChordTrack()
    r.ClearAllRecArmed()
    local chord_track = GetTrackByName(R_ChordTrackName)
    if chord_track == nil then
        return
    end

    local arm = r.GetMediaTrackInfo_Value(chord_track,'I_RECARM');
    if arm ~= 1 then;
        r.SetMediaTrackInfo_Value(chord_track,'I_RECARM',1);
    end
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
    for note = 0, 127 do
        r.StuffMIDIMessage(keyboard_mode, note_off, note, velocity)
    end
end

function R_ReadBankFile()
    local banks = {}
    for bk in io.lines(R_BankPath) do
        table.insert(banks, bk)
    end
    return banks
end

function R_SaveBank(bk)
    local file = io.open(R_BankPath, 'a+')
    if file then
        io.output(file)
        io.write(bk, '\n')
        io.close()
    end
end

function R_RefreshBank(bks)
    local file = io.open(R_BankPath, 'w+')
    if file then
        io.output(file)
        for idx, bk in ipairs(bks) do
            io.write(bk, '\n')
        end
        io.close()
    end
end
