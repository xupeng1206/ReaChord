--@noindex
--NoIndex: true

local r = reaper
print = r.ShowConsoleMsg

R_ChordTrackName = "REACHORD_TRACK"
R_ChordTrackMidi = "REACHORD_MIDI"

R_BankPath = r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Banks_v2.txt'
R_ColorConfPath = r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Colors.txt'

BASE_NOTE_OFFSET = 48

function NewLineTag()
    return "\r\n"
    -- if package.config:sub(1, 1) == "/" then
    --     -- mac or linux?
    --     return "\n"
    -- else
    --     return "\r\n"
    -- end
end

function R_ImportChordTrack()
    local targeTrack
    for trackIndex = 0, r.CountTracks(0) - 1 do
        local track = r.GetTrack(0, trackIndex)
        local ok, trackName = r.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
        if ok and trackName == R_ChordTrackName then
            targeTrack = track
            break
        end
    end
    if targeTrack == nil then
        r.Main_openProject(r.GetResourcePath().."/TrackTemplates/ChordTrack.RTrackTemplate")
    end
end

function R_GetOrCreateTrackByName(name)
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

function R_GetTrackByName(name)
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

function R_GetLengthForOneBeat()
    -- why?
    local timesig_num, timesig_denom, tempo = r.TimeMap_GetTimeSigAtTime(0, r.GetCursorPosition())
	local ratio = 4 / timesig_denom
	return 60 / tempo * ratio
end

function R_DeleteFirstSelectChordItem()
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)
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

function R_DeleteSelectChordItems()
    while true do
        local delete, _, _, _ = R_DeleteFirstSelectChordItem()
        if delete then
        else
            break
        end
    end
end


function R_CutAndSelectRightChordItem(start_pos)
    -- must be created
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)

    local chord_item_count = r.CountTrackMediaItems(chord_track)
    local midi_item_count = r.CountTrackMediaItems(midi_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord_item_start = r.GetMediaItemInfo_Value(chord_item, "D_POSITION")
        local chord_item_end = chord_item_start + r.GetMediaItemInfo_Value(chord_item, "D_LENGTH")
        if start_pos > chord_item_start and start_pos < chord_item_end then
            -- try to cut and select the right one
            r.SetMediaItemSelected(chord_item, true)
            r.SetEditCurPos(start_pos, true, true)
            r.Main_OnCommand(40759, 0)
        end
    end

    for idx = 0, midi_item_count - 1 do
        local midi_item = r.GetTrackMediaItem(midi_track, idx)
        local midi_item_start = r.GetMediaItemInfo_Value(midi_item, "D_POSITION")
        local midi_item_end = midi_item_start + r.GetMediaItemInfo_Value(midi_item, "D_LENGTH")
        if start_pos > midi_item_start and start_pos < midi_item_end then
            -- try to cut and select the right one
            r.SetMediaItemSelected(midi_item, true)
            r.SetEditCurPos(start_pos, true, true)
            r.Main_OnCommand(40759, 0)
        end
    end
end

function R_CutAndSelectLeftChordItem(end_pos)
    -- must be created
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)

    local chord_item_count = r.CountTrackMediaItems(chord_track)
    local midi_item_count = r.CountTrackMediaItems(midi_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord_item_start = r.GetMediaItemInfo_Value(chord_item, "D_POSITION")
        local chord_item_end = chord_item_start + r.GetMediaItemInfo_Value(chord_item, "D_LENGTH")
        if end_pos > chord_item_start and end_pos < chord_item_end then
            -- try to cut and select the left one
            r.SetMediaItemSelected(chord_item, true)
            r.SetEditCurPos(end_pos, true, true)
            r.Main_OnCommand(40758, 0)
        end
    end

    for idx = 0, midi_item_count - 1 do
        local midi_item = r.GetTrackMediaItem(midi_track, idx)
        local midi_item_start = r.GetMediaItemInfo_Value(midi_item, "D_POSITION")
        local midi_item_end = midi_item_start + r.GetMediaItemInfo_Value(midi_item, "D_LENGTH")
        if end_pos > midi_item_start and end_pos < midi_item_end then
            -- try to cut and select the left one
            r.SetMediaItemSelected(midi_item, true)
            r.SetEditCurPos(end_pos, true, true)
            r.Main_OnCommand(40758, 0)
        end
    end
end

function R_SelectAllChordItemBetweenStartEnd(start_pos, end_pos)
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)

    local chord_item_count = r.CountTrackMediaItems(chord_track)
    local midi_item_count = r.CountTrackMediaItems(midi_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord_item_start = r.GetMediaItemInfo_Value(chord_item, "D_POSITION")
        local chord_item_end = chord_item_start + r.GetMediaItemInfo_Value(chord_item, "D_LENGTH")
        if start_pos <= chord_item_start and chord_item_end <= end_pos then
            r.SetMediaItemSelected(chord_item, true)
        end
    end
    for idx = 0, midi_item_count - 1 do
        local midi_item = r.GetTrackMediaItem(midi_track, idx)
        local midi_item_start = r.GetMediaItemInfo_Value(midi_item, "D_POSITION")
        local midi_item_end = midi_item_start + r.GetMediaItemInfo_Value(midi_item, "D_LENGTH")
        if start_pos <= midi_item_start and midi_item_end <= end_pos then
            r.SetMediaItemSelected(midi_item, true)
        end
    end
end

function R_InsertChordItem(chord, meta, notes, beats, oct_shift_after_first_note)
    local full_split = StringSplit(chord, "/")
    local scale_root = StringSplit(meta, "/")[1]
    local _, chord_pattern = T_SplitChordRootAndPattern(full_split[1])
    local s_chord = T_NoteName2Num(notes[2], scale_root) .. "'" .. chord_pattern
    if #full_split == 2 then
        local s_bass = T_NoteName2Num(notes[1], scale_root)
        s_chord = s_chord .. "/" .. s_bass .. "'"
    end

    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)

    local deleted, d_position, d_length, d_beats = R_DeleteFirstSelectChordItem()

    r.SelectAllMediaItems(0, false)

    local item_length = -1
    local start_position = -1
    local end_position = -1
    local use_beats = -1

    if deleted then
        -- replace the select item
        item_length = d_length
        start_position = d_position
        end_position = start_position + item_length
        -- use the delete beats
        use_beats = d_beats
    else
        -- insert item at cursor
        use_beats = beats
        item_length = R_GetLengthForOneBeat() * use_beats
        start_position = r.GetCursorPosition()
        end_position = start_position + item_length

        -- try to cut the chord item overlap
        R_CutAndSelectRightChordItem(start_position)
        R_CutAndSelectLeftChordItem(end_position)
        R_SelectAllChordItemBetweenStartEnd(start_position, end_position)
        R_DeleteSelectChordItems()
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
    local _, note_midi_index = T_NotePitched(notes, oct_shift_after_first_note)
    local oct = StringSplit(meta, "/")[3]
    for _, note in ipairs(note_midi_index) do
        r.MIDI_InsertNote(
            midi_take, false, false,
            r.MIDI_GetPPQPosFromProjTime(midi_take, start_position),
            r.MIDI_GetPPQPosFromProjTime(midi_take, end_position),
            0, note + BASE_NOTE_OFFSET + oct * 12, 90, false
        )
    end
    local note_str = ListJoinToString(notes, ",")
    local full_meta = ListJoinToString({ meta, note_str, chord, use_beats, oct_shift_after_first_note }, "|")
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

function R_InsertChordItemWithPosition(chord, meta, notes, beats, oct_shift_after_first_note, start_position, end_position)
    local full_split = StringSplit(chord, "/")
    local scale_root = StringSplit(meta, "/")[1]
    local _, chord_pattern = T_SplitChordRootAndPattern(full_split[1])
    local s_chord = T_NoteName2Num(notes[2], scale_root) .. "'" .. chord_pattern
    if #full_split == 2 then
        local s_bass = T_NoteName2Num(notes[1], scale_root)
        s_chord = s_chord .. "/" .. s_bass .. "'"
    end

    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)

    r.SelectAllMediaItems(0, false)

    local item_length = end_position - start_position
    -- try to cut the chord item overlap
    R_CutAndSelectRightChordItem(start_position)
    R_CutAndSelectLeftChordItem(end_position)
    R_SelectAllChordItemBetweenStartEnd(start_position, end_position)
    R_DeleteSelectChordItems()

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
    local _, note_midi_index = T_NotePitched(notes, oct_shift_after_first_note)
    local oct = StringSplit(meta, "/")[3]
    for _, note in ipairs(note_midi_index) do
        r.MIDI_InsertNote(
            midi_take, false, false,
            r.MIDI_GetPPQPosFromProjTime(midi_take, start_position),
            r.MIDI_GetPPQPosFromProjTime(midi_take, end_position),
            0, note + 48 + oct * 12, 90, false
        )
    end
    local note_str = ListJoinToString(notes, ",")
    local full_meta = ListJoinToString({ meta, note_str, chord, beats, oct_shift_after_first_note }, "|")
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
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    local chord = ""
    local meta = ""
    local beats = 0
    local oct_shift_after_first_note = 0
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
        if #full_meta_split>4 then
            oct_shift_after_first_note = tonumber(full_meta_split[5])
        end
        notes = StringSplit(full_meta_split[2], ",")
    end
    return chord, meta, notes, beats, oct_shift_after_first_note
end

function R_SelectChordItems()
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)
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
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)
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
            local oct_shift_after_first_note = 0
            if #full_meta_split>4 then
                oct_shift_after_first_note = full_meta_split[5]
            end
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
            local new_full_meta = new_scale .. "/" .. oct .. "|" .. new_chord_bass .. "," .. ListJoinToString(new_pure_voicing, ",") .. "|" .. new_chord .. "|" .. beats .. "|" .. oct_shift_after_first_note

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
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    local midi_item_count = r.CountTrackMediaItems(midi_track)
    if chord_item_count ~= midi_item_count then
        print("chord track name item count and chord track midi item count mismatched.\n")
        return
    end
    local chord_lst = {}
    for _ = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, 0)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        table.insert(chord_lst, chord)
        r.DeleteTrackMediaItem(chord_track, chord_item)
    end
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        chord = StringSplit(chord, NewLineTag())[1]

        local midi_item = r.GetTrackMediaItem(midi_track, idx)
        local pos = r.GetMediaItemInfo_Value(midi_item, "D_POSITION")
        local len = r.GetMediaItemInfo_Value(midi_item, "D_LENGTH")
        local beats = len / R_GetLengthForOneBeat()
        local midi_take = r.GetActiveTake(midi_item)
        local _, full_meta = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", "", false)
        local full_meta_split = StringSplit(full_meta, "|")
        full_meta_split[4] = tostring(beats)
        local chord2 = full_meta_split[3]
        if chord ~= chord2 then
            print("chord track name item count and chord track midi item count mismatched. for chord: " .. chord .. "\n")
            return
        end
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

function R_ChordItemOverlap()
    -- todo
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local midi_track = R_GetOrCreateTrackByName(R_ChordTrackMidi)

    local chord_item_count = r.CountTrackMediaItems(chord_track)
    local midi_item_count = r.CountTrackMediaItems(midi_track)
    if chord_item_count ~= midi_item_count then
        print("chord track name item count and chord track midi item count mismatched.\n")
        return
    end
    local first_start_pos
    local params = {}
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        chord = StringSplit(chord, NewLineTag())[1]

        local midi_item = r.GetTrackMediaItem(midi_track, idx)
        local start_pos = r.GetMediaItemInfo_Value(midi_item, "D_POSITION")
        if first_start_pos == nil then
            first_start_pos = start_pos
        end
        local end_pos = start_pos
        if idx < chord_item_count - 1 then
            local next_midi_item = r.GetTrackMediaItem(midi_track, idx+1)
            end_pos = r.GetMediaItemInfo_Value(next_midi_item, "D_POSITION")
        else
            end_pos = start_pos + r.GetMediaItemInfo_Value(midi_item, "D_LENGTH")
        end

        local new_beats = (end_pos - start_pos) / R_GetLengthForOneBeat()

        local midi_take = r.GetActiveTake(midi_item)
        local _, full_meta = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", "", false)
        local full_meta_split = StringSplit(full_meta, "|")
        local meta = full_meta_split[1]
        local notes = StringSplit(full_meta_split[2], ',')
        local chord2 = full_meta_split[3]
        local oct_shift_after_first_note = full_meta_split[5]
        if chord ~= chord2 then
            print("chord track name item count and chord track midi item count mismatched. for chord: " .. chord .. "\n")
            return
        end
        local param = {
            chord = chord,
            meta = meta,
            notes = notes,
            beats = new_beats,
            oct_shift_after_first_note = oct_shift_after_first_note,
            start_pos = start_pos,
            end_pos = end_pos,
        }
        table.insert(params, param)
    end

    for _ = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, 0)
        r.DeleteTrackMediaItem(chord_track, chord_item)
        local midi_item = r.GetTrackMediaItem(midi_track, 0)
        r.DeleteTrackMediaItem(midi_track, midi_item)
    end
    for _, param in ipairs(params) do
        R_InsertChordItemWithPosition(param.chord, param.meta, param.notes, param.beats, param.oct_shift_after_first_note, param.start_pos, param.end_pos)
    end
end

function R_ChordItemOverlapAndRefresh()
    R_ChordItemOverlap()
    -- R_ChordItemRefresh()
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
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
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
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        chord = StringSplit(chord, NewLineTag())[1]
        R_DeleteMarkerByName(chord)
    end
end

function R_ChordItem2Region()
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
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
    local chord_track = R_GetOrCreateTrackByName(R_ChordTrackName)
    local chord_item_count = r.CountTrackMediaItems(chord_track)
    for idx = 0, chord_item_count - 1 do
        local chord_item = r.GetTrackMediaItem(chord_track, idx)
        local chord = r.ULT_GetMediaItemNote(chord_item)
        chord = StringSplit(chord, NewLineTag())[1]
        R_DeleteRegionByName(chord)
    end
end

function R_GetChordItemInfoByPosition(position)
    local chord_track = R_GetTrackByName(R_ChordTrackName)
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

function R_GetChordItemMeteByPosition(position)
    local midi_track = R_GetTrackByName(R_ChordTrackMidi)
    if midi_track == nil then
        return false, 0, 0, ""
    end
    local midi_item_count = r.CountTrackMediaItems(midi_track)
    for idx = 0, midi_item_count - 1 do
        local midi_item = r.GetTrackMediaItem(midi_track, idx)
        local midi_item_start = r.GetMediaItemInfo_Value(midi_item, "D_POSITION")
        local midi_item_end = midi_item_start + r.GetMediaItemInfo_Value(midi_item, "D_LENGTH")
        if position >= midi_item_start and position <= midi_item_end then
            -- todo
            local midi_take = r.GetActiveTake(midi_item)
            local _, full_meta = r.GetSetMediaItemTakeInfo_String(midi_take, "P_NAME", "", false)
            return true, midi_item_start, midi_item_end, full_meta
        end
    end
    return false, 0, 0, ""
end

function R_ArmOnlyChordTrack()
    r.ClearAllRecArmed()
    local chord_track = R_GetTrackByName(R_ChordTrackName)
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
    local file = assert(io.open(R_BankPath,'a+'))
    file:close()

    local banks = {}
    for bk in io.lines(R_BankPath) do
        if bk ~= "" then
            table.insert(banks, bk)
        end
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

function R_GetColorConf()
    local file = assert(io.open(R_ColorConfPath,'a+'))
    file:close()

    local colors = {}
    for color in io.lines(R_ColorConfPath) do
        local color_split = StringSplit(color, '=')
        colors[color_split[1]] = color_split[2]
    end
    return colors
end

function R_SaveColorConf(colors)
    local file = io.open(R_ColorConfPath, 'w+')
    if file then
        io.output(file)
        for color, value in pairs(colors) do
            local val = string.format("0x%08X", value)
            if #val == 18 then
                val = '0x' .. val:sub(11, 18)
            end
            io.write(color, '=', val, '\n')
        end
        io.close()
    end
end


-- Most Code From FTC Lil_ChordBox / Code Block Start
G_PREV_INPUT_INDEX = 0
G_INPUT_NOTE_MAP = {}
G_INPUT_NOTE_CNT = 0
G_INPUT_NOTE_MAP_NO_CC64 = {}
G_INPUT_NOTE_CNT_NO_CC64 = 0
G_INPUT_TRACK_NUMBER_NAME = ""
G_CC64_VALUE = 0


function R_GetMIDIInputNotes()
    local track = r.GetSelectedTrack(0, 0)
    if track == nil then
        track = R_GetTrackByName("R_ChordTrackName")
    end
    if track == nil then
        return {}
    end
    local _, track_name = r.GetSetMediaTrackInfo_String(track, 'P_NAME', '', false)
    local track_no = r.GetMediaTrackInfo_Value(track, 'IP_TRACKNUMBER')
    local track_no_name = tostring(track_no) .. "|" .. track_name
    if track_no_name ~= G_INPUT_TRACK_NUMBER_NAME then
        G_PREV_INPUT_INDEX = 0
        G_INPUT_NOTE_MAP = {}
        G_INPUT_NOTE_CNT = 0
        G_INPUT_NOTE_MAP_NO_CC64 = {}
        G_INPUT_NOTE_CNT_NO_CC64 = 0
        G_INPUT_TRACK_NUMBER_NAME = track_no_name
        G_CC64_VALUE = 0
    end
    local rec_in = r.GetMediaTrackInfo_Value(track, 'I_RECINPUT')
    local rec_arm = r.GetMediaTrackInfo_Value(track, 'I_RECARM')
    local is_recording_midi = rec_arm == 1 and rec_in & 4096 == 4096
    if not is_recording_midi then return {} end

    local filter_channel = rec_in & 31
    local filter_dev_id = (rec_in >> 5) & 127

    local idx, buf, _, dev_id = r.MIDI_GetRecentInputEvent(0)
    if idx > G_PREV_INPUT_INDEX then
        local new_idx = idx
        local i = 0
        repeat
            if G_PREV_INPUT_INDEX ~= 0 and #buf == 3 then
                if filter_dev_id == 63 or filter_dev_id == dev_id then
                    local msg1 = buf:byte(1)
                    local channel = (msg1 & 0x0F) + 1
                    if filter_channel == 0 or filter_channel == channel then
                        local msg2 = buf:byte(2)
                        local msg3 = buf:byte(3)
                        local is_note_on = msg1 & 0xF0 == 0x90
                        local is_note_off = msg1 & 0xF0 == 0x80
                        -- Check for CC64 (Sustain Pedal)
                        local is_cc = msg1 & 0xF0 == 0xB0
                        if is_cc and msg2 == 64 then
                            if msg3 > 100 or msg3 < 30 then
                                G_CC64_VALUE = msg3
                            end
                        end
                        -- Check for 0x90 note offs with 0 velocity
                        if is_note_on and msg3 == 0 then
                            is_note_on = false
                            is_note_off = true
                        end
                        if is_note_on and not G_INPUT_NOTE_MAP[msg2] then
                            G_INPUT_NOTE_MAP[msg2] = 1
                            G_INPUT_NOTE_CNT = G_INPUT_NOTE_CNT + 1
                        end
                        if is_note_on and not G_INPUT_NOTE_MAP_NO_CC64[msg2] then
                            G_INPUT_NOTE_MAP_NO_CC64[msg2] = 1
                            G_INPUT_NOTE_CNT_NO_CC64 = G_INPUT_NOTE_CNT_NO_CC64 + 1
                        end
                        if is_note_off and G_INPUT_NOTE_MAP[msg2] == 1 and G_CC64_VALUE <= 100 then
                            G_INPUT_NOTE_MAP[msg2] = nil
                            if G_INPUT_NOTE_CNT > 0 then
                                G_INPUT_NOTE_CNT = G_INPUT_NOTE_CNT - 1
                            end
                        end
                        if is_note_off and G_INPUT_NOTE_MAP_NO_CC64[msg2] == 1 then
                            G_INPUT_NOTE_MAP_NO_CC64[msg2] = nil
                            if G_INPUT_NOTE_CNT_NO_CC64 > 0 then
                                G_INPUT_NOTE_CNT_NO_CC64 = G_INPUT_NOTE_CNT_NO_CC64 - 1
                            end
                        end
                        if G_CC64_VALUE<=100 then
                            G_INPUT_NOTE_CNT = G_INPUT_NOTE_CNT_NO_CC64
                            G_INPUT_NOTE_MAP = {}
                            for n = 0, 127 do
                                if G_INPUT_NOTE_MAP_NO_CC64[n] == 1 then
                                    G_INPUT_NOTE_MAP[n] = 1
                                end
                            end
                        end
                    end
                end
            end
            i = i + 1
            idx, buf, _, dev_id = r.MIDI_GetRecentInputEvent(i)
        until idx == G_PREV_INPUT_INDEX

        G_PREV_INPUT_INDEX = new_idx
    end

    if G_INPUT_NOTE_CNT == 0 then
        return {}
    end

    if G_INPUT_NOTE_CNT >= 3 then
        local notes = {}
        for n = 0, 127 do
            if G_INPUT_NOTE_MAP[n] == 1 then
                table.insert(notes, n)
            end
        end
        return notes
    else
        return {}
    end
end

-- Most Code From FTC Lil_ChordBox / Code Block End

function R_FilterChordByBass(chords, details, bass_note)
    local ret_chords = {}
    local ret_details = {}
    for idx, _ in ipairs(chords) do
        local bass = details[idx][3]
        if bass == bass_note then
            table.insert(ret_chords, chords[idx])
            table.insert(ret_details, details[idx])
        end
    end
    return ret_chords, ret_details
end

function R_BuildChordByNotes(notes, scale_root, scale_name)
    if #notes <= 2 then
        return {}, {}
    end
    -- 
    local bass_note = T_NotePitchToNote(notes[1], scale_root, scale_name)
    local chords1, chord_details1 = T_NotesToChords(notes, scale_root, scale_name)
    for idx, _ in ipairs(chords1) do
        -- bass note same the root note， bass note at 3 pos
        table.insert(chord_details1[idx], chord_details1[idx][1])
    end

    local ret_chords, ret_details = R_FilterChordByBass(chords1, chord_details1, bass_note)
    if #ret_chords > 0 then
        return ret_chords, ret_details
    end

    -- 
    local notes_l, notes_r = SplitListAtIndex(notes, 1)
    local chords2, chord_details2 = T_NotesToChords(notes_r, scale_root, scale_name)
    local chords2_new = {}
    local chord_details2_new = {}
    local bass_note = T_NotePitchToNote(notes_l[1], scale_root, scale_name)
    for idx, _ in ipairs(chords2) do
        if bass_note ~= chord_details2[idx][1] then
            table.insert(chords2_new, chords2[idx].."/"..bass_note)
            table.insert(chord_details2[idx], bass_note)
            table.insert(chord_details2_new, chord_details2[idx])
        end
    end
    local ret_chords, ret_details = R_FilterChordByBass(chords2_new, chord_details2_new, bass_note)
    if #ret_chords > 0 then
        return ret_chords, ret_details
    end
    -- reset bass root
    
    for idx, _ in ipairs(chords1) do
        -- body
        table.insert(ret_chords, chords1[idx].."/"..bass_note)
        chord_details1[idx][3] = bass_note
        table.insert(ret_details, chord_details1[idx])
    end
    return ret_chords, ret_details
end

function R_GetMIDIInputChord(scale_root, scale_name)
    local notes = R_GetMIDIInputNotes()
    return R_BuildChordByNotes(notes, scale_root, scale_name)
end


-- Most Code From FTC Lil_ChordBox / Code Block Start

function R_FTCBuildChord(notes, scale_root, scale_name)
    -- -- Ori Code, mod by xupeng
    -- local chord_key, chord_root, inversion_root = IdentifyChord(notes)
    -- if chord_key then
    --     local chord = {
    --         notes = notes,
    --         root = chord_root,
    --         key = chord_key,
    --         inversion_root = inversion_root,
    --     }
    -- .....
    --

    local pitchs = {}
    for _, note in ipairs(notes) do
        table.insert(pitchs, note.pitch)
    end
    table.sort(pitchs)
    local valid_chords, valid_details = R_BuildChordByNotes(pitchs, scale_root, scale_name)
    if valid_chords then
        local chord = {
            notes = notes,
            pitchs = pitchs,
            valid_chords = valid_chords,
            valid_details = valid_details,
        }
        if notes[1].sppq then
            -- Determine chord start and end ppq position
            local min_eppq = math.maxinteger
            local max_sppq = math.mininteger
            for _, note in ipairs(notes) do
                min_eppq = note.eppq < min_eppq and note.eppq or min_eppq
                max_sppq = note.sppq > max_sppq and note.sppq or max_sppq
            end
            chord.sppq = max_sppq
            chord.eppq = min_eppq
        end
        return chord
    end
end


function R_FTCGetChordsByTake(take, scale_root, scale_name)
    local _, note_cnt = r.MIDI_CountEvts(take)

    local chords = {}
    local notes = {}
    local sel_notes = {}

    local chord_min_eppq

    for i = 0, note_cnt - 1 do
        local _, sel, mute, sppq, eppq, _, pitch = r.MIDI_GetNote(take, i)
        if not mute then
            local note_info = {pitch = pitch, sel = sel, sppq = sppq, eppq = eppq}
            if sel then sel_notes[#sel_notes + 1] = note_info end

            chord_min_eppq = chord_min_eppq or eppq
            chord_min_eppq = eppq < chord_min_eppq and eppq or chord_min_eppq

            if sppq >= chord_min_eppq then
                local new_notes = {}
                if #notes >= 3 then
                    local chord = R_FTCBuildChord(notes, scale_root, scale_name)
                    if chord then chords[#chords + 1] = chord end
                    for n = 3, #notes do
                        -- Remove notes that end prior to chord_min_eppq
                        for _, note in ipairs(notes) do
                            if note.eppq > chord_min_eppq then
                                new_notes[#new_notes + 1] = note
                            end
                        end
                        -- Try to build chords
                        if #new_notes >= 3 then
                            chord = R_FTCBuildChord(new_notes, scale_root, scale_name)
                            if chord then
                                chord.sppq = chord_min_eppq
                                chord.eppq = math.min(chord.eppq, sppq)
                                -- Ignore short chords
                                if chord.eppq - chord.sppq >= 240 then
                                    chords[#chords + 1] = chord
                                end
                                chord_min_eppq = chord.eppq
                            end
                        end
                        new_notes = {}
                    end
                    -- Remove notes that end prior to the start of current note
                    chord_min_eppq = eppq
                    for _, note in ipairs(notes) do
                        if note.eppq > sppq then
                            new_notes[#new_notes + 1] = note
                            if note.eppq < chord_min_eppq then
                                chord_min_eppq = note.eppq
                            end
                        end
                    end
                else
                    chord_min_eppq = eppq
                end
                notes = new_notes
            else
                if #notes >= 3 then
                    local chord = R_FTCBuildChord(notes, scale_root, scale_name)
                    if chord then
                        chord.eppq = math.min(chord.eppq, sppq)
                        -- Ignore very short arpeggiated chords
                        if chord.eppq - chord.sppq >= 180 then
                            chords[#chords + 1] = chord
                        end
                    end
                end
            end
            notes[#notes + 1] = note_info
        end
    end

    local sel_chord
    if #sel_notes >= 3 then
        sel_chord = R_FTCBuildChord(sel_notes, scale_root, scale_name) or {name = 'none'}
    end
    if #notes >= 3 then
        local chord = R_FTCBuildChord(notes, scale_root, scale_name)
        if chord then chords[#chords + 1] = chord end
        for n = 3, #notes do
            local new_notes = {}
            -- Remove notes that end prior to chord_min_eppq
            for _, note in ipairs(notes) do
                if note.eppq > chord_min_eppq then
                    new_notes[#new_notes + 1] = note
                end
            end
            -- Try to build chords
            if #new_notes >= 3 then
                chord = R_FTCBuildChord(new_notes, scale_root, scale_name)
                if chord then
                    chord.sppq = chord_min_eppq
                    -- Ignore short chords
                    if chord.eppq - chord.sppq >= 240 then
                        chords[#chords + 1] = chord
                    end
                    chord_min_eppq = chord.eppq
                end
            end
        end
    end

    return chords, sel_chord
end

-- Most Code From FTC Lil_ChordBox / Code Block End

function R_MIDI2ChordTrack(scale_root, scale_name)
    -- Get the first select midi item
    local midi_take
    local item_count = r.CountMediaItems(0)
    for idx = 0, item_count - 1 do
        local item = r.GetMediaItem(0, idx)
        if r.IsMediaItemSelected(item) then
            local take = r.GetActiveTake(item)
            if r.TakeIsMIDI(take) then
                midi_take = take
                break
            end
        end
    end
    if midi_take == nil then
        return
    end
    local ftc_chords, _ = R_FTCGetChordsByTake(midi_take, scale_root, scale_name)
    for _, ftc_chord in ipairs(ftc_chords) do
        local pitchs = ftc_chord.pitchs
        local chords = ftc_chord.valid_chords
        -- local chord_details = ftc_chord.valid_details
        local chord_idx = T_SelectSimplestChord(chords, scale_root, scale_name)
        local chord = chords[chord_idx]
        -- local chord_detail = chord_details[chord_idx]
        local start_pos = r.MIDI_GetProjTimeFromPPQPos(midi_take, ftc_chord.sppq)
        local end_pos = r.MIDI_GetProjTimeFromPPQPos(midi_take, ftc_chord.eppq)
        local length = end_pos - start_pos

        -- local pure_chord = StringSplit(chord, "/")[1]
        -- local chord_root = chord_detail[1]
        -- local chord_tag = chord_detail[2]
        -- local chord_bass = chord_detail[3]
        -- local chord_type = T_ChordType(pure_chord)

        local oct = (pitchs[1] - 48) // 12
        local oct_shift_after_first_note = 0
        if (pitchs[2] - pitchs[1]) > 12 then
            oct_shift_after_first_note = 1
        end
        local beats = length / R_GetLengthForOneBeat()
        local notes = {}
        for _, pitch in ipairs(pitchs) do
            table.insert(notes, T_NotePitchToNote(pitch, scale_root, scale_name))
        end
        local meta = scale_root .. "/" .. scale_name .. "/" .. oct
        R_InsertChordItemWithPosition(chord, meta, notes, beats, oct_shift_after_first_note, start_pos, end_pos)
    end
    R_ChordItemOverlapAndRefresh()
end

