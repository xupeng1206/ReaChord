dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')
r = reaper
print = r.ShowConsoleMsg

G_NOTE_LETTERS = {"C", "D", "E", "F", "G", "A", "B"}
G_NOTE_LETTERS_X4  = ListX4(G_NOTE_LETTERS)

G_NOTE_LIST = {"C", "Db/C#", "D", "Eb/D#", "E", "F", "Gb/F#", "G", "Ab/G#", "A", "Bb/A#", "B"}
G_FLAT_NOTE_LIST = {"C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"}
G_NOTE_LIST_X4 = ListX4(G_NOTE_LIST)
G_FLAT_NOTE_LIST_X4 = ListX4(G_FLAT_NOTE_LIST)

G_SIMPLE_NOTE_LIST = {
    "1", "b2/#1", "2", "b3/#2", "3", "4", "b5/#4", "5", "b6/#5", "6", "b7/#6", "7",
    "-", "b9", "9", "#9", "-", "11", "#11", "-", "b13", "13", "-", "-"
}

G_CHORD_NAMES = {}
G_CHORD_PATTERNS = {}
G_CHORD_NAMES[1] = "X"
G_CHORD_PATTERNS[1] = "1,3,5"
G_CHORD_NAMES[2] = "Xm"
G_CHORD_PATTERNS[2] = "1,b3,5"
G_CHORD_NAMES[3] = "Xaug"
G_CHORD_PATTERNS[3] = "1,3,#5"
G_CHORD_NAMES[4] = "Xdim"
G_CHORD_PATTERNS[4] = "1,b3,b5"
G_CHORD_NAMES[5] = "Xsus4"
G_CHORD_PATTERNS[5] = "1,4,5"
G_CHORD_NAMES[6] = "Xsus2"
G_CHORD_PATTERNS[6] = "1,2,5"
G_CHORD_NAMES[7] = "X6"
G_CHORD_PATTERNS[7] = "1,3,5,6"
G_CHORD_NAMES[8] = "Xm6"
G_CHORD_PATTERNS[8] = "1,b3,5,6"
G_CHORD_NAMES[9] = "XM7"
G_CHORD_PATTERNS[9] = "1,b3,5,6"
G_CHORD_NAMES[10] = "XmM7"
G_CHORD_PATTERNS[10] = "1,b3,5,7"
G_CHORD_NAMES[11] = "X7"
G_CHORD_PATTERNS[11] = "1,3,5,b7"
G_CHORD_NAMES[12] = "X7sus4"
G_CHORD_PATTERNS[12] = "1,4,5,b7"
G_CHORD_NAMES[13] = "X7b9"
G_CHORD_PATTERNS[13] = "1,3,5,b7,b9"
G_CHORD_NAMES[14] = "X7#9"
G_CHORD_PATTERNS[14] = "1,3,5,b7,#9"
G_CHORD_NAMES[15] = "X7#11"
G_CHORD_PATTERNS[15] = "1,3,5,b7,#11"
G_CHORD_NAMES[16] = "X7b13"
G_CHORD_PATTERNS[16] = "1,3,5,b7,b13"
G_CHORD_NAMES[17] = "X7b9#9"
G_CHORD_PATTERNS[17] = "1,3,5,b7,b9,#9"
G_CHORD_NAMES[18] = "X7b9#11"
G_CHORD_PATTERNS[18] = "1,3,5,b7,b9,#11"
G_CHORD_NAMES[19] = "X7b9b13"
G_CHORD_PATTERNS[19] = "1,3,5,b7,b9,b13"
G_CHORD_NAMES[20] = "X7#9#11"
G_CHORD_PATTERNS[20] = "1,3,5,b7,#9,#11"
G_CHORD_NAMES[21] = "X7#9b13"
G_CHORD_PATTERNS[21] = "1,3,5,b7,#9,b13"
G_CHORD_NAMES[22] = "X7#11b13"
G_CHORD_PATTERNS[22] = "1,3,5,b7,#11,b13"
G_CHORD_NAMES[23] = "X7b9#9#11"
G_CHORD_PATTERNS[23] = "1,3,5,b7,b9,#9,#11"
G_CHORD_NAMES[24] = "X7b9#9b13"
G_CHORD_PATTERNS[24] = "1,3,5,b7,b9,#9,b13"
G_CHORD_NAMES[25] = "X7b9#11b13"
G_CHORD_PATTERNS[25] = "1,3,5,b7,b9,#11,b13"
G_CHORD_NAMES[26] = "X7#9#11b13"
G_CHORD_PATTERNS[26] = "1,3,5,b7,#9,#11,b13"
G_CHORD_NAMES[27] = "X7b9#9#11b13"
G_CHORD_PATTERNS[27] = "1,3,5,b7,b9,#9,#11,b13"
G_CHORD_NAMES[28] = "Xm7"
G_CHORD_PATTERNS[28] = "1,b3,5,b7"
G_CHORD_NAMES[29] = "Xm7b5"
G_CHORD_PATTERNS[29] = "1,b3,b5,b7"
G_CHORD_NAMES[30] = "Xdim7"
G_CHORD_PATTERNS[30] = "1,b3,b5,6"
G_CHORD_NAMES[31] = "Xaug7"
G_CHORD_PATTERNS[31] = "1,3,#5,7"
G_CHORD_NAMES[32] = "X69"
G_CHORD_PATTERNS[32] = "1,3,5,6,9"
G_CHORD_NAMES[33] = "Xm69"
G_CHORD_PATTERNS[33] = "1,b3,5,6,9"
G_CHORD_NAMES[34] = "Xadd9"
G_CHORD_PATTERNS[34] = "1,3,5,9"
G_CHORD_NAMES[35] = "XM9"
G_CHORD_PATTERNS[35] = "1,3,5,7,9"
G_CHORD_NAMES[36] = "XmM9"
G_CHORD_PATTERNS[36] = "1,b3,5,7,9"
G_CHORD_NAMES[37] = "X9"
G_CHORD_PATTERNS[37] = "1,3,5,b7,9"
G_CHORD_NAMES[38] = "X9sus4"
G_CHORD_PATTERNS[38] = "1,4,5,b7,9"
G_CHORD_NAMES[39] = "Xm9"
G_CHORD_PATTERNS[39] = "1,b3,5,b7,9"
G_CHORD_NAMES[40] = "Xm9b5"
G_CHORD_PATTERNS[40] = "1,b3,b5,b7,9"
G_CHORD_NAMES[41] = "Xaug9"
G_CHORD_PATTERNS[41] = "1,3,#5,b7,9"
G_CHORD_NAMES[42] = "XaugM9"
G_CHORD_PATTERNS[42] = "1,3,#5,7,9"
G_CHORD_NAMES[43] = "Xdim9"
G_CHORD_PATTERNS[43] = "1,b3,b5,6,9"
G_CHORD_NAMES[44] = "X11"
G_CHORD_PATTERNS[44] = "1,3,5,b7,9,11"
G_CHORD_NAMES[45] = "Xm11"
G_CHORD_PATTERNS[45] = "1,b3,5,b7,9,11"
G_CHORD_NAMES[45] = "X13"
G_CHORD_PATTERNS[45] = "1,3,5,b7,9,11,13"

G_SCALE_NAMES = {}
G_SCALE_PATTERNS = {}
G_SCALE_NAMES[1] = "Natural Maj"
G_SCALE_PATTERNS[1] = "1,2,3,4,5,6,7"
G_SCALE_NAMES[2] = "Harmonic Maj"
G_SCALE_PATTERNS[2] = "1,2,3,4,5,b6,7"
G_SCALE_NAMES[3] = "Melodic Maj"
G_SCALE_PATTERNS[3] = "1,2,3,4,5,b6,b7"
G_SCALE_NAMES[4] = "Natural Min"
G_SCALE_PATTERNS[4] = "1,2,b3,4,5,b6,b7"
G_SCALE_NAMES[5] = "Harmonic Min"
G_SCALE_PATTERNS[5] = "1,2,b3,4,5,b6,7"
G_SCALE_NAMES[6] = "Melodic Min"
G_SCALE_PATTERNS[6] = "1,2,b3,4,5,6,7"
G_SCALE_NAMES[7] = "Ionian"
G_SCALE_PATTERNS[7] = "1,2,3,4,5,6,7"
G_SCALE_NAMES[8] = "Dorian"
G_SCALE_PATTERNS[8] = "1,2,b3,4,5,6,b7"
G_SCALE_NAMES[9] = "Phrygian"
G_SCALE_PATTERNS[9] = "1,b2,b3,4,5,b6,b7"
G_SCALE_NAMES[10] = "Lydian"
G_SCALE_PATTERNS[10] = "1,2,3,#4,5,6,7"
G_SCALE_NAMES[11] = "Mixolydian"
G_SCALE_PATTERNS[11] = "1,2,3,4,5,6,b7"
G_SCALE_NAMES[12] = "Aeolian"
G_SCALE_PATTERNS[12] = "1,2,b3,4,5,b6,b7"
G_SCALE_NAMES[13] = "Locrian"
G_SCALE_PATTERNS[13] = "1,b2,b3,4,b5,b6,b7"
G_SCALE_NAMES[14] = "Whole Half Dim"
G_SCALE_PATTERNS[14] = "1,2,b3,4,b5,b6,6,7"
G_SCALE_NAMES[15] = "Half Whole Dim"
G_SCALE_PATTERNS[15] = "1,b2,b3,3,b5,5,6,b7"
G_SCALE_NAMES[16] = "Diatonic"
G_SCALE_PATTERNS[16] = "1,2,3,#4,#5,#6"
G_SCALE_NAMES[17] = "Blues"
G_SCALE_PATTERNS[17] = "1,b3,4,b5,5,b7"
G_SCALE_NAMES[18] = "Mix Blues"
G_SCALE_PATTERNS[18] = "1,b3,3,4,b5,5,b7"
G_SCALE_NAMES[19] = "Aux Blues"
G_SCALE_PATTERNS[19] = "1,2,b3,3,4,#4,5,6,b7"
G_SCALE_NAMES[20] = "Jazz Min"
G_SCALE_PATTERNS[20] = "1,2,b3,4,5,6,7"
G_SCALE_NAMES[21] = "Blues Maj"
G_SCALE_PATTERNS[21] = "1,2,b3,4,b5,b6,7"
G_SCALE_NAMES[22] = "Phrygian Dominant"
G_SCALE_PATTERNS[22] = "1,b2,3,4,5,b6,b7"
G_SCALE_NAMES[23] = "Lydian Dominant"
G_SCALE_PATTERNS[23] = "1,2,3,#4,5,6,b7"
G_SCALE_NAMES[24] = "Super Locrian"
G_SCALE_PATTERNS[24] = "1,b2,b3,3,b5,b6,b7"
G_SCALE_NAMES[25] = "Gypsy"
G_SCALE_PATTERNS[25] = "1,b3,#4,5,b6,b7"
G_SCALE_NAMES[26] = "Hungarian Maj"
G_SCALE_PATTERNS[26] = "1,#2,3,#4,5,6,b7"
G_SCALE_NAMES[27] = "Hungarian Min"
G_SCALE_PATTERNS[27] = "1,2,b3,#4,5,b6,7"
G_SCALE_NAMES[28] = "Bibop"
G_SCALE_PATTERNS[28] = "1,2,3,4,5,6,b7,7"
G_SCALE_NAMES[29] = "India"
G_SCALE_PATTERNS[29] = "1,2,3,4,5,b6,b7"
G_SCALE_NAMES[30] = "Jap"
G_SCALE_PATTERNS[30] = "1,3,4,6,7"
G_SCALE_NAMES[31] = "Russia"
G_SCALE_PATTERNS[31] = "1,b2,2,b3,4,5,b6,6,b7,7"
G_SCALE_NAMES[32] = "Arabian"
G_SCALE_PATTERNS[32] = "1,b2,3,4,5,b6,b7"
G_SCALE_NAMES[33] = "Oriental"
G_SCALE_PATTERNS[33] = "1,b2,3,4,b5,6,b7"
G_SCALE_NAMES[34] = "Spanish"
G_SCALE_PATTERNS[34] = "1,b2,b3,3,4,b5,b6,b7"


function T_NoteIndex(lst, target)
    for idx, notes in ipairs(lst) do
        for _, note in ipairs(StringSplit(notes, "/")) do
            if note == target then
                return idx
            end
        end
    end
    return -1
end

function T_Parse(root, pattern)
    local rootIdx = T_NoteIndex(G_NOTE_LIST_X4, root)
    local rootLetter = string.sub(root, 1, 1)
    local rootLetterIdx = T_NoteIndex(G_NOTE_LETTERS_X4, rootLetter)
    
    local pureNotes = {}
    local mNotes = {}

    local patternTable = StringSplit(pattern, ",")
    for _, numNote in ipairs(patternTable) do
        local numNoteIdx  = T_NoteIndex(G_SIMPLE_NOTE_LIST, numNote)
        local noteIdx = numNoteIdx + rootIdx - 1
        local mNote = G_NOTE_LIST_X4[noteIdx]
        table.insert(mNotes, mNote)
        
        local numNotenum = ""
        local numNote1C = string.sub(numNote, 1, 1)
        if numNote1C ~= "b" and numNote1C ~= "#" then
            numNotenum = string.sub(numNote, 1, 1)
        else
            numNotenum = string.sub(numNote, 2, 2)
        end
        local noteLetterIdx = rootLetterIdx + numNotenum - 1
        local noteLetter = G_NOTE_LETTERS_X4[noteLetterIdx]
        for _, noteName in ipairs(StringSplit(mNote, "/")) do
            local tmpNoteLetter = string.sub(noteName, 1, 1)
            if tmpNoteLetter == noteLetter then
                table.insert(pureNotes, noteName)
                break
            end
        end
    end
    return pureNotes, mNotes
end


function T_MakeChord(chord)
    local pure_notes = {}
    local m_notes = {}
    local root = "X"
    local tagStartIdx = 2
    local b = string.sub(chord, 2, 2)
    if b == "#" or b == "b" then
        root = string.sub(chord, 1, 2)
        tagStartIdx = 3
    else
        root = string.sub(chord, 1, 1)
        tagStartIdx = 2
    end
    local tag = string.sub(chord, tagStartIdx, string.len(chord))
    local fullTag = "X" .. tag
    local chordIdx = ListIndex(G_CHORD_NAMES, fullTag)
    local patten = G_CHORD_PATTERNS[chordIdx]
    pure_notes, m_notes =  T_Parse(root, patten)
    return pure_notes, m_notes
end

function T_MakeScale(scale)
    local pure_notes = {}
    local m_notes = {}
    local tmpT = StringSplit(scale, "/")
    local root = tmpT[1]
    local tag = tmpT[2]
    local scaleIdx = ListIndex(G_SCALE_NAMES, tag)
    local patten = G_SCALE_PATTERNS[scaleIdx]
    pure_notes, m_notes =  T_Parse(root, patten)
    return pure_notes, m_notes
end

function T_ChordInScale(chord, scale)
    local _, chordNotes = T_MakeChord(chord)
    local _, scaleNotes = T_MakeScale(scale)
    local all_in = AListAllInBList(chordNotes, scaleNotes)
    return all_in
end

function T_FindScalesByChord(chord)
    local _, chordNotes = T_MakeChord(chord)
    local scales = {}
    for _, note in ipairs(G_NOTE_LIST) do
        for idx, scaleTag in ipairs(G_SCALE_NAMES) do
            local scalePattern = G_SCALE_PATTERNS[idx]
            local _, tmpScaleNotes = T_Parse(note, scalePattern)
            if AListAllInBList(chordNotes, tmpScaleNotes) then
                table.insert(scales, note .. "/" .. scaleTag)
            end
        end
    end
    return scales
end


function T_FindSimilarChords(chord)
    local chords = {}
    local x3chords = {}
    local x2chords = {}
    local _, chordNotes = T_MakeChord(chord)
    if #chordNotes > 4 then
        return chords
    end
    
    for _, note in ipairs(G_FLAT_NOTE_LIST) do
        for idx, chordTag in ipairs(G_CHORD_NAMES) do
            local chordPattern = G_CHORD_PATTERNS[idx]
            local chordPatternNotes = StringSplit(chordPattern, ",")
            if #chordPatternNotes <= 4 then
                local tmpChord = note .. string.sub(chordTag, 2, string.len(chordTag))
                local _, tmpChordNotes = T_Parse(note, chordPattern)
                local simLen = AListInBListLen(tmpChordNotes, chordNotes)
                if simLen == 2 then
                    table.insert(x2chords, tmpChord)
                elseif simLen == 3 then
                    table.insert(x3chords, tmpChord)
                end
            end
        end
    end
    chords = ListExtend(x3chords, x2chords)
    return chords
end

function  T_ScaleTrans(scale, diff)
    local splited = StringSplit(scale, "/")
    local root = splited[1]
    local tag = splited[2]
    local rootIdx = T_NoteIndex(G_NOTE_LIST_X4, root)
    local newRoot = G_FLAT_NOTE_LIST_X4[rootIdx+diff+12]
    return newRoot..tag
end

function  T_ChordTrans(chord, scale, diff)
    local newScale = T_ScaleTrans(scale, diff)
    local scaleNotes, _ = T_MakeScale(newScale)
    
    local root = "X"
    local tagStartIdx = 2
    local b = string.sub(chord, 2, 2)
    if b == "#" or b == "b" then
        root = string.sub(chord, 1, 2)
        tagStartIdx = 3
    else
        root = string.sub(chord, 1, 1)
        tagStartIdx = 2
    end
    local tag = string.sub(chord, tagStartIdx, string.len(chord))

    local rootIdx = T_NoteIndex(G_NOTE_LIST_X4, root)
    local newRootM = G_NOTE_LIST_X4[rootIdx+diff+12]
    
    local newRootTable = StringSplit(newRootM)
    
    local newRoot = newRootTable[1]
    if #newRootTable > 1 and ListIndex(scaleNotes, newRootTable[2])>0 then
        newRoot = newRootTable[2]
    end
    return newRoot..tag
end

function T_NotePitched(notes)
    local preIdx = 0
    local curOct = 0
    local notePitched = {}
    local noteIdxes = {}
    for _, note in ipairs(notes) do
        local curIdx = T_NoteIndex(G_NOTE_LIST_X4, note)
        curIdx =curIdx + curOct * 12
        if curIdx <= preIdx then
            curOct = curOct + 1
            curIdx = curIdx + 12
        end
        table.insert(noteIdxes, curIdx-1)
        table.insert(notePitched, note..curOct)
        preIdx = curIdx
    end
    return notePitched, noteIdxes
end
