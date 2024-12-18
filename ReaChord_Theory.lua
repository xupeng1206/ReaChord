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
G_CHORD_PATTERNS_2 = {}
G_CHORD_TYPES = {}
G_ALL_CHORD_TYPES = {"Major", "Minor", "Dominant", "Suspended", "Augmented", "Diminished"}
G_CHORD_COLOR_NOTES = {"b2 | b9","2 | 9","b3 | #2 | #9","4 | 11","b5 | #4 | #11","b6 | #5 | b13","6 | 13"," b7 | #6","7"}

-- Major chords

table.insert(G_CHORD_NAMES, "X")
table.insert(G_CHORD_PATTERNS, "1,3,5")
table.insert(G_CHORD_PATTERNS_2, "1 5 8")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM7 omit3")
table.insert(G_CHORD_PATTERNS, "1,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 8 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM7 omit5")
table.insert(G_CHORD_PATTERNS, "1,3,7")
table.insert(G_CHORD_PATTERNS_2, "1 5 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM7")
table.insert(G_CHORD_PATTERNS, "1,3,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 5 8 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM9 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM9")
table.insert(G_CHORD_PATTERNS, "1,2,3,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 8 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM11 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,4,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 6 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM11 omit9")
table.insert(G_CHORD_PATTERNS, "1,3,4,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 5 6 8 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM11")
table.insert(G_CHORD_PATTERNS, "1,2,3,4,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 6 8 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM13 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,4,6,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 6 10 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM13 omit9")
table.insert(G_CHORD_PATTERNS, "1,3,4,5,6,7")
table.insert(G_CHORD_PATTERNS_2, "1 5 6 8 10 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM13")
table.insert(G_CHORD_PATTERNS, "1,2,3,4,5,6,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 6 8 10 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "X6 omit3")
table.insert(G_CHORD_PATTERNS, "1,5,6")
table.insert(G_CHORD_PATTERNS_2, "1 8 10")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "X6")
table.insert(G_CHORD_PATTERNS, "1,3,5,6")
table.insert(G_CHORD_PATTERNS_2, "1 5 8 10")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "X69 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,6")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 10")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "X69")
table.insert(G_CHORD_PATTERNS, "1,2,3,5,6")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 8 10")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM7#11 omit5")
table.insert(G_CHORD_PATTERNS, "1,3,#4,7")
table.insert(G_CHORD_PATTERNS_2, "1 5 7 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM7#11")
table.insert(G_CHORD_PATTERNS, "1,3,#4,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 5 7 8 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM9#11 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,#4,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 7 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM9#11")
table.insert(G_CHORD_PATTERNS, "1,2,3,#4,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 7 8 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM13#11 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,#4,6,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 7 10 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM13#11 omit9")
table.insert(G_CHORD_PATTERNS, "1,3,#4,5,6,7")
table.insert(G_CHORD_PATTERNS_2, "1 5 7 8 10 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "XM13#11")
table.insert(G_CHORD_PATTERNS, "1,2,3,#4,5,6,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 7 8 10 12")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "Xadd9 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3")
table.insert(G_CHORD_PATTERNS_2, "1 3 5")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "Xadd9")
table.insert(G_CHORD_PATTERNS, "1,2,3,5")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 8")
table.insert(G_CHORD_TYPES, "Major")

table.insert(G_CHORD_NAMES, "Xadd11")
table.insert(G_CHORD_PATTERNS, "1,3,4,5")
table.insert(G_CHORD_PATTERNS_2, "1 5 6 8")
table.insert(G_CHORD_TYPES, "Major")

-- Minor

table.insert(G_CHORD_NAMES, "Xm")
table.insert(G_CHORD_PATTERNS, "1,b3,5")
table.insert(G_CHORD_PATTERNS_2, "1 4 8")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm7 omit5")
table.insert(G_CHORD_PATTERNS, "1,b3,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm7")
table.insert(G_CHORD_PATTERNS, "1,b3,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 8 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "XmM7 omit5")
table.insert(G_CHORD_PATTERNS, "1,b3,7")
table.insert(G_CHORD_PATTERNS_2, "1 4 12")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "XmM7")
table.insert(G_CHORD_PATTERNS, "1,b3,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 4 8 12")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "XmM9 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,b3,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 12")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "XmM9")
table.insert(G_CHORD_PATTERNS, "1,2,b3,5,7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 8 12")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm9 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,b3,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm9")
table.insert(G_CHORD_PATTERNS, "1,2,b3,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 8 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm11 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,b3,4,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 6 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm11 omit9")
table.insert(G_CHORD_PATTERNS, "1,b3,4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 6 8 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm11")
table.insert(G_CHORD_PATTERNS, "1,2,b3,4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 6 8 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm13 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,b3,4,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 6 10 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm13 omit9")
table.insert(G_CHORD_PATTERNS, "1,b3,4,5,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 6 8 10 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm13")
table.insert(G_CHORD_PATTERNS, "1,2,b3,4,5,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 6 8 10 11")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm6")
table.insert(G_CHORD_PATTERNS, "1,b3,5,6")
table.insert(G_CHORD_PATTERNS_2, "1 4 8 10")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm69 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,b3,6")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 10")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xm69")
table.insert(G_CHORD_PATTERNS, "1,2,b3,5,6")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 8 10")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xmadd9 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,b3")
table.insert(G_CHORD_PATTERNS_2, "1 3 4")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xmadd9")
table.insert(G_CHORD_PATTERNS, "1,2,b3,5")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 8")
table.insert(G_CHORD_TYPES, "Minor")

table.insert(G_CHORD_NAMES, "Xmadd11")
table.insert(G_CHORD_PATTERNS, "1,b3,4,5")
table.insert(G_CHORD_PATTERNS_2, "1 4 6 8")
table.insert(G_CHORD_TYPES, "Minor")

-- Dominant

table.insert(G_CHORD_NAMES, "X7 omit3")
table.insert(G_CHORD_PATTERNS, "1,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7 omit5")
table.insert(G_CHORD_PATTERNS, "1,3,b7")
table.insert(G_CHORD_PATTERNS_2, "1 5 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7")
table.insert(G_CHORD_PATTERNS, "1,3,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 5 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X9 omit3")
table.insert(G_CHORD_PATTERNS, "1,2,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X9 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X9")
table.insert(G_CHORD_PATTERNS, "1,2,3,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X13 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 10 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X13 omit9")
table.insert(G_CHORD_PATTERNS, "1,3,5,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 5 8 10 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X13")
table.insert(G_CHORD_PATTERNS, "1,2,3,5,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 8 10 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7#11 omit5")
table.insert(G_CHORD_PATTERNS, "1,3,#4,b7")
table.insert(G_CHORD_PATTERNS_2, "1 5 7 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7#11")
table.insert(G_CHORD_PATTERNS, "1,3,#4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 5 7 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X9#11 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,3,#4,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 7 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X9#11")
table.insert(G_CHORD_PATTERNS, "1,2,3,#4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 7 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7b9 omit5")
table.insert(G_CHORD_PATTERNS, "1,b2,3,b7")
table.insert(G_CHORD_PATTERNS_2, "1 2 5 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7b9")
table.insert(G_CHORD_PATTERNS, "1,b2,3,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 2 5 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7b9#11")
table.insert(G_CHORD_PATTERNS, "1,b2,3,#4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 2 5 7 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7#9 omit5")
table.insert(G_CHORD_PATTERNS, "1,#2,3,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 5 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7#9")
table.insert(G_CHORD_PATTERNS, "1,#2,3,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 5 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7#5#9")
table.insert(G_CHORD_PATTERNS, "1,#2,3,#5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 5 9 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7#9#11")
table.insert(G_CHORD_PATTERNS, "1,#2,3,#4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 5 7 8 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X13b9")
table.insert(G_CHORD_PATTERNS, "1,b2,3,5,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 2 5 8 10 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X13#11")
table.insert(G_CHORD_PATTERNS, "1,2,3,#4,5,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 7 8 10 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X7 add13")
table.insert(G_CHORD_PATTERNS, "1,3,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 5 10 11")
table.insert(G_CHORD_TYPES, "Dominant")

table.insert(G_CHORD_NAMES, "X13b5")
table.insert(G_CHORD_PATTERNS, "1,2,3,b5,6,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 5 7 10 11")
table.insert(G_CHORD_TYPES, "Dominant")


-- Suspended

table.insert(G_CHORD_NAMES, "Xsus4")
table.insert(G_CHORD_PATTERNS, "1,4,5")
table.insert(G_CHORD_PATTERNS_2, "1 6 8")
table.insert(G_CHORD_TYPES, "Suspended")

table.insert(G_CHORD_NAMES, "Xsus2")
table.insert(G_CHORD_PATTERNS, "1,2,5")
table.insert(G_CHORD_PATTERNS_2, "1 3 8")
table.insert(G_CHORD_TYPES, "Suspended")

table.insert(G_CHORD_NAMES, "X7sus4 omit5")
table.insert(G_CHORD_PATTERNS, "1,4,b7")
table.insert(G_CHORD_PATTERNS_2, "1 6 11")
table.insert(G_CHORD_TYPES, "Suspended")

table.insert(G_CHORD_NAMES, "X7sus4")
table.insert(G_CHORD_PATTERNS, "1,4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 6 8 11")
table.insert(G_CHORD_TYPES, "Suspended")

table.insert(G_CHORD_NAMES, "X11 omit5")
table.insert(G_CHORD_PATTERNS, "1,2,4,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 6 11")
table.insert(G_CHORD_TYPES, "Suspended")

table.insert(G_CHORD_NAMES, "X11 omit9")
table.insert(G_CHORD_PATTERNS, "1,4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 6 8 11")
table.insert(G_CHORD_TYPES, "Suspended")

table.insert(G_CHORD_NAMES, "X11")
table.insert(G_CHORD_PATTERNS, "1,2,4,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 6 8 11")
table.insert(G_CHORD_TYPES, "Suspended")


-- Augmented

table.insert(G_CHORD_NAMES, "Xaug")
table.insert(G_CHORD_PATTERNS, "1,3,#5")
table.insert(G_CHORD_PATTERNS_2, "1 5 9")
table.insert(G_CHORD_TYPES, "Augmented")

table.insert(G_CHORD_NAMES, "Xaug7")
table.insert(G_CHORD_PATTERNS, "1,3,#5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 5 9 11")
table.insert(G_CHORD_TYPES, "Augmented")

table.insert(G_CHORD_NAMES, "XaugM7")
table.insert(G_CHORD_PATTERNS, "1,3,#5,7")
table.insert(G_CHORD_PATTERNS_2, "1 5 9 12")
table.insert(G_CHORD_TYPES, "Augmented")

-- Diminished

table.insert(G_CHORD_NAMES, "Xdim")
table.insert(G_CHORD_PATTERNS, "1,b3,b5")
table.insert(G_CHORD_PATTERNS_2, "1 4 7")
table.insert(G_CHORD_TYPES, "Diminished")

table.insert(G_CHORD_NAMES, "Xdim7")
table.insert(G_CHORD_PATTERNS, "1,b3,b5,6")
table.insert(G_CHORD_PATTERNS_2, "1 4 7 10")
table.insert(G_CHORD_TYPES, "Diminished")

table.insert(G_CHORD_NAMES, "Xm7b5")
table.insert(G_CHORD_PATTERNS, "1,b3,b5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 4 7 11")
table.insert(G_CHORD_TYPES, "Diminished")

table.insert(G_CHORD_NAMES, "Xm7b9")
table.insert(G_CHORD_PATTERNS, "1,b2,b3,5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 2 4 8 11")
table.insert(G_CHORD_TYPES, "Diminished")

table.insert(G_CHORD_NAMES, "Xm7b5b9")
table.insert(G_CHORD_PATTERNS, "1,b2,b3,b5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 2 4 7 11")
table.insert(G_CHORD_TYPES, "Diminished")

table.insert(G_CHORD_NAMES, "Xm7b9 omit5")
table.insert(G_CHORD_PATTERNS, "1,b2,b3,b7")
table.insert(G_CHORD_PATTERNS_2, "1 2 4 11")
table.insert(G_CHORD_TYPES, "Diminished")

table.insert(G_CHORD_NAMES, "Xm9b5")
table.insert(G_CHORD_PATTERNS, "1,2,b3,b5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 7 11")
table.insert(G_CHORD_TYPES, "Diminished")

table.insert(G_CHORD_NAMES, "Xm11b5")
table.insert(G_CHORD_PATTERNS, "1,2,b3,4,b5,b7")
table.insert(G_CHORD_PATTERNS_2, "1 3 4 6 7 11")
table.insert(G_CHORD_TYPES, "Diminished")


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

function T_ChordType(chord)
    local _, tag = T_SplitChordRootAndPattern(chord)
    local idx = ListIndex(G_CHORD_NAMES, "X"..tag)
    if idx > 0 then
        return G_CHORD_TYPES[idx]
    end
    return "Major"
end

function T_ChordFilter(chord, type, colors)
    local _, tag = T_SplitChordRootAndPattern(chord)
    local idx = ListIndex(G_CHORD_NAMES, "X"..tag)
    if idx == 0 then
        return false
    end
    if G_CHORD_TYPES[idx] ~= type then
        return false
    end

    
    if #colors == 0 then
        return true
    end
    
    local s_note = StringSplit(G_CHORD_PATTERNS[idx], ",")

    for _, color in ipairs(colors) do
        local found = false
        for _, note in ipairs(StringSplit(color, "|")) do
            local clean_note = StringTrim(note)
            if ListIndex(s_note, clean_note) > 0 then
                found = true
                break
            end
        end
        if found == false then
            return false
        end
    end
    return true
end

function T_ChordListFilter(chords, type, colors)
    local filtered_chords = {}
    for _, chord in ipairs(chords) do
        if T_ChordFilter(chord, type, colors) then
            table.insert(filtered_chords, chord)
        end
    end
    return filtered_chords
end

function T_NotePitchToNote(note, scale_root)
    local _, m_notes = T_Parse(scale_root, G_WHOLE_HALF_SCALE_PATTERN)
    if note >= 12 then
        repeat
            note = note - 12
        until note < 12
    end
    local note_names = StringSplit(G_NOTE_LIST[note+1], "/")
    for _, name in ipairs(note_names) do
        if ListIndex(m_notes, name) > 1 then
            return name
        end
    end
    return note_names[1]
end

function T_NotesToChords(notes, scale_root)
    local chords = {}
    local chord_details = {}
    -- sorted notes
    if #notes <= 2 then
        return chords, chord_details
    end

    -- make note in 1 oct and sorted
    local first_node = notes[1]
    local p_notes = {}
    local p_notes_128 = {}
    for idx, note in ipairs(notes) do
        local p_note = note
        if p_note - first_node >= 12 then
            repeat
                p_note = p_note - 12
            until p_note - first_node < 12
        end
        p_notes_128[p_note+1] = 1
    end
    for i = 1, 128 do
        if p_notes_128[i] == 1 then
            table.insert(p_notes, i-1)
        end
    end

    -- all shift
    local all_p_notes = {DeepCopyList(p_notes)}
    for i = 1, #p_notes -1 do
        local p_notes_l, p_notes_r = SplitListAtIndex(p_notes, i)
        local new_p_notes_l = {}
        for _, n in ipairs(p_notes_l) do
            -- shift
            table.insert(new_p_notes_l, n+12)
        end
        local new_p_notes = ListExtend(p_notes_r, new_p_notes_l)
        local new_new_p_notes = {}
        if new_p_notes[#new_p_notes] > 127 then
            for _, n in ipairs(new_p_notes) do
                table.insert(new_new_p_notes, n-12)
            end
        else
            new_new_p_notes = new_p_notes
        end
        table.insert(all_p_notes, new_new_p_notes)
    end
    for _, one in ipairs(all_p_notes) do
        local t_root_note = one[1]
        local t_tag_notes = {}
        for _, note in ipairs(one) do
            local t_tag_note = note - (t_root_note - 1)
            table.insert(t_tag_notes, tostring(t_tag_note))
        end
        local pattern2 = ListJoinToString(t_tag_notes, " ")
        local tag_index = ListIndex(G_CHORD_PATTERNS_2, pattern2)
        if tag_index>0 then
            local tag_name = StringSplit(G_CHORD_NAMES[tag_index], "X")[2]
            local t_root_note_str = T_NotePitchToNote(t_root_note, scale_root)
            table.insert(chords, t_root_note_str..tag_name)
            table.insert(chord_details, {t_root_note_str, tag_name})
        end
    end
    return chords, chord_details
end

function T_SelectSimplestChord(chords)
    if #chords == 0 then
        return -1
    end
    local short_chords = {}
    local short_length = math.huge
    for idx, chord in ipairs(chords) do
        if #chord < short_length then
            short_length = #chord
            short_chords = {}
        end
        if #chord == short_length then
            table.insert(short_chords, idx)
        end
    end
    if #short_chords == 1 {
        return ListIndex(chords, short_chords[1])
    }
    local chord_complexity = {}
    for idx, chord in ipairs(short_chords) do
        if ListIndex(chord_complexity, chord) == -1 then
            chord_complexity[chord] = 0
        end
        if string.find(chord, "/") ~= nil then  -- contains
            chord_complexity[chord] = chord_complexity[chord] + 1
        end
        if string.find(chord, "omit") ~=nil then
            chord_complexity[chord] = chord_complexity[chord] + 2
        end
    end
    local simple_chords = {}
    local lowest_nun = math.huge
    for chord, num in ipairs(simple_chords) do
        if num < lowest_nun then
            lowest_nun = num
            simple_chords = {}
        end
        if num == lowest_nun then
            table.insert(simple_chords, chord)
        end
    end
    return ListIndex(chords, simple_chords[1])
end