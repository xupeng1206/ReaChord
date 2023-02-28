require("util")

G_NOTE_LETTERS = {"C", "D", "E", "F", "G", "A", "B"}
G_NOTE_LETTERS_X4  = ListX4(G_NOTE_LETTERS)

G_NOTE_LIST = {"C", "Db/C#", "D", "Eb/D#", "E", "F", "Gb/F#", "G", "Ab/G#", "A", "Bb/A#", "B"}
G_FLAT_NOTE_LIST = {"C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"}
G_NOTE_LIST_X4 = ListX4(G_NOTE_LIST)

G_SIMPLE_NOTE_LIST = {
    "1", "b2/#1", "2", "b3/#2", "3", "4", "b5/#4", "5", "b6/#5", "6", "b7/#6", "7",
    "-", "b9", "9", "#9", "-", "11", "#11", "-", "b13", "13", "-", "-"
}

G_CHORD_MAP ={}
G_CHORD_MAP["X"] = "1,3,5"
G_CHORD_MAP["Xm"] = "1,b3,5"
G_CHORD_MAP["Xaug"] = "1,3,#5"
G_CHORD_MAP["Xdim"] = "1,b3,b5"
G_CHORD_MAP["Xsus4"] = "1,4,5"
G_CHORD_MAP["Xsus2"] = "1,2,5"
G_CHORD_MAP["X6"] = "1,3,5,6"
G_CHORD_MAP["Xm6"] = "1,b3,5,6"
G_CHORD_MAP["XM7"] = "1,3,5,7"
G_CHORD_MAP["XmM7"] = "1,b3,5,7"
G_CHORD_MAP["X7"] = "1,3,5,b7"
G_CHORD_MAP["X7sus4"] = "1,4,5,b7"
G_CHORD_MAP["X7b9"] = "1,3,5,b7,b9"
G_CHORD_MAP["X7#9"] = "1,3,5,b7,#9"
G_CHORD_MAP["X7#11"] = "1,3,5,b7,#11"
G_CHORD_MAP["X7b13"] = "1,3,5,b7,b13"
G_CHORD_MAP["X7b9#9"] = "1,3,5,b7,b9,#9"
G_CHORD_MAP["X7b9#11"] = "1,3,5,b7,b9,#11"
G_CHORD_MAP["X7b9b13"] = "1,3,5,b7,b9,b13"
G_CHORD_MAP["X7#9#11"] = "1,3,5,b7,#9,#11"
G_CHORD_MAP["X7#9b13"] = "1,3,5,b7,#9,b13"
G_CHORD_MAP["X7#11b13"] = "1,3,5,b7,#11,b13"
G_CHORD_MAP["X7b9#9#11"] = "1,3,5,b7,b9,#9,#11"
G_CHORD_MAP["X7b9#9b13"] = "1,3,5,b7,b9,#9,b13"
G_CHORD_MAP["X7b9#11b13"] = "1,3,5,b7,b9,#11,b13"
G_CHORD_MAP["X7#9#11b13"] = "1,3,5,b7,#9,#11,b13"
G_CHORD_MAP["X7b9#9#11b13"] = "1,3,5,b7,b9,#9,#11,b13"
G_CHORD_MAP["Xm7"] = "1,b3,5,b7"
G_CHORD_MAP["Xm7b5"] = "1,b3,b5,b7"
G_CHORD_MAP["Xdim7"] = "1,b3,b5,6"
G_CHORD_MAP["Xaug7"] = "1,3,#5,7"
G_CHORD_MAP["X69"] = "1,3,5,6,9"
G_CHORD_MAP["Xm69"] = "1,b3,5,6,9"
G_CHORD_MAP["Xadd9"] = "1,3,5,9"
G_CHORD_MAP["XM9"] = "1,3,5,7,9"
G_CHORD_MAP["XmM9"] = "1,b3,5,7,9"
G_CHORD_MAP["X9"] = "1,3,5,b7,9"
G_CHORD_MAP["X9sus4"] = "1,4,5,b7,9"
G_CHORD_MAP["Xm9"] = "1,b3,5,b7,9"
G_CHORD_MAP["Xm9b5"] = "1,b3,b5,b7,9"
G_CHORD_MAP["Xaug9"] = "1,3,#5,b7,9"
G_CHORD_MAP["XaugM9"] = "1,3,#5,7,9"
G_CHORD_MAP["Xdim9"] = "1,b3,b5,6,9"
G_CHORD_MAP["X11"] = "1,3,5,b7,9,11"
G_CHORD_MAP["Xm11"] = "1,b3,5,b7,9,11"
G_CHORD_MAP["X13"] = "1,3,5,b7,9,11,13"

G_SCALE_MAP = {}
G_SCALE_MAP["Natural Maj"] = "1,2,3,4,5,6,7"
G_SCALE_MAP["Harmonic Maj"] = "1,2,3,4,5,b6,7"
G_SCALE_MAP["Melodic Maj"] = "1,2,3,4,5,b6,b7"
G_SCALE_MAP["Natural Min"] = "1,2,b3,4,5,b6,b7"
G_SCALE_MAP["Harmonic Min"] = "1,2,b3,4,5,b6,7"
G_SCALE_MAP["Melodic Min"] = "1,2,b3,4,5,6,7"
G_SCALE_MAP["Ionian"] = "1,2,3,4,5,6,7"
G_SCALE_MAP["Dorian"] = "1,2,b3,4,5,6,b7"
G_SCALE_MAP["Phrygian"] = "1,b2,b3,4,5,b6,b7"
G_SCALE_MAP["Lydian"] = "1,2,3,#4,5,6,7"
G_SCALE_MAP["Mixolydian"] = "1,2,3,4,5,6,b7"
G_SCALE_MAP["Aeolian"] = "1,2,b3,4,5,b6,b7"
G_SCALE_MAP["Locrian"] = "1,b2,b3,4,b5,b6,b7"
G_SCALE_MAP["Whole Half Dim"] = "1,2,b3,4,b5,b6,6,7"
G_SCALE_MAP["Half Whole Dim"] = "1,b2,b3,3,b5,5,6,b7"
G_SCALE_MAP["Diatonic"] = "1,2,3,#4,#5,#6"
G_SCALE_MAP["Blues"] = "1,b3,4,b5,5,b7"
G_SCALE_MAP["Mix Blues"] = "1,b3,3,4,b5,5,b7"
G_SCALE_MAP["Aux Blues"] = "1,2,b3,3,4,#4,5,6,b7"
G_SCALE_MAP["Jazz Min"] = "1,2,b3,4,5,6,7"
G_SCALE_MAP["Blues Maj"] = "1,2,b3,4,b5,b6,7"
G_SCALE_MAP["Phrygian Dominant"] = "1,b2,3,4,5,b6,b7"
G_SCALE_MAP["Lydian Dominant"] = "1,2,3,#4,5,6,b7"
G_SCALE_MAP["Super Locrian"] = "1,b2,b3,3,b5,b6,b7"
G_SCALE_MAP["Gypsy"] = "1,b3,#4,5,b6,b7"
G_SCALE_MAP["Hungarian Maj"] = "1,#2,3,#4,5,6,b7"
G_SCALE_MAP["Hungarian Min"] = "1,2,b3,#4,5,b6,7"
G_SCALE_MAP["Bibop"] = "1,2,3,4,5,6,b7,7"
G_SCALE_MAP["India"] = "1,2,3,4,5,b6,b7"
G_SCALE_MAP["Jap"] = "1,3,4,6,7"
G_SCALE_MAP["Russia"] = "1,b2,2,b3,4,5,b6,6,b7,7"
G_SCALE_MAP["Arabian"] = "1,b2,3,4,5,b6,b7"
G_SCALE_MAP["Oriental"] = "1,b2,3,4,b5,6,b7"
G_SCALE_MAP["Spanish"] = "1,b2,b3,3,4,b5,b6,b7"


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
    local patten = FindValueByKeyForMap(G_CHORD_MAP, fullTag)
    return T_Parse(root, patten)
end

function T_MakeScale(scale)
    local tmpT = StringSplit(scale, "/")
    local root = tmpT[1]
    local tag = tmpT[2]
    local patten = FindValueByKeyForMap(G_SCALE_MAP, tag)
    return T_Parse(root, patten)
end

function T_ChordInScale(chord, scale)
    local chordNotes = T_MakeChord(chord)[2]
    local scaleNotes = T_MakeScale(scale)[2]
    return AListAllInBList(chordNotes, scaleNotes)
end

function T_FindScalesByChord(chord)
    local chordNotes = T_MakeChord(chord)
    local scales = {}
    for _, note in ipairs(G_NOTE_LIST) do
        for scaleTag, scalePattern in pairs(G_SCALE_MAP) do
            local tmpScaleNotes = T_Parse(note, scalePattern)[2]
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
    local chordNotes = T_MakeChord(chord)
    if #chordNotes > 4 then
        return chords
    end
    
    for _, note in ipairs(G_FLAT_NOTE_LIST) do
        for chordTag, chordPattern in pairs(G_CHORD_MAP) do
            local chordPatternNotes = StringSplit(chordPattern, ",")
            if #chordPatternNotes <= 4 then
                local tmpChord = note .. string.sub(chordTag, 2, string.len(chordTag))
                local tmpChordNotes = T_Parse(note, chordPattern)[2]
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
