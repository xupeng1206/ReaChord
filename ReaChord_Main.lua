r = reaper
print = r.ShowConsoleMsg
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Theory.lua')

local ctx = r.ImGui_CreateContext('ReaChord', r.ImGui_ConfigFlags_DockingEnable())
local G_FONT = r.ImGui_CreateFont('sans-serif', 15)
r.ImGui_Attach(ctx, G_FONT)

local current_chord_bass = "C"
local current_chord_default_voicing = "C,E,G"
local current_chord_voicing = "C,E,G"
local current_chord_pitched = {"C1", "C2", "E2", "G2"}

local MainBgColor = 0xEEE9E9FF
local ColorWhite = 0xFFFFFFFF
local ColorBlack = 0x000000FF
local ColorGray = 0x696969FF
local ColorPink = 0xFFAEB9FF


local OCT = {"-1", "0", "+1"}

local scale_root_current_index = 1
local scale_name_current_index = 1
local oct_current_index = 2

local main_window_padding = 10
local w
local h
local w_piano_space = 2
local w_piano_key
local w_piano_half_key
local w_top_space = 4

local function refreshWindowSize()
  w, h = r.ImGui_GetWindowSize(ctx)
  w, h = w-main_window_padding*2, h-21
  w_piano_key = w/28-2
  w_piano_half_key = w/58-1
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
      if FindIndexByValueForList(current_chord_pitched, note) > 0 then
        r.ImGui_ColorButton(ctx, "##", ColorPink,r.ImGui_ColorEditFlags_NoTooltip(), w_piano_key, 38)
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
    if FindIndexByValueForList(current_chord_pitched, note) > 0 then
      r.ImGui_ColorButton(ctx, "##", ColorPink,r.ImGui_ColorEditFlags_NoTooltip(), w/28-2, 38)
    else
      r.ImGui_ColorButton(ctx, "##", ColorWhite,r.ImGui_ColorEditFlags_NoTooltip(), w/28-2, 38)
    end
  end
  r.ImGui_PopStyleVar(ctx, 1)
end

local function uiScaleRootSelector()
  if r.ImGui_BeginCombo(ctx, '##ScaleRoot', G_FLAT_NOTE_LIST[scale_root_current_index], r.ImGui_ComboFlags_HeightLarge()) then
    for i, v in ipairs(G_FLAT_NOTE_LIST) do
      local is_selected = scale_root_current_index == i
      if r.ImGui_Selectable(ctx, v, is_selected) then
        scale_root_current_index = i
      end

      if is_selected then
        r.ImGui_SetItemDefaultFocus(ctx)
      end
    end
    r.ImGui_EndCombo(ctx)
  end
end

local function uiScaleNameSelector()
  if r.ImGui_BeginCombo(ctx, '##ScalePattern', G_SCALE_NAMES[scale_name_current_index], r.ImGui_ComboFlags_HeightLarge()) then
    for i, v in ipairs(G_SCALE_NAMES) do
      local is_selected = scale_name_current_index == i
      if r.ImGui_Selectable(ctx, v, is_selected) then
        scale_name_current_index = i
      end

      if is_selected then
        r.ImGui_SetItemDefaultFocus(ctx)
      end
    end
    r.ImGui_EndCombo(ctx)
  end
end

local function uiOctSelector()
  local  octs = {}
  if r.ImGui_BeginCombo(ctx, '##Oct', OCT[oct_current_index], r.ImGui_ComboFlags_HeightLarge()) then
    for i, v in ipairs(OCT) do
      local is_selected = oct_current_index == i
      if r.ImGui_Selectable(ctx, v, is_selected) then
        oct_current_index = i
      end

      if is_selected then
        r.ImGui_SetItemDefaultFocus(ctx)
      end
    end
    r.ImGui_EndCombo(ctx)
  end
end

local function uiReadOnlyColorBtn(text, color, w)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(), color)
  r.ImGui_Button(ctx, text, w)
  r.ImGui_PopStyleColor(ctx, 3)
end

local function uiTop()
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_ItemSpacing(), w_top_space, 0)

  r.ImGui_SetNextItemWidth(ctx, 50)
  uiScaleRootSelector()
  r.ImGui_SameLine(ctx)
  r.ImGui_SetNextItemWidth(ctx, 200)
  uiScaleNameSelector()
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("Oct:", ColorGray, 40)
  r.ImGui_SameLine(ctx)
  r.ImGui_SetNextItemWidth(ctx, 50)
  uiOctSelector()
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn("Voicing:", ColorGray, 70)
  r.ImGui_SameLine(ctx)
  uiReadOnlyColorBtn(current_chord_bass, ColorGray, 40)
  r.ImGui_SameLine(ctx)
  r.ImGui_SetNextItemWidth(ctx, w-8*w_top_space-50-200-40-50-70-40-60-60)
  _, current_chord_voicing = r.ImGui_InputText(ctx, '##voicing', current_chord_voicing)
  r.ImGui_SameLine(ctx)
  r.ImGui_Button(ctx, "Listen", 60)
  r.ImGui_SameLine(ctx)
  r.ImGui_Button(ctx, "Insert", 60)
  
  r.ImGui_PopStyleVar(ctx, 1)
end


local function uiChordSelector()
  uiTop()
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
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowPadding(),main_window_padding,0)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowBorderSize(),0)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_WindowBg(), MainBgColor)
  local visible, open = r.ImGui_Begin(ctx, 'My window', true)
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
