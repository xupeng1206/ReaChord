--@noindex
--NoIndex: true

local r = reaper
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

-- X
table.insert(G_CHORD_NAMES, "X")
table.insert(G_CHORD_PATTERNS, "1,3,5")

-- Xm
table.insert(G_CHORD_NAMES, "Xm")
table.insert(G_CHORD_PATTERNS, "1,b3,5")

-- Xaug
table.insert(G_CHORD_NAMES, "Xaug")
table.insert(G_CHORD_PATTERNS, "1,3,#5")

-- Xdim
table.insert(G_CHORD_NAMES, "Xdim")
table.insert(G_CHORD_PATTERNS, "1,b3,b5")

-- Xsus4
table.insert(G_CHORD_NAMES, "Xsus4")
table.insert(G_CHORD_PATTERNS, "1,4,5")

-- Xsus2
table.insert(G_CHORD_NAMES, "Xsus2")
table.insert(G_CHORD_PATTERNS, "1,2,5")

-- X6
table.insert(G_CHORD_NAMES, "X6")
table.insert(G_CHORD_PATTERNS, "1,3,5,6")

-- Xm6
table.insert(G_CHORD_NAMES, "Xm6")
table.insert(G_CHORD_PATTERNS, "1,b3,5,6")

-- XM7
table.insert(G_CHORD_NAMES, "XM7")
table.insert(G_CHORD_PATTERNS, "1,3,5,7")

-- XmM7
table.insert(G_CHORD_NAMES, "XmM7")
table.insert(G_CHORD_PATTERNS, "1,b3,5,7")

-- X7
table.insert(G_CHORD_NAMES, "X7")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7")

-- X7sus4
table.insert(G_CHORD_NAMES, "X7sus4")
table.insert(G_CHORD_PATTERNS, "1,4,5,b7")

-- X7b9
table.insert(G_CHORD_NAMES, "X7b9")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b9")

-- X7#9
table.insert(G_CHORD_NAMES, "X7#9")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,#9")

-- X7#11
table.insert(G_CHORD_NAMES, "X7#11")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,#11")

-- X7b13
table.insert(G_CHORD_NAMES, "X7b13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b13")

-- Xm7
table.insert(G_CHORD_NAMES, "Xm7")
table.insert(G_CHORD_PATTERNS, "1,b3,5,b7")

-- Xm7b5
table.insert(G_CHORD_NAMES, "Xm7b5")
table.insert(G_CHORD_PATTERNS, "1,b3,b5,b7")

-- Xdim7
table.insert(G_CHORD_NAMES, "Xdim7")
table.insert(G_CHORD_PATTERNS, "1,b3,b5,6")

-- Xaug7
table.insert(G_CHORD_NAMES, "Xaug7")
table.insert(G_CHORD_PATTERNS, "1,3,#5,7")

-- X69
table.insert(G_CHORD_NAMES, "X69")
table.insert(G_CHORD_PATTERNS, "1,3,5,6,9")

-- Xm69
table.insert(G_CHORD_NAMES, "Xm69")
table.insert(G_CHORD_PATTERNS, "1,b3,5,6,9")

-- Xadd9
table.insert(G_CHORD_NAMES, "Xadd9")
table.insert(G_CHORD_PATTERNS, "1,3,5,9")

-- XM9
table.insert(G_CHORD_NAMES, "XM9")
table.insert(G_CHORD_PATTERNS, "1,3,5,7,9")

-- XmM9
table.insert(G_CHORD_NAMES, "XmM9")
table.insert(G_CHORD_PATTERNS, "1,b3,5,7,9")

-- X9
table.insert(G_CHORD_NAMES, "X9")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,9")

-- X9sus4
table.insert(G_CHORD_NAMES, "X9sus4")
table.insert(G_CHORD_PATTERNS, "1,4,5,b7,9")

-- Xm9
table.insert(G_CHORD_NAMES, "Xm9")
table.insert(G_CHORD_PATTERNS, "1,b3,5,b7,9")

-- Xm9b5
table.insert(G_CHORD_NAMES, "Xm9b5")
table.insert(G_CHORD_PATTERNS, "1,b3,b5,b7,9")

-- Xaug9
table.insert(G_CHORD_NAMES, "Xaug9")
table.insert(G_CHORD_PATTERNS, "1,3,#5,b7,9")

-- XaugM9
table.insert(G_CHORD_NAMES, "XaugM9")
table.insert(G_CHORD_PATTERNS, "1,3,#5,7,9")

-- Xdim9
table.insert(G_CHORD_NAMES, "Xdim9")
table.insert(G_CHORD_PATTERNS, "1,b3,b5,6,9")

-- X11
table.insert(G_CHORD_NAMES, "X11")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,9,11")

-- Xm11
table.insert(G_CHORD_NAMES, "Xm11")
table.insert(G_CHORD_PATTERNS, "1,b3,5,b7,9,11")

-- X13
table.insert(G_CHORD_NAMES, "X13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,9,11,13")

-- X7b9#9
table.insert(G_CHORD_NAMES, "X7b9#9")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b9,#9")

-- X7b9#11
table.insert(G_CHORD_NAMES, "X7b9#11")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b9,#11")

-- X7b9b13
table.insert(G_CHORD_NAMES, "X7b9b13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b9,b13")

-- X7#9#11
table.insert(G_CHORD_NAMES, "X7#9#11")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,#9,#11")

-- X7#9b13
table.insert(G_CHORD_NAMES, "X7#9b13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,#9,b13")

-- X7#11b13
table.insert(G_CHORD_NAMES, "X7#11b13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,#11,b13")

-- X7b9#9#11
table.insert(G_CHORD_NAMES, "X7b9#9#11")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b9,#9,#11")

-- X7b9#9b13
table.insert(G_CHORD_NAMES, "X7b9#9b13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b9,#9,b13")

-- X7b9#11b13
table.insert(G_CHORD_NAMES, "X7b9#11b13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b9,#11,b13")

-- X7#9#11b13
table.insert(G_CHORD_NAMES, "X7#9#11b13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,#9,#11,b13")

-- X7b9#9#11b13
table.insert(G_CHORD_NAMES, "X7b9#9#11b13")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7,b9,#9,#11,b13")


G_SCALE_NAMES = {}
G_SCALE_PATTERNS = {}

-- Natural Maj
table.insert(G_SCALE_NAMES, "Natural Maj")
table.insert(G_SCALE_PATTERNS, "1,2,3,4,5,6,7")

-- Harmonic Maj
table.insert(G_SCALE_NAMES, "Harmonic Maj")
table.insert(G_SCALE_PATTERNS, "1,2,3,4,5,b6,7")

-- Melodic Maj
table.insert(G_SCALE_NAMES, "Melodic Maj")
table.insert(G_SCALE_PATTERNS, "1,2,3,4,5,b6,b7")

-- Natural Min
table.insert(G_SCALE_NAMES, "Natural Min")
table.insert(G_SCALE_PATTERNS, "1,2,b3,4,5,b6,b7")

-- Harmonic Min
table.insert(G_SCALE_NAMES, "Harmonic Min")
table.insert(G_SCALE_PATTERNS, "1,2,b3,4,5,b6,7")

-- Melodic Min
table.insert(G_SCALE_NAMES, "Melodic Min")
table.insert(G_SCALE_PATTERNS, "1,2,b3,4,5,6,7")

-- Ionian
table.insert(G_SCALE_NAMES, "Ionian")
table.insert(G_SCALE_PATTERNS, "1,2,3,4,5,6,7")

-- Dorian
table.insert(G_SCALE_NAMES, "Dorian")
table.insert(G_SCALE_PATTERNS, "1,2,b3,4,5,6,b7")

-- Phrygian
table.insert(G_SCALE_NAMES, "Phrygian")
table.insert(G_SCALE_PATTERNS, "1,b2,b3,4,5,b6,b7")

-- Lydian
table.insert(G_SCALE_NAMES, "Lydian")
table.insert(G_SCALE_PATTERNS, "1,2,3,#4,5,6,7")

-- Mixolydian
table.insert(G_SCALE_NAMES, "Mixolydian")
table.insert(G_SCALE_PATTERNS, "1,2,3,4,5,6,b7")

-- Aeolian
table.insert(G_SCALE_NAMES, "Aeolian")
table.insert(G_SCALE_PATTERNS, "1,2,b3,4,5,b6,b7")

-- Locrian
table.insert(G_SCALE_NAMES, "Locrian")
table.insert(G_SCALE_PATTERNS, "1,b2,b3,4,b5,b6,b7")

-- Whole Half Dim
table.insert(G_SCALE_NAMES, "Whole Half Dim")
table.insert(G_SCALE_PATTERNS, "1,2,b3,4,b5,b6,6,7")

-- Half Whole Dim
table.insert(G_SCALE_NAMES, "Half Whole Dim")
table.insert(G_SCALE_PATTERNS, "1,b2,b3,3,b5,5,6,b7")

-- Diatonic
table.insert(G_SCALE_NAMES, "Diatonic")
table.insert(G_SCALE_PATTERNS, "1,2,3,#4,#5,#6")

-- Blues
table.insert(G_SCALE_NAMES, "Blues")
table.insert(G_SCALE_PATTERNS, "1,b3,4,b5,5,b7")

-- Mix Blues
table.insert(G_SCALE_NAMES, "Mix Blues")
table.insert(G_SCALE_PATTERNS, "1,b3,3,4,b5,5,b7")

-- Aux Blues
table.insert(G_SCALE_NAMES, "Aux Blues")
table.insert(G_SCALE_PATTERNS, "1,2,b3,3,4,#4,5,6,b7")

-- Jazz Min
table.insert(G_SCALE_NAMES, "Jazz Min")
table.insert(G_SCALE_PATTERNS, "1,2,b3,4,5,6,7")

-- Blues Maj
table.insert(G_SCALE_NAMES, "Blues Maj")
table.insert(G_SCALE_PATTERNS, "1,2,b3,4,b5,b6,7")

-- Phrygian Dominant
table.insert(G_SCALE_NAMES, "Phrygian Dominant")
table.insert(G_SCALE_PATTERNS, "1,b2,3,4,5,b6,b7")

-- Lydian Dominant
table.insert(G_SCALE_NAMES, "Lydian Dominant")
table.insert(G_SCALE_PATTERNS, "1,2,3,#4,5,6,b7")

-- Super Locrian
table.insert(G_SCALE_NAMES, "Super Locrian")
table.insert(G_SCALE_PATTERNS, "1,b2,b3,3,b5,b6,b7")

-- Gypsy
table.insert(G_SCALE_NAMES, "Gypsy")
table.insert(G_SCALE_PATTERNS, "1,b3,#4,5,b6,b7")

-- Hungarian Maj
table.insert(G_SCALE_NAMES, "Hungarian Maj")
table.insert(G_SCALE_PATTERNS, "1,#2,3,#4,5,6,b7")

-- Hungarian Min
table.insert(G_SCALE_NAMES, "Hungarian Min")
table.insert(G_SCALE_PATTERNS, "1,2,b3,#4,5,b6,7")

-- Bibop
table.insert(G_SCALE_NAMES, "Bibop")
table.insert(G_SCALE_PATTERNS, "1,2,3,4,5,6,b7,7")

-- India
table.insert(G_SCALE_NAMES, "India")
table.insert(G_SCALE_PATTERNS, "1,2,3,4,5,b6,b7")

-- Japanese
table.insert(G_SCALE_NAMES, "Japanese")
table.insert(G_SCALE_PATTERNS, "1,3,4,6,7")

-- Russia
table.insert(G_SCALE_NAMES, "Russia")
table.insert(G_SCALE_PATTERNS, "1,b2,2,b3,4,5,b6,6,b7,7")

-- Arabian
table.insert(G_SCALE_NAMES, "Arabian")
table.insert(G_SCALE_PATTERNS, "1,b2,3,4,5,b6,b7")

-- Oriental
table.insert(G_SCALE_NAMES, "Oriental")
table.insert(G_SCALE_PATTERNS, "1,b2,3,4,b5,6,b7")

-- Spanish
table.insert(G_SCALE_NAMES, "Spanish")
table.insert(G_SCALE_PATTERNS, "1,b2,b3,3,4,b5,b6,b7")



G_WHOLE_HALF_SCALE_PATTERN = "1,b2,2,b3,3,4,b5,5,b6,6,b7,7"


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

function T_MNote(target)
    for idx, notes in ipairs(G_NOTE_LIST) do
        for _, note in ipairs(StringSplit(notes, "/")) do
            if note == target then
                return notes
            end
        end
    end
    return target
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
        if numNote1C == "b" then
            numNotenum = StringSplit(numNote, "b")[2]
        elseif numNote1C == "#" then
            numNotenum = StringSplit(numNote, "#")[2]
        else
            numNotenum = numNote
        end
        local noteLetterIdx = rootLetterIdx + numNotenum - 1
        local noteLetter = G_NOTE_LETTERS_X4[noteLetterIdx]
        local found = "no"
        for _, noteName in ipairs(StringSplit(mNote, "/")) do
            local tmpNoteLetter = string.sub(noteName, 1, 1)
            if tmpNoteLetter == noteLetter then
                table.insert(pureNotes, noteName)
                found = "yes"
                break
            end
        end
        if found == "no" then
            table.insert(pureNotes, StringSplit(mNote, "/")[1])
        end
    end
    return pureNotes, mNotes
end

function T_SplitChordRootAndPattern(chord)
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
    return root, tag
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

function T_FindScalesByChord(chord, bass)
    local _, chordNotes = T_MakeChord(chord)
    ListAddUniqValue(chordNotes, T_MNote(bass))
    local scales = {}
    for _, note in ipairs(G_FLAT_NOTE_LIST) do
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


function T_FindSimilarChords(chord, bass)
    local chords = {}
    local x2chords = {}
    local x3chords = {}
    local x4chords = {}
    local x5chords = {}
    local _, chordNotes = T_MakeChord(chord)
    ListAddUniqValue(chordNotes, T_MNote(bass))
    if #chordNotes > 6 then
        return chords
    end
    
    for _, note in ipairs(G_FLAT_NOTE_LIST) do
        for idx, chordTag in ipairs(G_CHORD_NAMES) do
            local chordPattern = G_CHORD_PATTERNS[idx]
            local chordPatternNotes = StringSplit(chordPattern, ",")
            if #chordPatternNotes <= 6 then
                local tmpChord = note .. string.sub(chordTag, 2, string.len(chordTag))
                local _, tmpChordNotes = T_Parse(note, chordPattern)
                local simLen = AListInBListLen(tmpChordNotes, chordNotes)
                if simLen == 2 then
                    table.insert(x2chords, tmpChord)
                elseif simLen == 3 then
                    table.insert(x3chords, tmpChord)
                elseif simLen == 4 then
                    table.insert(x4chords, tmpChord)
                elseif simLen == 5 then
                    table.insert(x5chords, tmpChord)
                end
            end
        end
    end
    chords = ListExtend(x5chords, x4chords)
    chords = ListExtend(chords, x3chords)
    chords = ListExtend(chords, x2chords)
    return chords
end

function  T_ScaleTrans(scale, diff)
    local splited = StringSplit(scale, "/")
    local root = splited[1]
    local tag = splited[2]
    local rootIdx = T_NoteIndex(G_NOTE_LIST_X4, root)
    local newRoot = G_FLAT_NOTE_LIST_X4[rootIdx+diff+12]
    return newRoot.."/"..tag
end

function T_NoteTrans(note, scale, diff)
    local newScale = T_ScaleTrans(scale, diff)
    local scaleNotes, _ = T_MakeScale(newScale)
    
    local noteIdx = T_NoteIndex(G_NOTE_LIST_X4, note)
    local newNoteM = G_NOTE_LIST_X4[noteIdx+diff+12]
    
    local newNoteTable = StringSplit(newNoteM, "/")
    
    local newNote = newNoteTable[1]
    if #newNoteTable > 1 and ListIndex(scaleNotes, newNoteTable[2])>0 then
        newNote = newNoteTable[2]
    end
    return newNote
end

function T_VoicingTrans(new_chord, notes, diff)
    local new_pure_notes, _ = T_MakeChord(new_chord)
    local new_notes = {}
    for _, note in ipairs(notes) do
        local noteIdx = T_NoteIndex(G_NOTE_LIST_X4, note)
        local newNoteM = G_NOTE_LIST_X4[noteIdx+diff+12]
        local newNoteTable = StringSplit(newNoteM, "/")
        
        local newNote = newNoteTable[1]
        if #newNoteTable > 1 and ListIndex(new_pure_notes, newNoteTable[2])>0 then
            newNote = newNoteTable[2]
        end
        table.insert(new_notes, newNote)
    end
    return new_notes
end

function  T_ChordTrans(chord, scale, diff)
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

    local newRoot = T_NoteTrans(root, scale, diff)
    return newRoot..tag
end

function T_NotePitched(notes, oct_shift_after_first_note)
    local preIdx = 0
    local curOct = 0
    local notePitched = {}
    local noteIdxes = {}
    for idx, note in ipairs(notes) do
        local curIdx = T_NoteIndex(G_NOTE_LIST_X4, note)
        curIdx =curIdx + curOct * 12
        if curIdx <= preIdx then
            curOct = curOct + 1
            curIdx = curIdx + 12
        end
        local insertIdx = curIdx-1
        local insertOct = curOct
        if idx>1 then
            insertIdx = insertIdx + 12 * oct_shift_after_first_note
            insertOct = insertOct + oct_shift_after_first_note
        end
        table.insert(noteIdxes, insertIdx)
        table.insert(notePitched, note..insertOct)
        preIdx = curIdx
    end
    return notePitched, noteIdxes
end

function T_NoteName2Num(note, scale_root)
    local _, m_notes = T_Parse(scale_root, G_WHOLE_HALF_SCALE_PATTERN)
    local index = T_NoteIndex(m_notes, note)
    if index>0 then
        return StringSplit(G_WHOLE_HALF_SCALE_PATTERN, ",")[index]
    end
    return "X"
end