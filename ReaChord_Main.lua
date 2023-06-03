r = reaper
print = r.ShowConsoleMsg
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Theory.lua')
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Reaper.lua')

local ctx = r.ImGui_CreateContext('ReaChord', r.ImGui_ConfigFlags_DockingEnable())
local G_FONT = r.ImGui_CreateFont('sans-serif', 15)
r.ImGui_Attach(ctx, G_FONT)

local CHORD_PAD_KEYS = {"A", "W", "S", "E", "D", "F", "T", "G", "Y", "H", "U", "J"}
local CHORD_PAD_VALUES = {"A", "W", "S", "E", "D", "F", "T", "G", "Y", "H", "U", "J"}
local CHORD_PAD_METAS = {"", "", "", "", "", "", "", "", "", "", "", ""}

local OctRange = {"-1", "0", "+1"}
local aboutImg

local current_scale_root = "C"
local current_scale_name = "Natural Maj"
local current_scale_all_notes = {}
local current_scale_nice_notes = {}
local current_oct = "0"

local current_chord_root = "C"
local current_chord_name = ""
local current_chord_full_name = ""
local current_chord_bass = "C"
local current_chord_default_voicing = ""
local current_chord_voicing = ""
local current_chord_pitched = {}
local current_chord_list = {}
local current_nice_chord_list = {}

local MainBgColor = 0xEEE9E9FF
local ColorWhite = 0xFFFFFFFF
local ColorBlack = 0x000000FF
local ColorGray = 0x696969FF
local ColorPink = 0xFF6EB4FF
local ColorBlue = 0x0000FFFF
local ColorNormalNote = 0x838B8BFF
local ColorBtnHover = 0x4876FFFF
local ColorChordPadDefault = 0x8DB6CDFF

local main_window_w_padding = 10
local main_window_h_padding = 5
local w
local h
local w_piano_space = 2
local w_piano_key
local w_piano_half_key
local h_piano = 30
local w_default_space = 4
local h_default_space = 4
local w_chord_pad_space = 4
local h_chord_pad_space = 4
local w_chord_pad
local w_chord_pad_half
local h_chord_pad = 40

local function refreshWindowSize()
  w, h = r.ImGui_GetWindowSize(ctx)
  w, h = w-main_window_w_padding*2, h-21
  if package.config:sub(1,1) == "/" then
    -- mac or linux?
    h = h -15
  end
  w_piano_key = w/28-2
  w_piano_half_key = w/56-1
  w_chord_pad = w/7-4
  w_chord_pad_half = w/14-2
end

local function onFullChordNameChange()
  if current_chord_root == current_chord_bass then
    current_chord_full_name = current_chord_name
  else
    current_chord_full_name = current_chord_name.."/"..current_chord_bass
  end
  local voicing = StringSplit(current_chord_voicing, ",")
  local notes = ListExtend({current_chord_bass}, voicing)
  current_chord_pitched, _ = T_NotePitched(notes)
end

local function PlayPiano()
  local voicing = StringSplit(current_chord_voicing, ",")
  local notes = ListExtend({current_chord_bass}, voicing)
  local note_midi_index
  _, note_midi_index = T_NotePitched(notes)
  R_StopPlay()
  local midi_notes={}
  for _, midi_index in ipairs(note_midi_index) do
    table.insert(midi_notes, midi_index+36+current_oct*12)
  end
  R_Play(midi_notes)
end

local function playChordPad(key_idx)
  local full_meta = CHORD_PAD_METAS[key_idx]
  local full_meta_split = StringSplit(full_meta, "|")
  if #full_meta_split==2 then
    local notes = full_meta_split[2]
    local oct = StringSplit(full_meta_split[1], "/")[3]
    local note_split = StringSplit(notes, ",")
    local note_midi_index
    _, note_midi_index = T_NotePitched(note_split)
    local midi_notes={}
    for _, midi_index in ipairs(note_midi_index) do
      table.insert(midi_notes, midi_index+36+oct*12)
    end
    R_Play(midi_notes)
  end
end


local function onSelectChordChange(val)
  current_chord_name = val

  local default_voicing = {}
  default_voicing, _ = T_MakeChord(current_chord_name)
  current_chord_default_voicing = ListJoinToString(default_voicing, ",")
  current_chord_voicing = current_chord_default_voicing
  onFullChordNameChange()
end

local function onVoicingChange(val)
  local new_voicing = StringSplit(val, ",")
  local default_voicing = StringSplit(current_chord_default_voicing, ",")
  if AListAllInBList(new_voicing, default_voicing) then
    current_chord_voicing = val
    local notes = ListExtend({current_chord_bass}, new_voicing)
  current_chord_pitched, _ = T_NotePitched(notes)
  end
end

local function refreshUIWhenChordRootChange()
  local nice_chords = {}
  local normal_chords = {}
  for _, chord_tag in ipairs(G_CHORD_NAMES) do
    local chord = current_chord_root
    local chord_tag_split = StringSplit(chord_tag, "X")
    if #chord_tag_split > 1 then
      chord = current_chord_root..chord_tag_split[2]
    end
    if T_ChordInScale(chord, current_scale_root.."/"..current_scale_name)  then
      table.insert(nice_chords, chord)
    else
      table.insert(normal_chords, chord)
    end
  end
  if #nice_chords>0 then
    onSelectChordChange(nice_chords[1])
    PlayPiano()
  else
    onSelectChordChange(normal_chords[1])
    PlayPiano()
  end
  current_nice_chord_list = nice_chords
  current_chord_list = ListExtend(nice_chords, normal_chords)
end

local function refreshUIWhenScaleChange()
  local notes = {}
  current_scale_nice_notes, _ = T_MakeScale(current_scale_root.."/"..current_scale_name)
  local scale_root_index_start = T_NoteIndex(G_NOTE_LIST_X4, current_scale_root)

  for i = scale_root_index_start, scale_root_index_start+11 do
    local note = G_NOTE_LIST_X4[i]
    local note_split = StringSplit(note, "/")
    if #note_split == 1 then
      table.insert(notes, note)
    else
      local b_note = note_split[1]
      local s_note = note_split[2]
      if ListIndex(current_scale_nice_notes, s_note) > 0 then
        table.insert(notes, s_note)
      else
        table.insert(notes, b_note)
      end
    end
  end

  current_scale_all_notes = notes

  local nice_chords = {}
  local normal_chords = {}
  for _, chord_tag in ipairs(G_CHORD_NAMES) do
    local chord = current_chord_root
    local chord_tag_split = StringSplit(chord_tag, "X")
    if #chord_tag_split > 1 then
      chord = current_chord_root..chord_tag_split[2]
    end
    if T_ChordInScale(chord, current_scale_root.."/"..current_scale_name)  then
      table.insert(nice_chords, chord)
    else
      table.insert(normal_chords, chord)
    end
  end
  current_nice_chord_list = nice_chords
  current_chord_list = ListExtend(nice_chords, normal_chords)
end


local function refreshUIWhenScaleChangeWithSelectChordChange()
  refreshUIWhenScaleChange()
  if #current_nice_chord_list>0 then
    onSelectChordChange(current_nice_chord_list[1])
  else
    onSelectChordChange(current_chord_list[1])
  end
end

local function onScaleRootChange(val)
  current_scale_root = val
  current_chord_root = val
  current_chord_bass = val
  refreshUIWhenScaleChangeWithSelectChordChange()
end

local function onScaleNameChange(val)
  current_scale_name = val
  current_chord_root = current_scale_root
  current_chord_bass = current_scale_root
  refreshUIWhenScaleChangeWithSelectChordChange()
end

local function onOctChange(val)
  current_oct = val
end

local function onChordRootChange(val)
  current_chord_root = val
  current_chord_bass = val
  refreshUIWhenChordRootChange()
end

local function onChordBassChange(val)
  current_chord_bass = val
  onFullChordNameChange()
  PlayPiano()
end

local function onListenClick()
  PlayPiano()
end

local function onStopClick ()
  R_StopPlay()
end

local function onInsertClick()
  local meta = current_scale_root.."/"..current_scale_name.."/"..current_oct
  local notes = ListExtend({current_chord_bass}, StringSplit(current_chord_voicing, ","))
  R_InsertChordItem(current_chord_full_name, meta, notes)
end

local function onChordPadAssign(key)
  local key_idx = ListIndex(CHORD_PAD_KEYS, key)
  if current_chord_root == current_chord_bass then
    CHORD_PAD_VALUES[key_idx] = current_chord_name
    local meta = current_scale_root.."/"..current_scale_name.."/"..current_oct
    local full_meta = meta.."|"..current_chord_bass..","..current_chord_voicing
    CHORD_PAD_METAS[key_idx] = full_meta
  else
    CHORD_PAD_VALUES[key_idx] = current_chord_name.."/"..current_chord_bass
    local meta = current_scale_root.."/"..current_scale_name.."/"..current_oct
    local full_meta = meta.."|"..current_chord_bass..","..current_chord_voicing
    CHORD_PAD_METAS[key_idx] = full_meta
  end
  r.SetExtState("ReaChord", "CHORD_PAD_VALUES", ListJoinToString(CHORD_PAD_VALUES, "~"), false)
  r.SetExtState("ReaChord", "CHORD_PAD_METAS", ListJoinToString(CHORD_PAD_METAS, "~"), false)
end

local function chordMapRefresh(key_idx)
  local chord = CHORD_PAD_VALUES[key_idx]
  local full_meta = CHORD_PAD_METAS[key_idx]
  local full_meta_split = StringSplit(full_meta, "|")

  local meta = full_meta_split[1]
  local notes = StringSplit(full_meta_split[2], ",")
  
  if chord == "" then
    refreshUIWhenScaleChangeWithSelectChordChange()
  else
    local chord_split = StringSplit(chord, "/")
    local meta_split = StringSplit(meta, "/")
    
    current_chord_bass = notes[1]
    current_chord_full_name = chord
    if #chord_split == 1 then
      current_chord_root = notes[1]
      current_chord_name = chord
    else
      current_chord_name = chord_split[1]
      local b = string.sub(current_chord_name, 2, 2)
      if b == "#" or b == "b" then
        current_chord_root = string.sub(current_chord_name, 1, 2)
      else
        current_chord_root = string.sub(current_chord_name, 1, 1)
      end
    end
    local current_chord_default_voicing_table, _ = T_MakeChord(current_chord_name)
    current_chord_default_voicing = ListJoinToString(current_chord_default_voicing_table, ",")
    local current_chord_voicing_table = {}
    for idx, v in ipairs(notes) do
      if idx>1 then
        table.insert(current_chord_voicing_table, v)
      end
    end
    current_chord_voicing = ListJoinToString(current_chord_voicing_table, ",")
    current_chord_pitched, _ = T_NotePitched(notes)
    current_oct = meta_split[3]
    current_scale_root = meta_split[1]
    current_scale_name = meta_split[2]
    refreshUIWhenScaleChange()
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


local function uiPiano()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_piano_space, 0)
  -- black
  r.ImGui_InvisibleButton(ctx, "##", w_piano_half_key-w_piano_space, h_piano, r.ImGui_ButtonFlags_None())
  for _, note in ipairs({
    "Db0/C#0","Eb0/D#0","-","Gb0/F#0","Ab0/G#0","Bb0/A#0","-",
    "Db1/C#1","Eb1/D#1","-","Gb1/F#1","Ab1/G#1","Bb1/A#1","-",
    "Db2/C#2","Eb2/D#2","-","Gb2/F#2","Ab2/G#2","Bb2/A#2","-",
    "Db3/C#3","Eb3/D#3","-","Gb3/F#3","Ab3/G#3","Bb3/A#3"
  }) do
    r.ImGui_SameLine(ctx)
    if note == "-" then
      r.ImGui_InvisibleButton(ctx, "##", w_piano_key, h_piano, r.ImGui_ButtonFlags_None())
    else
      local note_split = StringSplit(note, "/")
      if ListIndex(current_chord_pitched, note_split[1]) > 0 or ListIndex(current_chord_pitched, note_split[2]) > 0 then
        r.ImGui_ColorButton(ctx, "##", ColorBlue,r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, h_piano)
      else
        r.ImGui_ColorButton(ctx, "##", ColorBlack,r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, h_piano)
      end
    end
  end
  -- r.ImGui_SameLine(ctx)
  -- r.ImGui_InvisibleButton(ctx, "##", w_piano_half_key, h_piano, r.ImGui_ButtonFlags_None())
  
  -- white
  for idx, note in ipairs({
    "C0","D0","E0","F0","G0","A0","B0",
    "C1","D1","E1","F1","G1","A1","B1",
    "C2","D2","E2","F2","G2","A2","B2",
    "C3","D3","E3","F3","G3","A3","B3"
  }) do
    if idx >1 then
      r.ImGui_SameLine(ctx)
    end
    if ListIndex(current_chord_pitched, note) > 0 then
      r.ImGui_ColorButton(ctx, "##", ColorBlue,r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, h_piano)
    else
      r.ImGui_ColorButton(ctx, "##", ColorWhite,r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, h_piano)
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
    "W","E","-","T","Y","U"
  }) do
    r.ImGui_SameLine(ctx)
    if key == "-" then
      r.ImGui_InvisibleButton(ctx, "##", w_chord_pad, h_chord_pad, r.ImGui_ButtonFlags_None())
    else
      local chord = CHORD_PAD_VALUES[ListIndex(CHORD_PAD_KEYS, key)]
      if chord == key then
        if uiColorBtn(chord.."##"..key, ColorChordPadDefault, w_chord_pad, h_chord_pad) then
          -- click action
          local key_idx = ListIndex(CHORD_PAD_KEYS, key)
          R_StopPlay()
          playChordPad(key_idx)
          chordMapRefresh(key_idx)
        end
        if r.ImGui_BeginDragDropTarget(ctx) then
          rev, _ = r.ImGui_AcceptDragDropPayload(ctx, 'DND_DEMO_CELL')
          if rev then
            onChordPadAssign(key)
          end
          r.ImGui_EndDragDropTarget(ctx)
        end
      else
        local pure_chord = StringSplit(chord, "/")[1]
        if T_ChordInScale(pure_chord, current_scale_root.."/"..current_scale_name) then
          if uiColorBtn(chord.."##"..key, ColorPink, w_chord_pad, h_chord_pad) then
            local key_idx = ListIndex(CHORD_PAD_KEYS, key)
            R_StopPlay()
            playChordPad(key_idx)
            chordMapRefresh(key_idx)
          end
          if r.ImGui_BeginDragDropTarget(ctx) then
            rev, _ = r.ImGui_AcceptDragDropPayload(ctx, 'DND_DEMO_CELL')
            if rev then
              onChordPadAssign(key)
            end
            r.ImGui_EndDragDropTarget(ctx)
          end
        else
          if uiColorBtn(chord.."##"..key, ColorNormalNote, w_chord_pad, h_chord_pad) then
            local key_idx = ListIndex(CHORD_PAD_KEYS, key)
            R_StopPlay()
            playChordPad(key_idx)
            chordMapRefresh(key_idx)
          end
          if r.ImGui_BeginDragDropTarget(ctx) then
            rev, _ = r.ImGui_AcceptDragDropPayload(ctx, 'DND_DEMO_CELL')
            if rev then
              onChordPadAssign(key)
            end
            r.ImGui_EndDragDropTarget(ctx)
          end
        end
      end
    end
  end
  -- -
  r.ImGui_SameLine(ctx)
  r.ImGui_InvisibleButton(ctx, "##", w_chord_pad_half, h_chord_pad, r.ImGui_ButtonFlags_None())
  
  -- white
  for idx, key in ipairs({
    "A","S","D","F","G","H","J"
  }) do
    if idx > 1 then
      r.ImGui_SameLine(ctx)
    end
    local chord = CHORD_PAD_VALUES[ListIndex(CHORD_PAD_KEYS, key)]
    if chord == key then
      if uiColorBtn(chord.."##"..key, ColorChordPadDefault, w_chord_pad, h_chord_pad) then
        local key_idx = ListIndex(CHORD_PAD_KEYS, key)
        R_StopPlay()
        playChordPad(key_idx)
        chordMapRefresh(key_idx)
      end
      if r.ImGui_BeginDragDropTarget(ctx) then
        rev, _ = r.ImGui_AcceptDragDropPayload(ctx, 'DND_DEMO_CELL')
        if rev then
          onChordPadAssign(key)
        end
        r.ImGui_EndDragDropTarget(ctx)
      end
    else
      local pure_chord = StringSplit(chord, "/")[1]
      if T_ChordInScale(pure_chord, current_scale_root.."/"..current_scale_name) then
        if uiColorBtn(chord.."##"..key, ColorPink, w_chord_pad, h_chord_pad) then
          local key_idx = ListIndex(CHORD_PAD_KEYS, key)
          R_StopPlay()
          playChordPad(key_idx)
          chordMapRefresh(key_idx)
        end
        if r.ImGui_BeginDragDropTarget(ctx) then
          rev, _ = r.ImGui_AcceptDragDropPayload(ctx, 'DND_DEMO_CELL')
          if rev then
            onChordPadAssign(key)
          end
          r.ImGui_EndDragDropTarget(ctx)
        end
      else
        if uiColorBtn(chord.."##"..key, ColorNormalNote, w_chord_pad, h_chord_pad) then
          local key_idx = ListIndex(CHORD_PAD_KEYS, key)
          R_StopPlay()
          playChordPad(key_idx)
          chordMapRefresh(key_idx)
        end
        if r.ImGui_BeginDragDropTarget(ctx) then
          rev, _ = r.ImGui_AcceptDragDropPayload(ctx, 'DND_DEMO_CELL')
          if rev then
            onChordPadAssign(key)
          end
          r.ImGui_EndDragDropTarget(ctx)
        end
      end
    end
  end

  r.ImGui_PopStyleVar(ctx, 1)
end


local function uiScaleRootSelector()
  if r.ImGui_BeginCombo(ctx, '##ScaleRoot', current_scale_root, r.ImGui_ComboFlags_HeightLarge()) then
    for _, v in ipairs(G_FLAT_NOTE_LIST) do
      local is_selected = current_scale_root == v
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
  if r.ImGui_BeginCombo(ctx, '##ScalePattern', current_scale_name, r.ImGui_ComboFlags_HeightLarge()) then
    for _, v in ipairs(G_SCALE_NAMES) do
      local is_selected = current_scale_name == v
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
  if r.ImGui_BeginCombo(ctx, '##Oct', current_oct, r.ImGui_ComboFlags_HeightLarge()) then
    for _, v in ipairs(OctRange) do
      local is_selected = current_oct == v
      if r.ImGui_Selectable(ctx, v, is_selected) then
        onOctChange(v)
      end

      if is_selected then
        r.ImGui_SetItemDefaultFocus(ctx)
      end
    end
    r.ImGui_EndCombo(ctx)
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
  r.ImGui_SetNextItemWidth(ctx, w-5*w_default_space-100-50-100-40-50)
  uiScaleNameSelector()
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("Oct:", ColorGray, 40)
  r.ImGui_SameLine(ctx)
  r.ImGui_SetNextItemWidth(ctx, 50)
  uiOctSelector()
  
  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiVoicing()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)
  
  uiReadOnlyColorBtn("Voicing:", ColorGray, 70)
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn(current_chord_bass, ColorGray, 40)
  r.ImGui_SameLine(ctx)
  r.ImGui_SetNextItemWidth(ctx, (w-7*w_default_space-60-60-60-70-40-60)/2)
  local _, voicing = r.ImGui_InputText(ctx, '##voicing', current_chord_voicing)
  onVoicingChange(voicing)
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "Listen", 60) then
    onListenClick()
  end
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "Stop", 60) then
    onStopClick()
  end
  r.ImGui_SameLine(ctx)
  if r.ImGui_Button(ctx, "Insert", 60) then
    onInsertClick()
  end
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("Notes:", ColorGray, 60)
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn(current_chord_bass..","..current_chord_default_voicing, ColorGray, (w-7*w_default_space-60-60-60-70-40-60)/2)

  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordRoot()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("ChordRoot:", ColorGray, 100)

  for _, note in ipairs(current_scale_all_notes) do
    r.ImGui_SameLine(ctx)
    if note == current_chord_root then
      if uiColorBtn(" "..note.." ##chord_root", ColorBlue, (w-12*w_default_space-100)/12, 0) then
        onChordRootChange(note)
      end
    elseif ListIndex(current_scale_nice_notes, note) > 0 then
      if uiColorBtn(" "..note.." ##chord_root", ColorPink, (w-12*w_default_space-100)/12, 0) then
        onChordRootChange(note)
      end
    else
      if uiColorBtn(" "..note.." ##chord_root", ColorNormalNote, (w-12*w_default_space-100)/12, 0) then
        onChordRootChange(note)
      end
    end
  end
  
  r.ImGui_PopStyleVar(ctx, 1)
end


local function uiChordBass()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("ChordBass:", ColorGray, 100)
  for _, note in ipairs(current_scale_all_notes) do
    r.ImGui_SameLine(ctx)
    if note == current_chord_bass then
      if uiColorBtn(" "..note.." ##chord_bass", ColorBlue, (w-12*w_default_space-100)/12, 0) then
        onChordBassChange(note)
      end
    elseif ListIndex(current_scale_nice_notes, note) > 0 then
      if uiColorBtn(" "..note.." ##chord_bass", ColorPink, (w-12*w_default_space-100)/12, 0) then
        onChordBassChange(note)
      end
    else
      if uiColorBtn(" "..note.." ##chord_bass", ColorNormalNote, (w-12*w_default_space-100)/12, 0) then
        onChordBassChange(note)
      end
    end
  end
  
  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordMap()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, h_default_space)
  
  local lines = math.ceil(#G_CHORD_NAMES/7)
  local ww = w
  local hh = h-main_window_h_padding*2-1*lines-h_piano*2-7*25-h_chord_pad*2
  -- 7 x 7
  for i=0,lines-1 do
    for j=1,7 do
      local idx = i*7+j
      if idx > #current_chord_list then
        break
      end
      if j>1 then
        r.ImGui_SameLine(ctx)
      end
      local chord = current_chord_list[idx]
      if chord == current_chord_name then
        if uiColorBtn(chord.."##chord", ColorBlue, (ww-6*w_default_space)/7, (hh-6*w_default_space)/7) then
          onSelectChordChange(chord)
          PlayPiano()
        end
        if r.ImGui_BeginDragDropSource(ctx, r.ImGui_DragDropFlags_None()) then
          -- Set payload to carry the index of our item (could be anything)
          r.ImGui_SetDragDropPayload(ctx, 'DND_DEMO_CELL', tostring(idx))

          -- Display preview (could be anything, e.g. when dragging an image we could decide to display
          -- the filename and a small preview of the image, etc.)
          r.ImGui_Text(ctx, ('Chord: %s'):format(current_chord_full_name))
          r.ImGui_EndDragDropSource(ctx)
        end
      elseif ListIndex(current_nice_chord_list, chord)>0 then
        if uiColorBtn(chord.."##chord", ColorPink, (ww-6*w_default_space)/7, (hh-6*w_default_space)/7) then
          onSelectChordChange(chord)
          PlayPiano()
        end
      else 
        if uiColorBtn(chord.."##chord", ColorNormalNote, (ww-6*w_default_space)/7, (hh-6*w_default_space)/7) then
          onSelectChordChange(chord)
          PlayPiano()
        end
      end
    end
  end

  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordSelector()
  uiTopLine()
  r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
  uiChordRoot()
  r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
  uiChordBass()
  r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
  uiReadOnlyColorBtn("Chord Map", ColorGray, w)
  uiChordMap()
  uiVoicing()
  r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
  uiPiano()
  r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
  uiReadOnlyColorBtn("Chord Pad", ColorGray, w)
  uiChordPad()

end

local function bindKeyBoard()
  -- W
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_W(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "W")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- E
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_E(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "E")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- T
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_T(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "T")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- Y
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_Y(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "Y")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- U
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_U(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "U")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- A
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_A(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "A")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end
  
  -- S
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_S(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "S")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- D
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_D(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "D")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- F
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_F(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "F")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- G
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_G(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "G")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- H
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_H(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "H")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end

  -- J
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_J(), false) then
    local key_idx = ListIndex(CHORD_PAD_KEYS, "J")
    R_StopPlay()
    playChordPad(key_idx)
    chordMapRefresh(key_idx)
  end
  -- ESC
  if r.ImGui_IsKeyPressed(ctx, r.ImGui_Key_Escape(), false) then
    R_StopPlay()
  end
end

local function uiAbout()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), 0, h_default_space)

  uiColorBtn("If this script is useful for you, you can buy me a coffee.", ColorNormalNote, w, 0)
      
  if not r.ImGui_ValidatePtr(aboutImg, 'ImGui_Image*') then
    aboutImg = r.ImGui_CreateImage(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_About.jpg', 0)
  end
  local my_tex_w, my_tex_h = r.ImGui_Image_GetSize(aboutImg)
  local uv_min_x, uv_min_y = 0.0, 0.0 -- Top-left
  local uv_max_x, uv_max_y = 1.0, 1.0 -- Lower-right
  local tint_col   = 0xFFFFFFFF       -- No tint
  local border_col = 0xFFFFFF7F       -- 50% opaque white

  while true do
    if my_tex_w < w and my_tex_h < h-25-main_window_h_padding*2 then
      break
    end
    my_tex_w = my_tex_w/1.1
    my_tex_h = my_tex_h/1.1
  end

  r.ImGui_InvisibleButton(ctx, "##about", (w-my_tex_w)/2, my_tex_h, r.ImGui_ButtonFlags_None())
  r.ImGui_SameLine(ctx)
  r.ImGui_Image(ctx, aboutImg, my_tex_w, my_tex_h,
  uv_min_x, uv_min_y, uv_max_x, uv_max_y, tint_col, border_col)
  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiMain()
  bindKeyBoard()
  if r.ImGui_BeginTabBar(ctx, 'ReaChord', r.ImGui_TabBarFlags_None()) then
    if r.ImGui_BeginTabItem(ctx, ' Main ') then
      uiChordSelector()
      r.ImGui_EndTabItem(ctx)
    end
    if r.ImGui_BeginTabItem(ctx, ' About ') then
      uiAbout()
      r.ImGui_EndTabItem(ctx)
    end
    r.ImGui_EndTabBar(ctx)
  end
end

local function loop()
  r.ImGui_PushFont(ctx, G_FONT)
  r.ImGui_SetNextWindowSize(ctx, 800, 800, r.ImGui_Cond_FirstUseEver())
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowPadding(),main_window_w_padding,main_window_h_padding)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowBorderSize(),0)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_WindowBg(), MainBgColor)

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

  local chord, meta, notes = R_SelectChordItem()
  if chord == "" then
    refreshUIWhenScaleChangeWithSelectChordChange()
  else
    local chord_split = StringSplit(chord, "/")
    local meta_split = StringSplit(meta, "/")
    
    current_chord_bass = notes[1]
    current_chord_full_name = chord
    if #chord_split == 1 then
      current_chord_root = notes[1]
      current_chord_name = chord
    else
      current_chord_name = chord_split[1]
      local b = string.sub(current_chord_name, 2, 2)
      if b == "#" or b == "b" then
        current_chord_root = string.sub(current_chord_name, 1, 2)
      else
        current_chord_root = string.sub(current_chord_name, 1, 1)
      end
    end
    local current_chord_default_voicing_table, _ = T_MakeChord(current_chord_name)
    current_chord_default_voicing = ListJoinToString(current_chord_default_voicing_table, ",")
    local current_chord_voicing_table = {}
    for idx, v in ipairs(notes) do
      if idx>1 then
        table.insert(current_chord_voicing_table, v)
      end
    end
    current_chord_voicing = ListJoinToString(current_chord_voicing_table, ",")
    current_chord_pitched, _ = T_NotePitched(notes)
    current_oct = meta_split[3]
    current_scale_root = meta_split[1]
    current_scale_name = meta_split[2]
    refreshUIWhenScaleChange()
  end
end

local function startUi()
  init()
  loop()
end

r.defer(startUi)
