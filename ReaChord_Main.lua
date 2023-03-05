r = reaper
print = r.ShowConsoleMsg
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Theory.lua')

local ctx = r.ImGui_CreateContext('ReaChord', r.ImGui_ConfigFlags_DockingEnable())
local G_FONT = r.ImGui_CreateFont('sans-serif', 15)
r.ImGui_Attach(ctx, G_FONT)


local OctRange = {"-1", "0", "+1"}

local current_scale_root = "C"
local current_scale_name = "Natural Maj"
local current_scale_all_notes = {"C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B"}
local current_scale_nice_notes = {"C","D","E","F","G","A","B"}
local current_oct = "0"

local current_chord_root = "C"
local current_chord_bass = "C"
local current_chord_default_voicing = "C,E,G"
local current_chord_voicing = "C,E,G"
local current_chord_pitched = {"C1", "C2", "E2", "G2"}

local MainBgColor = 0xEEE9E9FF
local ColorWhite = 0xFFFFFFFF
local ColorBlack = 0x000000FF
local ColorGray = 0x696969FF
local ColorPink = 0xFF6EB4FF
local ColorBlue = 0x0000FFFF
local ColorNormalNote = 0x838B8BFF
local ColorBtnHover = 0x4876FFFF

local main_window_w_padding = 10
local main_window_h_padding = 5
local w
local h
local w_piano_space = 2
local w_piano_key
local w_piano_half_key
local w_default_space = 4

local function refreshWindowSize()
  w, h = r.ImGui_GetWindowSize(ctx)
  w, h = w-main_window_w_padding*2, h
  w_piano_key = w/28-2
  w_piano_half_key = w/58-1
end

local function onScaleRootChange(val)
  print(val.."\n")
end

local function onScaleNameChange(val)
  print(val.."\n")
end

local function onOctChange(val)
  print(val.."\n")
end

local function onChordRootChange(val)
  print(val.."\n")
end

local function onChordBassChange(val)
  print(val.."\n")
end

local function onListenClick()
  print("listen".."\n")
end

local function onInsertClick()
  print("insert".."\n")
end

local function uiReadOnlyColorBtn(text, color, w)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(), color)
  r.ImGui_Button(ctx, text, w)
  r.ImGui_PopStyleColor(ctx, 3)
end

local function uiColorBtn(text, color, w)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), ColorBtnHover)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(), ColorBlue)
  local ret = r.ImGui_Button(ctx, text, w)
  r.ImGui_PopStyleColor(ctx, 3)
  return ret
end


local function uiPiano()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_piano_space, 0)
  -- black
  r.ImGui_InvisibleButton(ctx, "##", w_piano_half_key, 38, r.ImGui_ButtonFlags_None())
  for _, note in ipairs({
    "Db1","Eb1","-","Gb1","Ab1","Bb1","-",
    "Db2","Eb2","-","Gb2","Ab2","Bb2","-",
    "Db3","Eb3","-","Gb3","Ab3","Bb3","-",
    "Db4","Eb4","-","Gb4","Ab4","Bb4"
  }) do
    r.ImGui_SameLine(ctx)
    if note == "-" then
      r.ImGui_InvisibleButton(ctx, "##", w_piano_key, 38, r.ImGui_ButtonFlags_None())
    else
      if ListIndex(current_chord_pitched, note) > 0 then
        r.ImGui_ColorButton(ctx, "##", ColorBlue,r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, 38)
      else
        r.ImGui_ColorButton(ctx, "##", ColorBlack,r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, 38)
      end
    end
  end
  r.ImGui_SameLine(ctx)
  r.ImGui_InvisibleButton(ctx, "##", w_piano_half_key, 38, r.ImGui_ButtonFlags_None())
  
  -- white
  for idx, note in ipairs({
    "C1","D1","E1","F1","G1","A1","B1",
    "C2","D2","E2","F2","G2","A2","B2",
    "C3","D3","E3","F3","G3","A3","B3",
    "C4","D4","E4","F4","G4","A4","B4"
  }) do
    if idx >1 then
      r.ImGui_SameLine(ctx)
    end
    if ListIndex(current_chord_pitched, note) > 0 then
      r.ImGui_ColorButton(ctx, "##", ColorBlue,r.ImGui_ColorEditFlags_NoTooltip(), w/28-2, 38)
    else
      r.ImGui_ColorButton(ctx, "##", ColorWhite,r.ImGui_ColorEditFlags_NoTooltip(), w/28-2, 38)
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
  uiReadOnlyColorBtn(current_chord_bass, ColorGray, 40)
  r.ImGui_SameLine(ctx)
  r.ImGui_SetNextItemWidth(ctx, w-6*w_default_space-60-60-70-40-60-120)
  _, current_chord_voicing = r.ImGui_InputText(ctx, '##voicing', current_chord_voicing)
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("Notes:", ColorGray, 60)
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn(current_chord_bass..","..current_chord_default_voicing, ColorGray, 120)


  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiChordRoot()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_default_space, 0)

  uiReadOnlyColorBtn("ChordRoot:", ColorGray, 100)

  for _, note in ipairs(current_scale_all_notes) do
    r.ImGui_SameLine(ctx)
    if note == current_chord_root then
      if uiColorBtn(note.."##chord_root", ColorBlue, (w-12*w_default_space-100)/12) then
        onChordRootChange(note)
      end
    elseif ListIndex(current_scale_nice_notes, note) > 1 then
      if uiColorBtn(note.."##chord_root", ColorPink, (w-12*w_default_space-100)/12) then
        onChordRootChange(note)
      end
    else
      if uiColorBtn(note.."##chord_root", ColorNormalNote, (w-12*w_default_space-100)/12) then
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
      if uiColorBtn(note.."##chord_bass", ColorBlue, (w-12*w_default_space-100)/12) then
        onChordBassChange(note)
      end
    elseif ListIndex(current_scale_nice_notes, note) > 1 then
      if uiColorBtn(note.."##chord_bass", ColorPink, (w-12*w_default_space-100)/12) then
        onChordBassChange(note)
      end
    else
      if uiColorBtn(note.."##chord_bass", ColorNormalNote, (w-12*w_default_space-100)/12) then
        onChordBassChange(note)
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
  uiVoicing()
  r.ImGui_InvisibleButton(ctx, "##", w, 1, r.ImGui_ButtonFlags_None())
  uiPiano()

end

local function uiMain() 
  if r.ImGui_BeginTabBar(ctx, 'ReaChord', r.ImGui_TabBarFlags_None()) then
    if r.ImGui_BeginTabItem(ctx, 'ChordSelector') then
      uiChordSelector()
      r.ImGui_EndTabItem(ctx)
    end
    if r.ImGui_BeginTabItem(ctx, 'ChordAnalyzer') then
      r.ImGui_Text(ctx, 'This is the ChordAnalyzer tab!')
      r.ImGui_EndTabItem(ctx)
    end
    r.ImGui_EndTabBar(ctx)
  end
end

local function loop()
  r.ImGui_PushFont(ctx, G_FONT)
  r.ImGui_SetNextWindowSize(ctx, 800, 400, r.ImGui_Cond_FirstUseEver())
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowPadding(),main_window_w_padding,main_window_h_padding)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowBorderSize(),0)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_WindowBg(), MainBgColor)
  local visible, open = r.ImGui_Begin(ctx, 'ReaChord', true)
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

r.defer(loop)
