-- @description ReaChord
-- @author xupeng1206
-- @version 1.0.13
-- @changelog
--  Update
-- @provides
--   [main] ReaChord_Reader.lua
--   [main] ReaChord_Reader_Start.lua
--   [main] ReaChord_Act_Item2Sound.lua
--   [main] ReaChord_ColorPalette.lua
--   ReaChord_Reaper.lua
--   ReaChord_Theory.lua
--   ReaChord_Util.lua
--   ReaChord_Banks.txt
--   ReaChord_About.jpg
--   doc/*.png

local r = reaper
print = r.ShowConsoleMsg
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Theory.lua')
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Reaper.lua')

local ctx = r.ImGui_CreateContext('ReaChord', r.ImGui_ConfigFlags_DockingEnable())
local G_FONT = r.ImGui_CreateFont('sans-serif', 15)
r.ImGui_Attach(ctx, G_FONT)

local FLT_MIN, FLT_MAX = r.ImGui_NumericLimits_Float()

local CHORD_PAD_KEYS = { "[A]", "[W]", "[S]", "[E]", "[D]", "[F]", "[T]", "[G]", "[Y]", "[H]", "[U]", "[J]" }
local CHORD_PAD_VALUES = { "[A]", "[W]", "[S]", "[E]", "[D]", "[F]", "[T]", "[G]", "[Y]", "[H]", "[U]", "[J]" }
local CHORD_PAD_METAS = { "", "", "", "", "", "", "", "", "", "", "", "" }
local CHORD_PAD_SELECTED = ""

local CHORD_INSERT_MODE = "off"
local CHORD_SIMILAR_MODE = "off"
local SCALE_BY_CHORD_MODE = "off"

local OCT_RANGE = { "-2", "-1", "0", "+1", "+2" }
local ABOUT_IMG

local CHORD_PROGRESSION_LIST = {}
local CHORD_PROGRESSION_SIMPLE_LIST = {}
local CHORD_PROGRESSION_SELECTED_INDEX = 0
local CHORD_PROGRESSION_FILTER = ""
local CHORD_PROGRESSION_SIMPLE_LIST_FILTERED = {}
local CHORD_PROGRESSION_SIMPLE_LIST_FILTERED_INDEX_MAP = {}

-- Add bank popup global values
local B_BANK_TAG = "Pattern 1"
local B_FULL_CHORD_PATTERNS = ""
local B_CHORD_PATTERNS = ""

local CURRENT_SCALE_ROOT = "C"
local CURRENT_SCALE_NAME = "Natural Maj"
local CURRENT_SCALE_ALL_NOTES = {}
local CURRENT_SCALE_NICE_NOTES = {}
local CURRENT_OCT = "0"
local CURRENT_INSERT_BEATS = 4

local CURRENT_CHORD_ROOT = "C"
local CURRENT_CHORD_NAME = ""
local CURRENT_CHORD_FULL_NAME = ""
local CURRENT_CHORD_BASS = "C"
local CURRENT_CHORD_DEFAULT_VOICING = ""
local CURRENT_CHORD_DEFAULT_NOTE_SELECT = ""
local CURRENT_CHORD_VOICING = ""
local CURRENT_CHORD_PITCHED = {}
local CURRENT_CHORD_LIST = {}
local CURRENT_NICE_CHORD_LIST = {}
local CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE = 0

local CURRENT_ANALYSIS_CHORD = ""
local CURRENT_SIMILAR_CHORDS = {}
local CURRENT_SELECTED_SIMILAR_CHORD = ""
local CURRENT_SELECTED_SIMILAR_CHORD_PITCHED = {}
local CURRENT_SCALES_FOR_ANALYSIS_CHORD = {}
local CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD = ""
local CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD_PITCHED = {}

local ColorMainBackground = 0xEEE9E9FF
local ColorPianoWhite = 0xFFFFFFFF
local ColorPianoBlack = 0x000000FF
local ColorGray = 0x696969FF
local ColorPink = 0xFF6EB4FF
local ColorYellow = 0xCD950CFF
local ColorDarkPink = 0xBC8F8FFF
local ColorMiniPianoBlack = 0x6C7B8BFF
local ColorRed = 0xCD2626FF
local ColorBlue = 0x0000FFFF
local ColorNormalNote = 0x838B8BFF
local ColorBtnHover = 0x4876FFFF
local ColorChordPadDefault = 0x8DB6CDFF

local ColorPieBtnLR = 0x555555FF
local ColorPieBtnU1 = 0xff00ffff
local ColorPieBtnU2 = 0xff00ffaa
local ColorPieBtnD1 = 0x00aaaaff
local ColorPieBtnD2 = 0x00aaaaaa
local ColorPieBtnHoverd = 0x4772B3FF

local min_w = 850
local min_h = 600
local main_window_w_padding = 10
local main_window_h_padding = 5
local w
local h
local w_piano_space = 2
local w_piano_key
local w_piano_half_key
local h_piano = 20
local w_default_space = 4
local h_default_space = 4
local w_chord_pad_space = 4
local h_chord_pad_space = 4
local w_chord_pad
local w_chord_pad_half
local h_chord_pad = 30

--! CIRCLE OF FIFTS VARS
local CIRCLE_OF5 = false
local OLD_CIRCLE_OF5 = false
local pi, cos, sin, atan = math.pi, math.cos, math.sin, math.atan
local LAST_PIE_SCALE = "MAJ"
local ANIM_STOP = true
local RADIUS = 150
local CUR_POS = 0
local NEW_POS = 1
local btn_w, btn_h = 45, 18
local draw_list = r.ImGui_GetWindowDrawList(ctx)
local w_circle_of_5 = 400

--! THIS SHOULD BE READ FROM CURRENT DATA
--! JUST FOR INITIAL IMPLEMENTATION USE HARDCODED
local LAST_PIE_ROOT_VAL = 0
local items_maj = {"C","G","D","A","E","B","Gb","Db","Ab","Eb", "Bb","F"}
-- local items_min = {"Am","Em","Bm","F#m","C#m","G#m","Ebm","Bbm","Fm","Cm","Gm","Dm" }
-- local items_min = {"Am","Em","Bm","Gbm","Dbm","Abm","Ebm","Bbm","Fm","Cm","Gm","Dm"}
local items_min = {"A","E","B","Gb","Db","Ab","Eb","Bb","F","C","G","D"}

local prog = {
  ["MAJ"] = {
    ["MAJ"] = { [0] = "I", [1] = "V", [11] = "IV", [-1] = "IV" },
    ["MIN"] = { [0] = "vi", [1] = "iii", [2] = "vii", [11] = "ii", [-1] = "ii" },
  },
  ["MIN"] = {
    ["MAJ"] = { [0] = 3, [1] = 7, [11] = 6, [-1] = 6 },
    ["MIN"] = { [0] = 1, [1] = 5, [2] = 2, [11] = 4, [-1] = 4 },
  },
}

local function pow(x, p) return x ^ p end
local function outCubic(t, b, c, d)
  t = t / d - 1
  return c * (pow(t, 3) + 1) + b
end
--! CIRCLE OF FIFTS END

local function refreshWindowSize()
  w, h = r.ImGui_GetWindowSize(ctx)
  w, h = w - main_window_w_padding * 2, h - 25
  --! REDUCE SIZE OF WINDOW WHEN CICRLE IS SHOWN (FOR DYNAMIC BUTTON EXPAND/SHRINK)
  if CIRCLE_OF5 then
    w = w - w_circle_of_5
  end
  if package.config:sub(1, 1) == "/" then
    -- mac or linux?
    -- h = h -15
  end
  w_piano_key = math.max(4, w / 49 - 2)
  w_piano_half_key = math.max(2, w / 98 - 1)
  w_chord_pad = math.max(4, w / 7 - 4)
  w_chord_pad_half = math.max(2, w / 14 - 2)
end


local function refreshColors()
  local colors = R_GetColorConf()
  for name, color in pairs(colors) do
    if name == "ColorMainBackground" then
      ColorMainBackground = color
    end
    if name == "ColorPianoWhite" then
      ColorPianoWhite = color
    end
    if name == "ColorPianoBlack" then
      ColorPianoBlack = color
    end
    if name == "ColorGray" then
      ColorGray = color
    end
    if name == "ColorPink" then
      ColorPink = color
    end
    if name == "ColorYellow" then
      ColorYellow = color
    end
    if name == "ColorDarkPink" then
      ColorDarkPink = color
    end
    if name == "ColorMiniPianoBlack" then
      ColorMiniPianoBlack = color
    end
    if name == "ColorRed" then
      ColorRed = color
    end
    if name == "ColorBlue" then
      ColorBlue = color
    end
    if name == "ColorNormalNote" then
      ColorNormalNote = color
    end
    if name == "ColorBtnHover" then
      ColorBtnHover = color
    end
    if name == "ColorChordPadDefault" then
      ColorChordPadDefault = color
    end
    if name == "ColorPieBtnLR" then
      ColorPieBtnLR = color
    end
    if name == "ColorPieBtnU1" then
      ColorPieBtnU1 = color
    end
    if name == "ColorPieBtnU2" then
      ColorPieBtnU2 = color
    end
    if name == "ColorPieBtnD1" then
      ColorPieBtnD1 = color
    end
    if name == "ColorPieBtnD2" then
      ColorPieBtnD2 = color
    end
    if name == "ColorPieBtnHoverd" then
      ColorPieBtnHoverd = color
    end
  end
end

local function changeWindowSizeForCircle()
  if CIRCLE_OF5 then
    r.ImGui_SetWindowSizeEx( ctx, "ReaChord", w+w_circle_of_5, h)
  else
    r.ImGui_SetWindowSizeEx( ctx, "ReaChord", w-w_circle_of_5, h)
  end
end

local function onFullChordNameChange()
  if CURRENT_CHORD_ROOT == CURRENT_CHORD_BASS then
    CURRENT_CHORD_FULL_NAME = CURRENT_CHORD_NAME
  else
    CURRENT_CHORD_FULL_NAME = CURRENT_CHORD_NAME .. "/" .. CURRENT_CHORD_BASS
  end
  local voicing = StringSplit(CURRENT_CHORD_VOICING, ",")
  local notes = ListExtend({ CURRENT_CHORD_BASS }, voicing)
  CURRENT_CHORD_PITCHED, _ = T_NotePitched(notes, CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE)
end

local function PlayPiano()
  local voicing = StringSplit(CURRENT_CHORD_VOICING, ",")
  local notes = ListExtend({ CURRENT_CHORD_BASS }, voicing)
  local note_midi_index
  _, note_midi_index = T_NotePitched(notes, CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE)
  R_StopPlay()
  local midi_notes = {}
  for _, midi_index in ipairs(note_midi_index) do
    table.insert(midi_notes, midi_index + 36 + CURRENT_OCT * 12)
  end
  R_Play(midi_notes)
end

local function playChordPad(key_idx)
  local full_meta = CHORD_PAD_METAS[key_idx]
  local full_meta_split = StringSplit(full_meta, "|")
  if #full_meta_split > 1 then
    local notes = full_meta_split[2]
    local oct = StringSplit(full_meta_split[1], "/")[3]
    local oct_shift_after_first_note = 0
    if #full_meta_split > 2 then
      oct_shift_after_first_note = tonumber(full_meta_split[3])
    end
    local note_split = StringSplit(notes, ",")
    local note_midi_index
    _, note_midi_index = T_NotePitched(note_split, oct_shift_after_first_note)
    local midi_notes = {}
    for _, midi_index in ipairs(note_midi_index) do
      table.insert(midi_notes, midi_index + 36 + oct * 12)
    end
    R_Play(midi_notes)
  end
end


local function onSelectChordChange(val)
  CURRENT_CHORD_NAME = val

  local default_voicing = {}
  default_voicing, _ = T_MakeChord(CURRENT_CHORD_NAME)
  CURRENT_CHORD_DEFAULT_VOICING = ListJoinToString(default_voicing, ",")
  CURRENT_CHORD_VOICING = CURRENT_CHORD_DEFAULT_VOICING
  onFullChordNameChange()
end

local function onVoicingShift(direction)
  local voicing = CURRENT_CHORD_VOICING
  local voicing_split = StringSplit(voicing, ",")
  local notes = DeepCopyList(voicing_split)
  local function notesort(a, b)
    return a > b
  end
  table.sort(notes, notesort)
  local all_voicing_split = PermuteList(notes)
  local cur_idx = 0
  for i, v in ipairs(all_voicing_split) do
    local tmp_voicing = ListJoinToString(v, ",")
    if tmp_voicing == CURRENT_CHORD_VOICING then
      cur_idx = i
    end
  end

  if direction == "<" then
    cur_idx = cur_idx - 1
    if cur_idx == 0 then
      cur_idx = #all_voicing_split
    end
  end
  if direction == ">" then
    cur_idx = cur_idx + 1
    if cur_idx > #all_voicing_split then
      cur_idx = 1
    end
  end
  voicing_split = all_voicing_split[cur_idx]
  CURRENT_CHORD_VOICING = ListJoinToString(voicing_split, ",")
  local notes = ListExtend({ CURRENT_CHORD_BASS }, voicing_split)
  CURRENT_CHORD_PITCHED, _ = T_NotePitched(notes, CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE)
end

local function onOctShift(direction)
  local cur_idx = 0
  for i, v in ipairs(OCT_RANGE) do
    if v == CURRENT_OCT then
      cur_idx = i
    end
  end

  if direction == "<" then
    cur_idx = cur_idx - 1
    if cur_idx == 0 then
      cur_idx = #OCT_RANGE
    end
  end
  if direction == ">" then
    cur_idx = cur_idx + 1
    if cur_idx > #OCT_RANGE then
      cur_idx = 1
    end
  end

  CURRENT_OCT = OCT_RANGE[cur_idx]
end

local function refreshUIWhenChordRootChange()
  local nice_chords = {}
  local normal_chords = {}
  local chords = {}
  for _, chord_tag in ipairs(G_CHORD_NAMES) do
    local chord = CURRENT_CHORD_ROOT
    local chord_tag_split = StringSplit(chord_tag, "X")
    if #chord_tag_split > 1 then
      chord = CURRENT_CHORD_ROOT .. chord_tag_split[2]
    end
    if T_ChordInScale(chord, CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME) then
      table.insert(nice_chords, chord)
    else
      table.insert(normal_chords, chord)
    end
    table.insert(chords, chord)
  end
  if #nice_chords > 0 then
    onSelectChordChange(nice_chords[1])
    PlayPiano()
  else
    onSelectChordChange(normal_chords[1])
    PlayPiano()
  end
  CURRENT_NICE_CHORD_LIST = nice_chords
  -- CURRENT_CHORD_LIST = ListExtend(nice_chords, normal_chords)
  CURRENT_CHORD_LIST = chords
end

local function refreshUIWhenScaleChange()
  local notes = {}
  CURRENT_SCALE_NICE_NOTES, _ = T_MakeScale(CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME)
  local scale_root_index_start = T_NoteIndex(G_NOTE_LIST_X4, CURRENT_SCALE_ROOT)

  for i = scale_root_index_start, scale_root_index_start + 11 do
    local note = G_NOTE_LIST_X4[i]
    local note_split = StringSplit(note, "/")
    if #note_split == 1 then
      table.insert(notes, note)
    else
      local b_note = note_split[1]
      local s_note = note_split[2]
      if ListIndex(CURRENT_SCALE_NICE_NOTES, s_note) > 0 then
        table.insert(notes, s_note)
      else
        table.insert(notes, b_note)
      end
    end
  end

  CURRENT_SCALE_ALL_NOTES = notes

  local nice_chords = {}
  local normal_chords = {}
  for _, chord_tag in ipairs(G_CHORD_NAMES) do
    local chord = CURRENT_CHORD_ROOT
    local chord_tag_split = StringSplit(chord_tag, "X")
    if #chord_tag_split > 1 then
      chord = CURRENT_CHORD_ROOT .. chord_tag_split[2]
    end
    if T_ChordInScale(chord, CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME) then
      table.insert(nice_chords, chord)
    else
      table.insert(normal_chords, chord)
    end
  end
  CURRENT_NICE_CHORD_LIST = nice_chords
  CURRENT_CHORD_LIST = ListExtend(nice_chords, normal_chords)
end


local function refreshUIWhenScaleChangeWithSelectChordChange()
  refreshUIWhenScaleChange()
  if #CURRENT_NICE_CHORD_LIST > 0 then
    onSelectChordChange(CURRENT_NICE_CHORD_LIST[1])
  else
    onSelectChordChange(CURRENT_CHORD_LIST[1])
  end
end

local function onScaleRootChange(val)
  CURRENT_SCALE_ROOT = val
  CURRENT_CHORD_ROOT = val
  CURRENT_CHORD_BASS = val

  --! ROTATE CICRLE OF FIFTS TO TARGET SCALE
  for i = 0, #items_maj-1 do
    if items_maj[i+1] == val then
      -- START ANIMATION
      START_TIME = r.time_precise()
      NEW_POS = CUR_POS + (LAST_PIE_ROOT_VAL-i)
      LAST_PIE_ROOT_VAL = i
    end
  end
  
  -- for i = 0, #items_min-1 do
  --   if items_min[i+1] == val then
  --     START_TIME = r.time_precise()
  --     NEW_POS = CUR_POS + (LAST_PIE_ROOT_VAL-i)
  --     LAST_PIE_ROOT_VAL = i
  --   end
  -- end

  refreshUIWhenScaleChangeWithSelectChordChange()
  r.SetExtState("ReaChord", "ScaleRoot", val, false)
end

local function onScaleNameChange(val)
  CURRENT_SCALE_NAME = val
  CURRENT_CHORD_ROOT = CURRENT_SCALE_ROOT
  CURRENT_CHORD_BASS = CURRENT_SCALE_ROOT
  refreshUIWhenScaleChangeWithSelectChordChange()
  r.SetExtState("ReaChord", "ScaleName", val, false)
end

local function onChordRootChange(val)
  CURRENT_CHORD_ROOT = val
  CURRENT_CHORD_BASS = val
  refreshUIWhenChordRootChange()
end

local function onChordBassChange(val)
  CURRENT_CHORD_BASS = val
  onFullChordNameChange()
  PlayPiano()
end

local function onListenClick()
  PlayPiano()
end

local function onInsertClick()
  local meta = CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME .. "/" .. CURRENT_OCT
  local notes = ListExtend({ CURRENT_CHORD_BASS }, StringSplit(CURRENT_CHORD_VOICING, ","))
  R_InsertChordItem(CURRENT_CHORD_FULL_NAME, meta, notes, CURRENT_INSERT_BEATS, CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE)
end

local function onChordPadAssign(key)
  local key_idx = ListIndex(CHORD_PAD_KEYS, key)
  if CURRENT_CHORD_ROOT == CURRENT_CHORD_BASS then
    CHORD_PAD_VALUES[key_idx] = CURRENT_CHORD_NAME
    local meta = CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME .. "/" .. CURRENT_OCT
    local full_meta = meta .. "|" .. CURRENT_CHORD_BASS .. "," .. CURRENT_CHORD_VOICING .. "|" .. CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE
    CHORD_PAD_METAS[key_idx] = full_meta
  else
    CHORD_PAD_VALUES[key_idx] = CURRENT_CHORD_NAME .. "/" .. CURRENT_CHORD_BASS
    local meta = CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME .. "/" .. CURRENT_OCT
    local full_meta = meta .. "|" .. CURRENT_CHORD_BASS .. "," .. CURRENT_CHORD_VOICING .. "|" .. CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE
    CHORD_PAD_METAS[key_idx] = full_meta
  end
  r.SetExtState("ReaChord", "CHORD_PAD_VALUES", ListJoinToString(CHORD_PAD_VALUES, "~"), false)
  r.SetExtState("ReaChord", "CHORD_PAD_METAS", ListJoinToString(CHORD_PAD_METAS, "~"), false)
end

local function onChordPadTrans(key, shift)
  local key_idx = ListIndex(CHORD_PAD_KEYS, key)
  local chord = CHORD_PAD_VALUES[key_idx]
  local l, _ = SplitListAtIndex(chord, 1)
  if l[1] == "[" then
    return
  end
  local full_meta = CHORD_PAD_METAS[key_idx]
  local full_meta_split = StringSplit(full_meta, "|")
  local notes = StringSplit(full_meta_split[2], ",")
  local pure_voicing = {}
  for idx, v in ipairs(notes) do
      if idx > 1 then
          table.insert(pure_voicing, v)
      end
  end
  local meta = full_meta_split[1]
  local meta_split = StringSplit(meta, "/")
  local scale_root = meta_split[1]
  local scale_name = meta_split[2]
  local oct = meta_split[3]
  local oct_shift_after_first_note = 0
  if #full_meta_split>2 then
    oct_shift_after_first_note=full_meta_split[3]
  end
  local chord_split = StringSplit(chord, "/")
  local new_chord = ''
  local new_pure_chord = ''
  local new_chord_bass = ''
  if #chord_split == 1 then
      new_chord = T_ChordTrans(chord, scale_root .. "/" .. scale_name, shift)
      new_pure_chord = new_chord
      new_chord_bass = string.sub(new_chord, 1, 1)
      if string.sub(new_chord, 2, 2) == "#" or string.sub(new_chord, 2, 2) == "b" then
          new_chord_bass = string.sub(new_chord, 1, 2)
      end
  else
      new_pure_chord = T_ChordTrans(chord_split[1], scale_root .. "/" .. scale_name, shift)
      new_chord_bass = T_NoteTrans(chord_split[2], scale_root .. "/" .. scale_name, shift)
      new_chord = new_pure_chord .. "/" .. new_chord_bass
  end
  local new_scale = T_ScaleTrans(scale_root .. "/" .. scale_name, shift)
  local new_pure_voicing = T_VoicingTrans(new_pure_chord, pure_voicing, shift)

  -- start to trans
  CHORD_PAD_VALUES[key_idx] = new_chord
  local meta = new_scale .. "/" .. oct
  local full_meta = meta .. "|" .. new_chord_bass .. "," .. ListJoinToString(new_pure_voicing, ",") .. "|" .. oct_shift_after_first_note
  CHORD_PAD_METAS[key_idx] = full_meta

  r.SetExtState("ReaChord", "CHORD_PAD_VALUES", ListJoinToString(CHORD_PAD_VALUES, "~"), false)
  r.SetExtState("ReaChord", "CHORD_PAD_METAS", ListJoinToString(CHORD_PAD_METAS, "~"), false)

end

local function initChordPads()
  local notes = {}
  local local_scale_nice_notes, _ = T_MakeScale(CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME)
  local scale_root_index_start = T_NoteIndex(G_NOTE_LIST_X4, CURRENT_SCALE_ROOT)

  for i = scale_root_index_start, scale_root_index_start + 11 do
    local note = G_NOTE_LIST_X4[i]
    local note_split = StringSplit(note, "/")
    if #note_split == 1 then
      table.insert(notes, note)
    else
      local b_note = note_split[1]
      local s_note = note_split[2]
      if ListIndex(local_scale_nice_notes, s_note) > 0 then
        table.insert(notes, s_note)
      else
        table.insert(notes, b_note)
      end
    end
  end

  for idx, note in ipairs(notes) do
    local nice_chords = {}
    local normal_chords = {}
    for _, chord_tag in ipairs(G_CHORD_NAMES) do
      local chord = note
      local chord_tag_split = StringSplit(chord_tag, "X")
      if #chord_tag_split > 1 then
        chord = note .. chord_tag_split[2]
      end
      if T_ChordInScale(chord, CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME) then
        table.insert(nice_chords, chord)
      else
        table.insert(normal_chords, chord)
      end
    end
    local local_chord_list = ListExtend(nice_chords, normal_chords)
    local ceil_chord = local_chord_list[1]
    local ceil_voicing, _ = T_MakeChord(ceil_chord)
    local ceil_voicing_str = ListJoinToString(ceil_voicing, ",")
    local ceil_meta = CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME .. "/" .. CURRENT_OCT
    local ceil_full_meta = ceil_meta .. "|" .. note .. "," .. ceil_voicing_str .. "|" .. CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE
    CHORD_PAD_VALUES[idx] = ceil_chord
    CHORD_PAD_METAS[idx] = ceil_full_meta
  end
  r.SetExtState("ReaChord", "CHORD_PAD_VALUES", ListJoinToString(CHORD_PAD_VALUES, "~"), false)
  r.SetExtState("ReaChord", "CHORD_PAD_METAS", ListJoinToString(CHORD_PAD_METAS, "~"), false)
end

local function chordMapRefresh(key_idx)
  local chord = CHORD_PAD_VALUES[key_idx]
  local full_meta = CHORD_PAD_METAS[key_idx]
  local full_meta_split = StringSplit(full_meta, "|")
  if #full_meta_split > 1 then
    local meta = full_meta_split[1]
    local notes = StringSplit(full_meta_split[2], ",")
    CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE = 0
    if #full_meta_split > 2 then
      CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE = tonumber(full_meta_split[3])
    end

    if chord == "" then
      refreshUIWhenScaleChangeWithSelectChordChange()
    else
      local chord_split = StringSplit(chord, "/")
      local meta_split = StringSplit(meta, "/")

      CURRENT_CHORD_BASS = notes[1]
      CURRENT_CHORD_FULL_NAME = chord
      if #chord_split == 1 then
        CURRENT_CHORD_ROOT = notes[1]
        CURRENT_CHORD_NAME = chord
      else
        CURRENT_CHORD_NAME = chord_split[1]
        local b = string.sub(CURRENT_CHORD_NAME, 2, 2)
        if b == "#" or b == "b" then
          CURRENT_CHORD_ROOT = string.sub(CURRENT_CHORD_NAME, 1, 2)
        else
          CURRENT_CHORD_ROOT = string.sub(CURRENT_CHORD_NAME, 1, 1)
        end
      end
      local CURRENT_CHORD_DEFAULT_VOICING_table, _ = T_MakeChord(CURRENT_CHORD_NAME)
      CURRENT_CHORD_DEFAULT_VOICING = ListJoinToString(CURRENT_CHORD_DEFAULT_VOICING_table, ",")
      local CURRENT_CHORD_VOICING_table = {}
      for idx, v in ipairs(notes) do
        if idx > 1 then
          table.insert(CURRENT_CHORD_VOICING_table, v)
        end
      end
      CURRENT_CHORD_VOICING = ListJoinToString(CURRENT_CHORD_VOICING_table, ",")
      CURRENT_CHORD_PITCHED, _ = T_NotePitched(notes, CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE)
      CURRENT_OCT = meta_split[3]
      CURRENT_SCALE_ROOT = meta_split[1]
      CURRENT_SCALE_NAME = meta_split[2]
      refreshUIWhenScaleChange()
    end
  end
end


local function uiReadOnlyColorBtn(text, color, w)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(), color)
  r.ImGui_Button(ctx, text, w)
  r.ImGui_PopStyleColor(ctx, 3)
end

local function uiColorBtn(text, color, ww, hh)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), ColorBtnHover)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(), ColorBlue)
  local ret = r.ImGui_Button(ctx, text, ww, hh)
  r.ImGui_PopStyleColor(ctx, 3)
  return ret
end

local function uiMiniPianoForSimilarChords()
  local mini_w_half = 13
  local mini_w = 26
  local mini_h = 30
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_piano_space, 0)
  -- black
  r.ImGui_InvisibleButton(ctx, "##", mini_w_half - w_piano_space, mini_h, r.ImGui_ButtonFlags_None())
  for _, note in ipairs({
    "Db0/C#0", "Eb0/D#0", "-", "Gb0/F#0", "Ab0/G#0", "Bb0/A#0", "-",
    "Db1/C#1", "Eb1/D#1", "-", "Gb1/F#1", "Ab1/G#1", "Bb1/A#1", '-',
    "Db2/C#2", "Eb2/D#2", "-", "Gb2/F#2", "Ab2/G#2", "Bb2/A#2"
  }) do
    r.ImGui_SameLine(ctx)
    if note == "-" then
      r.ImGui_InvisibleButton(ctx, "##", mini_w, mini_h, r.ImGui_ButtonFlags_None())
    else
      local note_split = StringSplit(note, "/")
      if ListIndex(CURRENT_SELECTED_SIMILAR_CHORD_PITCHED, note_split[1]) > 0 or ListIndex(CURRENT_SELECTED_SIMILAR_CHORD_PITCHED, note_split[2]) > 0 then
        r.ImGui_ColorButton(ctx, "##", ColorBlue, r.ImGui_ColorEditFlags_NoTooltip(), mini_w, mini_h)
      else
        r.ImGui_ColorButton(ctx, "##", ColorMiniPianoBlack, r.ImGui_ColorEditFlags_NoTooltip(), mini_w, mini_h)
      end
    end
  end
  -- r.ImGui_SameLine(ctx)
  -- r.ImGui_InvisibleButton(ctx, "##", w_piano_half_key, h_piano, r.ImGui_ButtonFlags_None())

  -- white
  for idx, note in ipairs({
    "C0", "D0", "E0", "F0", "G0", "A0", "B0",
    "C1", "D1", "E1", "F1", "G1", "A1", "B1",
    "C2", "D2", "E2", "F2", "G2", "A2", "B2",
  }) do
    if idx > 1 then
      r.ImGui_SameLine(ctx)
    end
    if ListIndex(CURRENT_SELECTED_SIMILAR_CHORD_PITCHED, note) > 0 then
      r.ImGui_ColorButton(ctx, "##", ColorBlue, r.ImGui_ColorEditFlags_NoTooltip(), mini_w, mini_h)
    else
      r.ImGui_ColorButton(ctx, "##", ColorPianoWhite, r.ImGui_ColorEditFlags_NoTooltip(), mini_w, mini_h)
    end
  end
  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiMiniPianoForScalesByChord()
  local mini_w_half = 13
  local mini_w = 26
  local mini_h = 30

  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_piano_space, 0)
  -- black
  r.ImGui_InvisibleButton(ctx, "##", mini_w_half - w_piano_space, mini_h, r.ImGui_ButtonFlags_None())
  for _, note in ipairs({
    "Db0/C#0", "Eb0/D#0", "-", "Gb0/F#0", "Ab0/G#0", "Bb0/A#0", "-",
    "Db1/C#1", "Eb1/D#1", "-", "Gb1/F#1", "Ab1/G#1", "Bb1/A#1", '-',
    "Db2/C#2", "Eb2/D#2", "-", "Gb2/F#2", "Ab2/G#2", "Bb2/A#2"
  }) do
    r.ImGui_SameLine(ctx)
    if note == "-" then
      r.ImGui_InvisibleButton(ctx, "##", mini_w, mini_h, r.ImGui_ButtonFlags_None())
    else
      local note_split = StringSplit(note, "/")
      if ListIndex(CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD_PITCHED, note_split[1]) > 0 or ListIndex(CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD_PITCHED, note_split[2]) > 0 then
        r.ImGui_ColorButton(ctx, "##", ColorBlue, r.ImGui_ColorEditFlags_NoTooltip(), mini_w, mini_h)
      else
        r.ImGui_ColorButton(ctx, "##", ColorMiniPianoBlack, r.ImGui_ColorEditFlags_NoTooltip(), mini_w, mini_h)
      end
    end
  end
  -- r.ImGui_SameLine(ctx)
  -- r.ImGui_InvisibleButton(ctx, "##", w_piano_half_key, h_piano, r.ImGui_ButtonFlags_None())

  -- white
  for idx, note in ipairs({
    "C0", "D0", "E0", "F0", "G0", "A0", "B0",
    "C1", "D1", "E1", "F1", "G1", "A1", "B1",
    "C2", "D2", "E2", "F2", "G2", "A2", "B2",
  }) do
    if idx > 1 then
      r.ImGui_SameLine(ctx)
    end
    if ListIndex(CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD_PITCHED, note) > 0 then
      r.ImGui_ColorButton(ctx, "##", ColorBlue, r.ImGui_ColorEditFlags_NoTooltip(), mini_w, mini_h)
    else
      r.ImGui_ColorButton(ctx, "##", ColorPianoWhite, r.ImGui_ColorEditFlags_NoTooltip(), mini_w, mini_h)
    end
  end
  r.ImGui_PopStyleVar(ctx, 1)
end


local function uiPiano()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_piano_space, 0)
  -- black
  r.ImGui_InvisibleButton(ctx, "##", w_piano_half_key - w_piano_space, h_piano, r.ImGui_ButtonFlags_None())
  for _, note in ipairs({
    "Db0/C#0", "Eb0/D#0", "-", "Gb0/F#0", "Ab0/G#0", "Bb0/A#0", "-",
    "Db1/C#1", "Eb1/D#1", "-", "Gb1/F#1", "Ab1/G#1", "Bb1/A#1", "-",
    "Db2/C#2", "Eb2/D#2", "-", "Gb2/F#2", "Ab2/G#2", "Bb2/A#2", "-",
    "Db3/C#3", "Eb3/D#3", "-", "Gb3/F#3", "Ab3/G#3", "Bb3/A#3", "-",
    "Db4/C#4", "Eb4/D#4", "-", "Gb4/F#4", "Ab4/G#4", "Bb4/A#4", "-",
    "Db5/C#5", "Eb5/D#5", "-", "Gb5/F#5", "Ab5/G#5", "Bb5/A#5", "-",
    "Db6/C#6", "Eb6/D#6", "-", "Gb6/F#6", "Ab6/G#6", "Bb6/A#6"
  }) do
    r.ImGui_SameLine(ctx)
    if note == "-" then
      r.ImGui_InvisibleButton(ctx, "##", w_piano_key, h_piano, r.ImGui_ButtonFlags_None())
    else
      local note_split = StringSplit(note, "/")
      if ListIndex(CURRENT_CHORD_PITCHED, note_split[1]) > 0 or ListIndex(CURRENT_CHORD_PITCHED, note_split[2]) > 0 then
        r.ImGui_ColorButton(ctx, "##", ColorBlue, r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, h_piano)
      else
        r.ImGui_ColorButton(ctx, "##", ColorPianoBlack, r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, h_piano)
      end
    end
  end
  -- r.ImGui_SameLine(ctx)
  -- r.ImGui_InvisibleButton(ctx, "##", w_piano_half_key, h_piano, r.ImGui_ButtonFlags_None())

  -- white
  for idx, note in ipairs({
    "C0", "D0", "E0", "F0", "G0", "A0", "B0",
    "C1", "D1", "E1", "F1", "G1", "A1", "B1",
    "C2", "D2", "E2", "F2", "G2", "A2", "B2",
    "C3", "D3", "E3", "F3", "G3", "A3", "B3",
    "C4", "D4", "E4", "F4", "G4", "A4", "B4",
    "C5", "D5", "E5", "F5", "G5", "A5", "B5",
    "C6", "D6", "E6", "F6", "G6", "A6", "B6"
  }) do
    if idx > 1 then
      r.ImGui_SameLine(ctx)
    end
    if ListIndex(CURRENT_CHORD_PITCHED, note) > 0 then
      r.ImGui_ColorButton(ctx, "##", ColorBlue, r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, h_piano)
    else
      r.ImGui_ColorButton(ctx, "##", ColorPianoWhite, r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, h_piano)
    end
  end
  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordPad()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_chord_pad_space, h_chord_pad_space)
  -- -
  r.ImGui_InvisibleButton(ctx, "##", w_chord_pad_half, h_chord_pad, r.ImGui_ButtonFlags_None())
  -- black
  for idx, key in ipairs({
    "[W]", "[E]", "-", "[T]", "[Y]", "[U]"
  }) do
    r.ImGui_SameLine(ctx)
    if key == "-" then
      r.ImGui_InvisibleButton(ctx, "##", w_chord_pad, h_chord_pad, r.ImGui_ButtonFlags_None())
    else
      local chord = CHORD_PAD_VALUES[ListIndex(CHORD_PAD_KEYS, key)]
      local color = ColorChordPadDefault
      if chord == key then
        color = ColorChordPadDefault
      else
        local pure_chord = StringSplit(chord, "/")[1]
        if T_ChordInScale(pure_chord, CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME) then
          color = ColorPink
        else
          color = ColorNormalNote
        end
      end
      if key == CHORD_PAD_SELECTED then
        color = ColorBlue
      end
      if uiColorBtn(chord .. "##" .. key, color, w_chord_pad, h_chord_pad) then
        CHORD_PAD_SELECTED = key
        local key_idx = ListIndex(CHORD_PAD_KEYS, key)
        R_StopPlay()
        playChordPad(key_idx)
        chordMapRefresh(key_idx)
      end
      if r.ImGui_BeginDragDropTarget(ctx) then
        local rev, _ = r.ImGui_AcceptDragDropPayload(ctx, 'DND_DEMO_CELL')
        if rev then
          onChordPadAssign(key)
        end
        r.ImGui_EndDragDropTarget(ctx)
      end
    end
  end
  -- -
  r.ImGui_SameLine(ctx)
  r.ImGui_InvisibleButton(ctx, "##", w_chord_pad_half, h_chord_pad, r.ImGui_ButtonFlags_None())

  -- white
  for idx, key in ipairs({
    "[A]", "[S]", "[D]", "[F]", "[G]", "[H]", "[J]"
  }) do
    if idx > 1 then
      r.ImGui_SameLine(ctx)
    end
    local chord = CHORD_PAD_VALUES[ListIndex(CHORD_PAD_KEYS, key)]
    local color = ColorChordPadDefault
    if chord == key then
      color = ColorChordPadDefault
    else
      local pure_chord = StringSplit(chord, "/")[1]
      if T_ChordInScale(pure_chord, CURRENT_SCALE_ROOT .. "/" .. CURRENT_SCALE_NAME) then
        color = ColorPink
      else
        color = ColorNormalNote
      end
    end
    if key == CHORD_PAD_SELECTED then
      color = ColorBlue
    end
    if uiColorBtn(chord .. "##" .. key, color, w_chord_pad, h_chord_pad) then
      CHORD_PAD_SELECTED = key
      local key_idx = ListIndex(CHORD_PAD_KEYS, key)
      R_StopPlay()
      playChordPad(key_idx)
      chordMapRefresh(key_idx)
    end
    if r.ImGui_BeginDragDropTarget(ctx) then
      local rev, _ = r.ImGui_AcceptDragDropPayload(ctx, 'DND_DEMO_CELL')
      if rev then
        onChordPadAssign(key)
      end
      r.ImGui_EndDragDropTarget(ctx)
    end
  end

  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiScaleRootSelector()
  if r.ImGui_BeginCombo(ctx, '##ScaleRoot', CURRENT_SCALE_ROOT, r.ImGui_ComboFlags_HeightLarge()) then
    for _, v in ipairs(G_FLAT_NOTE_LIST) do
      local is_selected = CURRENT_SCALE_ROOT == v
      if r.ImGui_Selectable(ctx, v, is_selected) then
        onScaleRootChange(v)
      end

      if is_selected then
        r.ImGui_SetItemDefaultFocus(ctx)
      end
    end
    r.ImGui_EndCombo(ctx)
  end
end

local function uiScaleNameSelector()
  if r.ImGui_BeginCombo(ctx, '##ScalePattern', CURRENT_SCALE_NAME, r.ImGui_ComboFlags_HeightLarge()) then
    for _, v in ipairs(G_SCALE_NAMES) do
      local is_selected = CURRENT_SCALE_NAME == v
      if r.ImGui_Selectable(ctx, v, is_selected) then
        onScaleNameChange(v)
      end

      if is_selected then
        r.ImGui_SetItemDefaultFocus(ctx)
      end
    end
    r.ImGui_EndCombo(ctx)
  end
end

local function uiOctSelector()
  uiReadOnlyColorBtn("Oct:", ColorGray, 50)
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn(CURRENT_OCT, ColorGray, 50)
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "<##oct", 30) then
    onOctShift("<")
    onListenClick()
  end
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, ">##oct", 30) then
    onOctShift(">")
    onListenClick()
  end
end

local function uiCircleOf5Switch()
  if CIRCLE_OF5 then
    if uiColorBtn("Circle Of Five", ColorBlue, 120, 0) then
      CIRCLE_OF5 = not CIRCLE_OF5
      changeWindowSizeForCircle()
    end
  else
    if uiColorBtn("Circle Of Five", ColorNormalNote, 120, 0) then
      CIRCLE_OF5 = not CIRCLE_OF5
      changeWindowSizeForCircle()
    end
  end
end

local function uiTopLine()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("ScaleRoot:", ColorGray, 100)
  r.ImGui_SameLine(ctx)
  r.ImGui_SetNextItemWidth(ctx, 50)
  uiScaleRootSelector()
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("ScaleName:", ColorGray, 100)
  r.ImGui_SameLine(ctx)
  local next_width =  math.max(130,w - 5 * w_default_space - 100 - 50 - 100 - 160 - 3 * w_default_space - 120)
  r.ImGui_SetNextItemWidth(ctx, next_width)
  uiScaleNameSelector()
  r.ImGui_SameLine(ctx)
  -- length 3 * w_default_space + 160
  uiOctSelector()
  r.ImGui_SameLine(ctx)

  --! ADD CIRCLE OF FIFTS TOGGLE
  -- length 120
  uiCircleOf5Switch()
  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiVoicing()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("Notes:", ColorGray, 60)
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn(CURRENT_CHORD_BASS, ColorGray, 35)
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE .. "##voicing", 30) then
    CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE = CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE + 1
    if CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE == 2 then
      CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE = 0
    end
    onListenClick()
  end
  r.ImGui_SameLine(ctx)
  local default_notes = StringSplit(CURRENT_CHORD_DEFAULT_VOICING, ",")
  local nice_notes = StringSplit(CURRENT_CHORD_VOICING, ",")
  for idx, note in ipairs(default_notes) do
    local index = ListIndex(nice_notes, note)
    if index < 0 then
      -- not in
      if uiColorBtn(" " .. note .. " ##voicing_note", ColorGray, 35, 0) then
        table.insert(nice_notes, note)
        onListenClick()
      end
    else
      if uiColorBtn(" " .. note .. " ##voicing_note", ColorBlue, 35, 0) then
        nice_notes = ListDeleteIndex(nice_notes, index)
        onListenClick()
      end
    end
    r.ImGui_SameLine(ctx)
  end
  CURRENT_CHORD_VOICING = ListJoinToString(nice_notes, ",")
  CURRENT_CHORD_PITCHED, _ = T_NotePitched(ListExtend({ CURRENT_CHORD_BASS }, nice_notes), CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE)

  if r.ImGui_Button(ctx, "<##voicing", 30) then
    onVoicingShift("<")
    onListenClick()
  end

  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, ">##voicing", 30) then
    onVoicingShift(">")
    onListenClick()
  end
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "Listen", 60) then
    onListenClick()
  end
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "Insert", 60) then
    onInsertClick()
  end
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("Voicing:", ColorGray, 70)
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn(CURRENT_CHORD_VOICING, ColorGray,
    w - (8 + #default_notes) * w_default_space - 70 - 35 - 30 - 30 - 30 - 60 - 60 - 60 - 35 * #default_notes)

  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordDegree()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("Degree:", ColorGray, 100)
  local items = StringSplit(G_WHOLE_HALF_SCALE_PATTERN, ",")
  for _, note in ipairs(items) do
    r.ImGui_SameLine(ctx)
    uiReadOnlyColorBtn(" " .. note .. " ##chord_degree", ColorGray, (w - 12 * w_default_space - 100) / 12)
  end

  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordRoot()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("ChordRoot:", ColorGray, 100)

  for _, note in ipairs(CURRENT_SCALE_ALL_NOTES) do
    r.ImGui_SameLine(ctx)
    if note == CURRENT_CHORD_ROOT then
      if uiColorBtn(" " .. note .. " ##chord_root", ColorBlue, (w - 12 * w_default_space - 100) / 12, 0) then
        onChordRootChange(note)
      end
    elseif ListIndex(CURRENT_SCALE_NICE_NOTES, note) > 0 then
      if uiColorBtn(" " .. note .. " ##chord_root", ColorPink, (w - 12 * w_default_space - 100) / 12, 0) then
        onChordRootChange(note)
      end
    else
      if uiColorBtn(" " .. note .. " ##chord_root", ColorNormalNote, (w - 12 * w_default_space - 100) / 12, 0) then
        onChordRootChange(note)
      end
    end
  end

  r.ImGui_PopStyleVar(ctx, 1)
end


local function uiChordBass()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("ChordBass:", ColorGray, 100)
  for _, note in ipairs(CURRENT_SCALE_ALL_NOTES) do
    r.ImGui_SameLine(ctx)
    if note == CURRENT_CHORD_BASS then
      if uiColorBtn(" " .. note .. " ##chord_bass", ColorBlue, (w - 12 * w_default_space - 100) / 12, 0) then
        onChordBassChange(note)
      end
    elseif ListIndex(CURRENT_SCALE_NICE_NOTES, note) > 0 then
      if uiColorBtn(" " .. note .. " ##chord_bass", ColorPink, (w - 12 * w_default_space - 100) / 12, 0) then
        onChordBassChange(note)
      end
    else
      if uiColorBtn(" " .. note .. " ##chord_bass", ColorNormalNote, (w - 12 * w_default_space - 100) / 12, 0) then
        onChordBassChange(note)
      end
    end
  end

  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordLength()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("InsertBeats:", ColorGray, 100)
  for _, beats in ipairs({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }) do
    r.ImGui_SameLine(ctx)
    if beats == CURRENT_INSERT_BEATS then
      if uiColorBtn(" " .. beats .. " B ##chord_bass", ColorBlue, (w - 12 * w_default_space - 100) / 12, 0) then
        CURRENT_INSERT_BEATS = beats
      end
    else
      if uiColorBtn(" " .. beats .. " B ##chord_bass", ColorNormalNote, (w - 12 * w_default_space - 100) / 12, 0) then
        CURRENT_INSERT_BEATS = beats
      end
    end
  end

  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiSimilarChords()
  local add_bank_win_flags = r.ImGui_WindowFlags_None()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoScrollbar()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoNav()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoDocking()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_AlwaysAutoResize()

  if r.ImGui_BeginPopup(ctx, 'Similar Chords', add_bank_win_flags) then
    if r.ImGui_Button(ctx, "Close", 100) then
      r.ImGui_CloseCurrentPopup(ctx)
    end
    r.ImGui_SameLine(ctx)
    r.ImGui_Text(ctx, "These chords have two or more same notes with " .. CURRENT_ANALYSIS_CHORD)
    if r.ImGui_BeginListBox(ctx, '##similar_chords', -FLT_MIN, 8 * r.ImGui_GetTextLineHeightWithSpacing(ctx)) then
      for idx, v in ipairs(CURRENT_SIMILAR_CHORDS) do
        local is_selected = CURRENT_SELECTED_SIMILAR_CHORD == v
        if r.ImGui_Selectable(ctx, v, is_selected) then
          CURRENT_SELECTED_SIMILAR_CHORD = v
          local note_midi_index = {}
          if CURRENT_SELECTED_SIMILAR_CHORD ~= "" then
            local pure_notes, _ = T_MakeChord(CURRENT_SELECTED_SIMILAR_CHORD)
            CURRENT_SELECTED_SIMILAR_CHORD_PITCHED, note_midi_index = T_NotePitched(pure_notes, 0)

            R_StopPlay()
            local midi_notes = {}
            for _, midi_index in ipairs(note_midi_index) do
              table.insert(midi_notes, midi_index + 36 + (CURRENT_OCT + 1) * 12)
            end
            R_Play(midi_notes)
          end
        end

        -- Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
        if is_selected then
          r.ImGui_SetItemDefaultFocus(ctx)
        end
      end
      r.ImGui_EndListBox(ctx)
    end

    uiMiniPianoForSimilarChords()
    r.ImGui_EndPopup(ctx)
  end
end

local function uiScalesByChord()
  local add_bank_win_flags = r.ImGui_WindowFlags_None()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoScrollbar()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoNav()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoDocking()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_AlwaysAutoResize()

  if r.ImGui_BeginPopup(ctx, 'Scales By Chord', add_bank_win_flags) then
    if r.ImGui_Button(ctx, "Close", 100) then
      r.ImGui_CloseCurrentPopup(ctx)
    end
    r.ImGui_SameLine(ctx)
    r.ImGui_Text(ctx, "These scales contains " .. CURRENT_ANALYSIS_CHORD)
    if r.ImGui_BeginListBox(ctx, '##scales_by_chord', -FLT_MIN, 8 * r.ImGui_GetTextLineHeightWithSpacing(ctx)) then
      for idx, v in ipairs(CURRENT_SCALES_FOR_ANALYSIS_CHORD) do
        local display_v = ListJoinToString(StringSplit(v, "/"), " | ")
        local is_selected = CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD == display_v
        if r.ImGui_Selectable(ctx, display_v, is_selected) then
          CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD = display_v
          if CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD ~= "" then
            local pure_notes, _ = T_MakeScale(v)
            CURRENT_SELECTED_SCALE_FOR_ANALYSIS_CHORD_PITCHED, _ = T_NotePitched(pure_notes, 0)
          end
        end

        -- Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
        if is_selected then
          r.ImGui_SetItemDefaultFocus(ctx)
        end
      end
      r.ImGui_EndListBox(ctx)
    end

    uiMiniPianoForScalesByChord()
    r.ImGui_EndPopup(ctx)
  end
end

local function uiChordMap()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, h_default_space)

  local lines = math.ceil(#G_CHORD_NAMES / 7)
  local ww = w
  local hh = h - main_window_h_padding * 2 - 2 * lines - h_piano * 2 - 9 * 25 - 7 * 1 - h_chord_pad * 2
  -- 7 x 7
  for i = 0, lines - 1 do
    for j = 1, 7 do
      local idx = i * 7 + j
      if idx > #CURRENT_CHORD_LIST then
        break
      end
      if j > 1 then
        r.ImGui_SameLine(ctx)
      end
      local chord = CURRENT_CHORD_LIST[idx]
      if chord == CURRENT_CHORD_NAME then
        if uiColorBtn(chord .. "##chord", ColorBlue, (ww - 6 * w_default_space) / 7, (hh - 6 * w_default_space) / lines) then
          onSelectChordChange(chord)
          PlayPiano()
          if CHORD_INSERT_MODE == "on" then
            onInsertClick()
          end
          if CHORD_SIMILAR_MODE == "on" then
            CURRENT_ANALYSIS_CHORD = chord
            CURRENT_SIMILAR_CHORDS = T_FindSimilarChords(chord, CURRENT_CHORD_BASS)
            r.ImGui_OpenPopup(ctx, 'Similar Chords')
          end
          if SCALE_BY_CHORD_MODE == "on" then
            CURRENT_ANALYSIS_CHORD = chord
            CURRENT_SCALES_FOR_ANALYSIS_CHORD = T_FindScalesByChord(chord, CURRENT_CHORD_BASS)
            r.ImGui_OpenPopup(ctx, 'Scales By Chord')
          end
        end
        if r.ImGui_BeginDragDropSource(ctx, r.ImGui_DragDropFlags_None()) then
          -- Set payload to carry the index of our item (could be anything)
          r.ImGui_SetDragDropPayload(ctx, 'DND_DEMO_CELL', tostring(idx))

          -- Display preview (could be anything, e.g. when dragging an image we could decide to display
          -- the filename and a small preview of the image, etc.)
          r.ImGui_Text(ctx, ('Chord: %s'):format(CURRENT_CHORD_FULL_NAME))
          r.ImGui_EndDragDropSource(ctx)
        end
      elseif ListIndex(CURRENT_NICE_CHORD_LIST, chord) > 0 then
        if uiColorBtn(chord .. "##chord", ColorPink, (ww - 6 * w_default_space) / 7, (hh - 6 * w_default_space) / lines) then
          onSelectChordChange(chord)
          PlayPiano()
          if CHORD_INSERT_MODE == "on" then
            onInsertClick()
          end
          if CHORD_SIMILAR_MODE == "on" then
            CURRENT_ANALYSIS_CHORD = chord
            CURRENT_SIMILAR_CHORDS = T_FindSimilarChords(chord, CURRENT_CHORD_BASS)
            r.ImGui_OpenPopup(ctx, 'Similar Chords')
          end
          if SCALE_BY_CHORD_MODE == "on" then
            CURRENT_ANALYSIS_CHORD = chord
            CURRENT_SCALES_FOR_ANALYSIS_CHORD = T_FindScalesByChord(chord, CURRENT_CHORD_BASS)
            r.ImGui_OpenPopup(ctx, 'Scales By Chord')
          end
        end
      else
        if uiColorBtn(chord .. "##chord", ColorNormalNote, (ww - 6 * w_default_space) / 7, (hh - 6 * w_default_space) / lines) then
          onSelectChordChange(chord)
          PlayPiano()
          if CHORD_INSERT_MODE == "on" then
            onInsertClick()
          end
          if CHORD_SIMILAR_MODE == "on" then
            CURRENT_ANALYSIS_CHORD = chord
            CURRENT_SIMILAR_CHORDS = T_FindSimilarChords(chord, CURRENT_CHORD_BASS)
            r.ImGui_OpenPopup(ctx, 'Similar Chords')
          end
          if SCALE_BY_CHORD_MODE == "on" then
            CURRENT_ANALYSIS_CHORD = chord
            CURRENT_SCALES_FOR_ANALYSIS_CHORD = T_FindScalesByChord(chord, CURRENT_CHORD_BASS)
            r.ImGui_OpenPopup(ctx, 'Scales By Chord')
          end
        end
      end
    end
  end

  -- temp position
  -- CHORD_INSERT_MODE
  r.ImGui_SameLine(ctx)
  local insert_mode_color = ColorNormalNote
  if CHORD_INSERT_MODE == "on" then
    insert_mode_color = ColorYellow
  end
  if uiColorBtn("<Insert Mode>##mode", insert_mode_color, (ww - 6 * w_default_space) / 7, (hh - 6 * w_default_space) / lines) then
    if CHORD_INSERT_MODE == "on" then
      CHORD_INSERT_MODE = "off"
    else
      CHORD_INSERT_MODE = "on"
    end
  end

  -- SCALE_BY_CHORD_MODE
  r.ImGui_SameLine(ctx)
  local scale_by_chord_color = ColorNormalNote
  if SCALE_BY_CHORD_MODE == "on" then
    scale_by_chord_color = ColorYellow
  end
  if uiColorBtn("<Find Scale>##mode", scale_by_chord_color, (ww - 6 * w_default_space) / 7, (hh - 6 * w_default_space) / lines) then
    if SCALE_BY_CHORD_MODE == "on" then
      SCALE_BY_CHORD_MODE = "off"
    else
      SCALE_BY_CHORD_MODE = "on"
    end
  end
  

  -- CHORD_SIMILAR_MODE
  r.ImGui_SameLine(ctx)
  local similar_chord_color = ColorNormalNote
  if CHORD_SIMILAR_MODE == "on" then
    similar_chord_color = ColorYellow
  end
  if uiColorBtn("<Similar Chord>##mode", similar_chord_color, (ww - 6 * w_default_space) / 7, (hh - 6 * w_default_space) / lines) then
    if CHORD_SIMILAR_MODE == "on" then
      CHORD_SIMILAR_MODE = "off"
    else
      CHORD_SIMILAR_MODE = "on"
    end
  end

  uiSimilarChords()
  uiScalesByChord()

  r.ImGui_PopStyleVar(ctx, 1)
end

local function Anim(begin_val, end_val, duration_in_sec, call_time)
  local time = r.time_precise() - call_time
  local change = end_val - begin_val
  if time >= duration_in_sec then
    CUR_POS = end_val
    START_TIME = nil
    ANIM_STOP = true
    return end_val
  end
  return outCubic(time, begin_val, change, duration_in_sec)
end

function DrawListButton(name, color, hovered)
  local xs, ys = r.ImGui_GetItemRectMin(ctx)
  local xe, ye = r.ImGui_GetItemRectMax(ctx)
  local w, h = xe - xs, ye - ys
  r.ImGui_DrawList_AddRectFilled(draw_list, xs, ys, xe, ye, hovered and ColorPieBtnHoverd or color, 5)

  local label_size = r.ImGui_CalcTextSize(ctx, name)
  local font_size = r.ImGui_GetFontSize(ctx)

  local txt_x = xs + (w / 2) - (label_size / 2)
  local txt_y = ys + (h / 2) - (font_size / 2)

  r.ImGui_DrawList_AddTextEx(draw_list, nil, font_size, txt_x, txt_y, 0xFFFFFFFF, name)
end

function PiePopupSelectMenu(tbl, sc_type, RADIUS_MAX, aw, ah, vx, vy)
  local RADIUS_MIN = 50.0

  local center_x = vx + (aw / 2)
  local center_y = vy + (ah / 2)

  local item_arc_span = (2 * pi) / #tbl

  local ANIM = START_TIME and Anim(CUR_POS, NEW_POS, 0.2, START_TIME) or CUR_POS
  for i = 0, #tbl - 1 do
    local color = ColorPieBtnLR
    local c_idx = i
    c_idx = i > 6 and c_idx - 12 or c_idx
    local item = i + 1
    local item_label = tbl[item]

    local item_ang_min = item_arc_span * (i - 2.02) - (item_arc_span * 0.5)
    local item_ang_max = item_arc_span * (i - 2.98) - (item_arc_span * 0.5)

    local item_ang_min_a = item_arc_span * (i - 2.02) - (item_arc_span * 0.5) + (ANIM * pi / 6)
    local item_ang_max_a = item_arc_span * (i - 2.98) - (item_arc_span * 0.5) + (ANIM * pi / 6)

    --! DYNAMIC PIE CHORD POSITION
    local pos = {
      center_x + cos((item_ang_min_a + item_ang_max_a) * 0.5) * ((RADIUS_MIN + RADIUS_MAX) * 0.8) - (btn_w * 0.5),
      center_y + sin((item_ang_min_a + item_ang_max_a) * 0.5) * ((RADIUS_MIN + RADIUS_MAX) * 0.5) - (btn_h * 0.5),
    }

    --! FOR STATIC CHORD POSITION TEXT DRAW ABOVE CHORDS
    local pos2 = {
      center_x + cos((item_ang_min + item_ang_max) * 0.5) * ((RADIUS_MIN + RADIUS_MAX) * 0.8) - (btn_w * 0.5),
      center_y + sin((item_ang_min + item_ang_max) * 0.5) * ((RADIUS_MIN + RADIUS_MAX) * 0.5) - (btn_h * 0.5),
    }

    if i == 0 or i == 1 or i == 11 or i == 2 then
      r.ImGui_SetCursorScreenPos(ctx, pos2[1] + btn_w / 2.4, pos2[2] - btn_h / 1.2)
      r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), 0xff)
      r.ImGui_Text(ctx, prog[LAST_PIE_SCALE][sc_type][i])
      r.ImGui_PopStyleColor(ctx)
    end

    local t_sin = sin((item_ang_min_a + item_ang_max_a) * 0.5)
    local t_cos = cos((item_ang_min_a + item_ang_max_a) * 0.5)

    if t_sin <= -0.49 then
      if t_cos < 0.87 and t_cos > -0.7 then
        if sc_type == "MAJ" and t_sin > -0.8 then
          --! SKIP MAJOR CHORD
        else
          color = LAST_PIE_SCALE == sc_type and ColorPieBtnU1 or ColorPieBtnU2
        end
      end
    elseif t_sin <= 1 and t_sin > 0.8 then
      color = LAST_PIE_SCALE == sc_type and ColorPieBtnD1 or ColorPieBtnD2
    end

    r.ImGui_SetCursorScreenPos(ctx, pos[1], pos[2])
    if r.ImGui_InvisibleButton(ctx, "##2" .. i .. sc_type, btn_w, btn_h) then
      --! PLAY CHORD ON PRESS
      -- local note = sc_type == "MIN" and item_label:sub(1, -2) or item_label
      -- onChordRootChange(note)
      onChordRootChange(item_label)
    end

    local hovered = r.ImGui_IsItemHovered(ctx)
    DrawListButton(item_label, color, hovered)
  end
  r.ImGui_SetCursorScreenPos(ctx, center_x - 20, center_y)
  --! NOT SURE IF CHANGING KEY FROM HERE IS NEEDED
  -- if r.ImGui_Button(ctx, "<") and ANIM_STOP then
  --   START_TIME = r.time_precise()
  --   NEW_POS = CUR_POS + 1
  -- end
  -- r.ImGui_SameLine(ctx)
  -- if r.ImGui_Button(ctx, ">") and ANIM_STOP then
  --   START_TIME = r.time_precise()
  --   NEW_POS = CUR_POS - 1
  -- end
end

local function uiChordPadTitle()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("Chord Pad", ColorGray, w - 140 - 140 - 30 - 30 - 140 - 30 - 30 - 7 * w_default_space)
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "Reset Chord Pad", 140) then
    initChordPads()
  end
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("One Pad Transpose:", ColorGray, 140)
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "<##selectpadtrans", 30) then
    onChordPadTrans(CHORD_PAD_SELECTED, -1)
  end

  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, ">##selectpadtrans", 30) then
    onChordPadTrans(CHORD_PAD_SELECTED, 1)
  end
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("All Pads Transpose:", ColorGray, 140)
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "<##allpadtrans", 30) then
    -- onChordPadTrans()
    for _, key in ipairs(CHORD_PAD_KEYS) do
      onChordPadTrans(key, -1)
    end
  end

  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, ">##allpadtrans", 30) then
    for _, key in ipairs(CHORD_PAD_KEYS) do
      onChordPadTrans(key, 1)
    end
    -- onChordPadTrans()
  end
  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordSelector()
  if r.ImGui_BeginChild(ctx, "UI_CHORD_SELECTOR", 0, 0) then
    if r.ImGui_BeginChild(ctx, "UI_CHORD_MAIN", w, 0) then
      uiTopLine()
      r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
      uiChordDegree()
      r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
      uiChordRoot()
      r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
      uiChordBass()
      r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
      uiChordLength()
      r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
      uiReadOnlyColorBtn("Chord Map", ColorGray, w)
      uiChordMap()
      uiVoicing()
      r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
      uiPiano()
      r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
      uiChordPadTitle()
      r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
      uiChordPad()
      r.ImGui_EndChild(ctx)
    end

    if CIRCLE_OF5 then
      r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), 0, 0)
      r.ImGui_SameLine(ctx)
      if r.ImGui_BeginChild(ctx, "CIRCLE_OF5_PIE", w_circle_of_5, 0) then
        r.ImGui_SameLine(ctx, 0, 140)
        r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Text(), 0xff)
        r.ImGui_Text(ctx, "CIRCLE OF FIFTS")
        r.ImGui_PopStyleColor(ctx)
        local vx, xy = r.ImGui_GetCursorScreenPos(ctx)
        local aw, ah = r.ImGui_GetContentRegionAvail(ctx)
        local sel_maj = PiePopupSelectMenu(items_maj, "MAJ", RADIUS, aw, ah, vx, xy)
        local sel_min = PiePopupSelectMenu(items_min, "MIN", RADIUS - 70, aw, ah, vx, xy)
        r.ImGui_EndChild(ctx)
      end
      r.ImGui_PopStyleVar(ctx, 1)
    end

    r.ImGui_EndChild(ctx)
  end
end

local function bindKeyBoard()
  -- W
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_W(), false) then
    CHORD_PAD_SELECTED = "[W]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[W]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- E
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_E(), false) then
    CHORD_PAD_SELECTED = "[E]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[E]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- T
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_T(), false) then
    CHORD_PAD_SELECTED = "[T]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[T]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- Y
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_Y(), false) then
    CHORD_PAD_SELECTED = "[Y]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[Y]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- U
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_U(), false) then
    CHORD_PAD_SELECTED = "[U]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[U]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- A
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_A(), false) then
    CHORD_PAD_SELECTED = "[A]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[A]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- S
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_S(), false) then
    CHORD_PAD_SELECTED = "[S]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[S]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- D
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_D(), false) then
    CHORD_PAD_SELECTED = "[D]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[D]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- F
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_F(), false) then
    CHORD_PAD_SELECTED = "[F]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[F]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- G
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_G(), false) then
    CHORD_PAD_SELECTED = "[G]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[G]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- H
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_H(), false) then
    CHORD_PAD_SELECTED = "[H]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[H]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- J
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_J(), false) then
    CHORD_PAD_SELECTED = "[J]"
    local key_idx = ListIndex(CHORD_PAD_KEYS, "[J]")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end
  -- ESC
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_Escape(), false) then
    R_StopPlay()
  end
  -- LEFT CTRL
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_LeftCtrl(), false) then
    SCALE_BY_CHORD_MODE = "on"
  end
  if r.ImGui_IsKeyReleased(ctx, r.ImGui_Key_LeftCtrl()) then
    SCALE_BY_CHORD_MODE = "off"
  end
  -- LEFT ALT
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_LeftAlt(), false) then
    CHORD_SIMILAR_MODE = "on"
  end
  if r.ImGui_IsKeyReleased(ctx, r.ImGui_Key_LeftAlt()) then
    CHORD_SIMILAR_MODE = "off"
  end
  -- LEFT SHIFT
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_LeftShift(), false) then
    CHORD_INSERT_MODE = "on"
  end
  if r.ImGui_IsKeyReleased(ctx, r.ImGui_Key_LeftShift()) then
    CHORD_INSERT_MODE = "off"
  end
end

local function uiAbout()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), 0, h_default_space)

  uiColorBtn("If this script is useful for you, you can buy me a coffee.", ColorNormalNote, w, 0)
  if uiColorBtn("https://www.paypal.com/paypalme/xupeng1206", ColorPink, w, 0) then
    r.CF_ShellExecute("https://www.paypal.com/paypalme/xupeng1206")
  end

  if not r.ImGui_ValidatePtr(ABOUT_IMG, 'ImGui_Image*') then
    ABOUT_IMG = r.ImGui_CreateImage(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_About.jpg', 0)
  end
  local my_tex_w, my_tex_h = r.ImGui_Image_GetSize(ABOUT_IMG)
  local uv_min_x, uv_min_y = 0.0, 0.0   -- Top-left
  local uv_max_x, uv_max_y = 1.0, 1.0   -- Lower-right
  local tint_col           = 0xFFFFFFFF -- No tint
  local border_col         = 0xFFFFFF7F -- 50% opaque white

  while true do
    if my_tex_w < w and my_tex_h < h - 25 - main_window_h_padding * 2 then
      break
    end
    my_tex_w = my_tex_w / 1.1
    my_tex_h = my_tex_h / 1.1
  end

  r.ImGui_InvisibleButton(ctx, "##about", (w - my_tex_w) / 2, my_tex_h, r.ImGui_ButtonFlags_None())
  r.ImGui_SameLine(ctx)
  r.ImGui_Image(ctx, ABOUT_IMG, my_tex_w, my_tex_h,
    uv_min_x, uv_min_y, uv_max_x, uv_max_y, tint_col, border_col)
  r.ImGui_PopStyleVar(ctx, 1)
end

local function refreshChordProgressionBanks()
  CHORD_PROGRESSION_LIST = R_ReadBankFile()
  local simple_list = {}
  for idx, progression in ipairs(CHORD_PROGRESSION_LIST) do
    local pg_split = StringSplit(progression, "@")
    local simple = "[ " .. pg_split[1] .. " ] = " .. pg_split[2]
    table.insert(simple_list, simple)
  end
  CHORD_PROGRESSION_SIMPLE_LIST = simple_list
  CHORD_PROGRESSION_FILTER = ""
end

local function initChordProgression()
  B_FULL_CHORD_PATTERNS = R_SelectChordItems()
  local simple_chords = {}
  local chords = StringSplit(B_FULL_CHORD_PATTERNS, "~")
  if #chords > 1 then
    for idx, chord in ipairs(chords) do
      local chord_name = StringSplit(chord, "|")[3]
      local chord_len = StringSplit(chord, "|")[4]
      local full_chord = '{ ' .. chord_name .. ' | ' .. chord_len .. ' }'
      table.insert(simple_chords, full_chord)
    end
    B_CHORD_PATTERNS = ListJoinToString(simple_chords, " >> ")
  else
    B_CHORD_PATTERNS = 'Please select a chord progression.'
  end
end

local function uiExtension()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, h_default_space)

  local ww = w
  local hh = h
  uiReadOnlyColorBtn("Actions", ColorGray, ww)

  if uiColorBtn("Up 1 Semitone" .. "##trans", ColorPink, (ww - 6 * w_default_space) / 7, 50) then
    R_ChordItemTrans(1)
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Down 1 Semitone" .. "##trans", ColorPink, (ww - 6 * w_default_space) / 7, 50) then
    R_ChordItemTrans(-1)
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Refresh Items" .. "##tempo", ColorYellow, (ww - 6 * w_default_space) / 7, 50) then
    R_ChordItemRefresh()
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Items To Markers" .. "##tag", ColorDarkPink, (ww - 6 * w_default_space) / 7, 50) then
    R_ChordItem2Marker()
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Delete Markers" .. "##tag", ColorRed, (ww - 6 * w_default_space) / 7, 50) then
    R_DeleteAllChordMarker()
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Items To Region" .. "##tag", ColorDarkPink, (ww - 6 * w_default_space) / 7, 50) then
    R_ChordItem2Region()
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Delete Regions" .. "##tag", ColorRed, (ww - 6 * w_default_space) / 7, 50) then
    R_DeleteAllChordRegion()
  end

  uiReadOnlyColorBtn("Chord Progression Bank", ColorGray, ww)

  if uiColorBtn("Add" .. "##bank_add", ColorPink, (ww - 2 * w_default_space) / 3, 50) then
    r.ImGui_OpenPopup(ctx, 'Save Selected Chord Progression')
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Insert" .. "##bank_insert", ColorYellow, (ww - 2 * w_default_space) / 3, 50) then
    if CHORD_PROGRESSION_SELECTED_INDEX ~= 0 then
      local progression = CHORD_PROGRESSION_LIST[CHORD_PROGRESSION_SELECTED_INDEX]
      local full_meta_list_str = StringSplit(progression, "@")[3]
      local full_meta_list_split = StringSplit(full_meta_list_str, "~")
      for idx, full_meta in ipairs(full_meta_list_split) do
        local meta_split = StringSplit(full_meta, "|")
        local meta = meta_split[1]
        local notes = StringSplit(meta_split[2], ",")
        local chord_name = meta_split[3]
        local beats = tonumber(meta_split[4])
        local oct_shift_after_first_note = 0
        if #meta_split>4 then
          oct_shift_after_first_note = tonumber(meta_split[5])
        end
        R_InsertChordItem(chord_name, meta, notes, beats, oct_shift_after_first_note)
      end
    end
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Delete" .. "##bank_delete", ColorRed, (ww - 2 * w_default_space) / 3, 50) then
    if CHORD_PROGRESSION_SELECTED_INDEX <= #CHORD_PROGRESSION_LIST then
      r.ImGui_OpenPopup(ctx, 'Delete Chord Progression?')
    end
  end

  local add_bank_win_flags = r.ImGui_WindowFlags_None()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoScrollbar()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoNav()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_NoDocking()
  add_bank_win_flags = add_bank_win_flags | r.ImGui_WindowFlags_AlwaysAutoResize()
  if r.ImGui_BeginPopupModal(ctx, 'Save Selected Chord Progression', nil, add_bank_win_flags) then
    -- input text & button
    if r.ImGui_Button(ctx, "Refresh", 80) then
      R_ChordItemRefresh()
    end
    r.ImGui_SameLine(ctx)
    initChordProgression()
    r.ImGui_Text(ctx, B_CHORD_PATTERNS)
    uiReadOnlyColorBtn("BankTag", ColorGray, 80)
    r.ImGui_SameLine(ctx)
    _, B_BANK_TAG = r.ImGui_InputText(ctx, '##bank_tag', B_BANK_TAG)
    r.ImGui_SameLine(ctx)
    if r.ImGui_Button(ctx, "SaveBank", 100) then
      if B_CHORD_PATTERNS == 'Please select a chord progression.' then
        r.ImGui_CloseCurrentPopup(ctx)
      else
        local full_bk = B_BANK_TAG .. '@' .. B_CHORD_PATTERNS .. '@' .. B_FULL_CHORD_PATTERNS
        R_SaveBank(full_bk)
        refreshChordProgressionBanks()
        r.ImGui_CloseCurrentPopup(ctx)
      end
    end
    r.ImGui_SameLine(ctx)
    if r.ImGui_Button(ctx, "Close", 100) then
      r.ImGui_CloseCurrentPopup(ctx)
    end
    r.ImGui_EndPopup(ctx)
  end

  local delete_bank_win_flags = add_bank_win_flags
  if r.ImGui_BeginPopupModal(ctx, "Delete Chord Progression?", nil, delete_bank_win_flags) then
    if r.ImGui_Button(ctx, "Confirmed", 100) then
      if CHORD_PROGRESSION_SELECTED_INDEX <= #CHORD_PROGRESSION_LIST then
        CHORD_PROGRESSION_LIST = ListDeleteIndex(CHORD_PROGRESSION_LIST, CHORD_PROGRESSION_SELECTED_INDEX)
        CHORD_PROGRESSION_SIMPLE_LIST = ListDeleteIndex(CHORD_PROGRESSION_SIMPLE_LIST, CHORD_PROGRESSION_SELECTED_INDEX)
        CHORD_PROGRESSION_SELECTED_INDEX = CHORD_PROGRESSION_SELECTED_INDEX - 1
        R_RefreshBank(CHORD_PROGRESSION_LIST)
        CHORD_PROGRESSION_FILTER = ""
        r.ImGui_CloseCurrentPopup(ctx)
      end
    end
    r.ImGui_SameLine(ctx)
    if r.ImGui_Button(ctx, "Close", 100) then
      r.ImGui_CloseCurrentPopup(ctx)
    end
    r.ImGui_EndPopup(ctx)
  end

  local selected_progression = "Selected Chord Progression"
  if CHORD_PROGRESSION_SELECTED_INDEX ~= 0 then
    selected_progression = CHORD_PROGRESSION_SIMPLE_LIST[CHORD_PROGRESSION_SELECTED_INDEX]
  end

  uiReadOnlyColorBtn(selected_progression, ColorGray, ww)
  uiReadOnlyColorBtn("Filter Tag", ColorGray, 100)
  r.ImGui_SameLine(ctx)
  r.ImGui_SetNextItemWidth(ctx, ww - 100 - w_default_space)
  _, CHORD_PROGRESSION_FILTER = r.ImGui_InputText(ctx, '##filter_tag', CHORD_PROGRESSION_FILTER)

  -- filter
  CHORD_PROGRESSION_SIMPLE_LIST_FILTERED = {}
  CHORD_PROGRESSION_SIMPLE_LIST_FILTERED_INDEX_MAP = {}
  for idx, v in ipairs(CHORD_PROGRESSION_SIMPLE_LIST) do
    local tag = StringSplit(v, " = ")[1]
    if string.match(tag, CHORD_PROGRESSION_FILTER) ~= nil then
      table.insert(CHORD_PROGRESSION_SIMPLE_LIST_FILTERED, v)
      table.insert(CHORD_PROGRESSION_SIMPLE_LIST_FILTERED_INDEX_MAP, idx)
    end
  end

  if r.ImGui_BeginListBox(ctx, '##bank', -FLT_MIN, hh - 30 - 2 * 7 - 50 * 2 - 25 * 4) then
    for idx, v in ipairs(CHORD_PROGRESSION_SIMPLE_LIST_FILTERED) do
      local is_selected = CHORD_PROGRESSION_SELECTED_INDEX == CHORD_PROGRESSION_SIMPLE_LIST_FILTERED_INDEX_MAP[idx]
      if r.ImGui_Selectable(ctx, v, is_selected) then
        CHORD_PROGRESSION_SELECTED_INDEX = CHORD_PROGRESSION_SIMPLE_LIST_FILTERED_INDEX_MAP[idx]
      end

      -- Set the initial focus when opening the combo (scrolling + keyboard navigation focus)
      if is_selected then
        r.ImGui_SetItemDefaultFocus(ctx)
      end
    end
    r.ImGui_EndListBox(ctx)
  end

  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiMain()
  bindKeyBoard()
  if r.ImGui_BeginTabBar(ctx, 'ReaChordTab', r.ImGui_TabBarFlags_None()) then
    if r.ImGui_BeginTabItem(ctx, ' Main ') then
      -- recover the CIRCLE_OF5 show status
      if OLD_CIRCLE_OF5 then
        CIRCLE_OF5 = true
        OLD_CIRCLE_OF5 = false
      end
      uiChordSelector()
      r.ImGui_EndTabItem(ctx)
    end
    if r.ImGui_BeginTabItem(ctx, ' Extension ') then
      -- fix w when CIRCLE_OF5 show
      if CIRCLE_OF5 then
        OLD_CIRCLE_OF5 = true
      end
      CIRCLE_OF5 = false
      uiExtension()
      r.ImGui_EndTabItem(ctx)
    end
    if r.ImGui_BeginTabItem(ctx, ' About ') then
      -- fix w when CIRCLE_OF5 show
      if CIRCLE_OF5 then
        OLD_CIRCLE_OF5 = true
      end
      CIRCLE_OF5 = false
      uiAbout()
      r.ImGui_EndTabItem(ctx)
    end
    r.ImGui_EndTabBar(ctx)
  end
end

local function loop()
  r.ImGui_PushFont(ctx, G_FONT)
  r.ImGui_SetWindowSize(ctx, min_w, min_h, r.ImGui_Cond_FirstUseEver())
  r.ImGui_SetNextWindowSizeConstraints(ctx, min_w, min_h, min_w*2, min_h*1.5)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowPadding(), main_window_w_padding, main_window_h_padding)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowBorderSize(), 0)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_WindowBg(), ColorMainBackground)

  local window_flags = r.ImGui_WindowFlags_None()
  window_flags = window_flags | r.ImGui_WindowFlags_NoScrollbar()
  window_flags = window_flags | r.ImGui_WindowFlags_NoNav()
  window_flags = window_flags | r.ImGui_WindowFlags_NoDocking()

  local visible, open = r.ImGui_Begin(ctx, 'ReaChord', true, window_flags)
  if visible then
    refreshWindowSize()
    uiMain()
    r.ImGui_End(ctx)
  end
  r.ImGui_PopFont(ctx)

  if open then
    r.defer(loop)
  end
  r.ImGui_PopStyleVar(ctx, 2)
  r.ImGui_PopStyleColor(ctx, 1)
end

local function init()
  refreshColors()
  R_ImportChordTrack()
  R_ArmOnlyChordTrack()
  local pad_values = r.GetExtState("ReaChord", "CHORD_PAD_VALUES")
  local pad_values_split = StringSplit(pad_values, "~")
  if #pad_values_split == 12 then
    CHORD_PAD_VALUES = pad_values_split
  end
  local pad_metas = r.GetExtState("ReaChord", "CHORD_PAD_METAS")
  local pad_metas_split = StringSplit(pad_metas, "~")
  if #pad_metas_split == 12 then
    CHORD_PAD_METAS = pad_metas_split
  end

  local chord, meta, notes, beats, oct_shfit_after_first_note = R_SelectChordItem()
  CURRENT_INSERT_BEATS = 4
  if chord == "" then
    -- no item selected, fetch scale meta from project
    local scale_root = r.GetExtState("ReaChord", "ScaleRoot")
    if #scale_root > 0 then
      CURRENT_SCALE_ROOT = scale_root
    end

    local scale_name = r.GetExtState("ReaChord", "ScaleName")
    if #scale_name > 0 then
      CURRENT_SCALE_NAME = scale_name
    end
    refreshUIWhenScaleChangeWithSelectChordChange()
  else
    CURRENT_INSERT_BEATS = beats
    CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE = oct_shfit_after_first_note
    local chord_split = StringSplit(chord, "/")
    local meta_split = StringSplit(meta, "/")

    CURRENT_CHORD_BASS = notes[1]
    CURRENT_CHORD_FULL_NAME = chord
    if #chord_split == 1 then
      CURRENT_CHORD_ROOT = notes[1]
      CURRENT_CHORD_NAME = chord
    else
      CURRENT_CHORD_NAME = chord_split[1]
      local b = string.sub(CURRENT_CHORD_NAME, 2, 2)
      if b == "#" or b == "b" then
        CURRENT_CHORD_ROOT = string.sub(CURRENT_CHORD_NAME, 1, 2)
      else
        CURRENT_CHORD_ROOT = string.sub(CURRENT_CHORD_NAME, 1, 1)
      end
    end
    local CURRENT_CHORD_DEFAULT_VOICING_table, _ = T_MakeChord(CURRENT_CHORD_NAME)
    CURRENT_CHORD_DEFAULT_VOICING = ListJoinToString(CURRENT_CHORD_DEFAULT_VOICING_table, ",")
    local CURRENT_CHORD_VOICING_table = {}
    for idx, v in ipairs(notes) do
      if idx > 1 then
        table.insert(CURRENT_CHORD_VOICING_table, v)
      end
    end
    CURRENT_CHORD_VOICING = ListJoinToString(CURRENT_CHORD_VOICING_table, ",")
    CURRENT_CHORD_PITCHED, _ = T_NotePitched(notes, CURRENT_OCT_SHIFT_AFTER_FIRST_NOTE)
    CURRENT_OCT = meta_split[3]
    CURRENT_SCALE_ROOT = meta_split[1]
    CURRENT_SCALE_NAME = meta_split[2]
    refreshUIWhenScaleChange()
  end
  refreshChordProgressionBanks()
end

local function startUi()
  init()
  loop()
end

r.defer(startUi)
