-- @description ReaChord
-- @author xupeng1206
-- @version 1.0.13
-- @changelog
--  Update
-- @provides
--   [main] ReaChord_Reader.lua
--   [main] ReaChord_Reader_Start.lua
--   [main] ReaChord_Act_Item2Sound.lua
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

local ctx = r.ImGui_CreateContext('ReaChord ColorPalette', r.ImGui_ConfigFlags_DockingEnable())
local G_FONT = r.ImGui_CreateFont('sans-serif', 15)
r.ImGui_Attach(ctx, G_FONT)

local FLT_MIN, FLT_MAX = r.ImGui_NumericLimits_Float()
local w
local h
local min_w = 600
local min_h = 768
local main_window_w_padding = 10
local main_window_h_padding = 10

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

local RDColorBackground = 0x333333
local RDColorTextLight = 0xFFFFFF
local RDColorTextGray = 0x808080

local function uiReadOnlyColorBtn(text, color, w)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(), color)
  r.ImGui_Button(ctx, text, w)
  r.ImGui_PopStyleColor(ctx, 3)
end

local function uiColorEdit4(text, color)
  local ret, new_color = r.ImGui_ColorEdit4(ctx, '## '.. text, color)
  r.ImGui_SameLine(ctx)
  r.ImGui_Text( ctx, text )
  return ret, new_color
end

local function uiColorEdit3(text, color)
  local ret, new_color = r.ImGui_ColorEdit3(ctx, '## '.. text, color)
  r.ImGui_SameLine(ctx)
  r.ImGui_Text( ctx, text )
  return ret, new_color
end

local function uiColorBtn(text, color, ww, hh)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_Button(), color)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonHovered(), ColorBtnHover)
  r.ImGui_PushStyleColor(ctx, r.ImGui_Col_ButtonActive(), ColorBlue)
  local ret = r.ImGui_Button(ctx, text, ww, hh)
  r.ImGui_PopStyleColor(ctx, 3)
  return ret
end

function uiMain()
  uiReadOnlyColorBtn("ReaChord Map", 0x696969FF, w)
  _, ColorMainBackground = uiColorEdit4('ColorMainBackground', ColorMainBackground)
  _, ColorPianoWhite = uiColorEdit4('ColorPianoWhite', ColorPianoWhite)
  _, ColorPianoBlack = uiColorEdit4('ColorPianoBlack', ColorPianoBlack)
  _, ColorGray = uiColorEdit4('ColorGray', ColorGray)
  _, ColorPink = uiColorEdit4('ColorPink', ColorPink)
  _, ColorYellow = uiColorEdit4('ColorYellow', ColorYellow)
  _, ColorDarkPink = uiColorEdit4('ColorDarkPink', ColorDarkPink)
  _, ColorMiniPianoBlack = uiColorEdit4('ColorMiniPianoBlack', ColorMiniPianoBlack)
  _, ColorRed = uiColorEdit4('ColorRed', ColorRed)
  _, ColorBlue = uiColorEdit4('ColorBlue', ColorBlue)
  _, ColorNormalNote = uiColorEdit4('ColorNormalNote', ColorNormalNote)
  _, ColorBtnHover = uiColorEdit4('ColorBtnHover', ColorBtnHover)
  _, ColorChordPadDefault = uiColorEdit4('ColorChordPadDefault', ColorChordPadDefault)
  _, ColorPieBtnLR = uiColorEdit4('ColorPieBtnLR', ColorPieBtnLR)
  _, ColorPieBtnU1 = uiColorEdit4('ColorPieBtnU1', ColorPieBtnU1)
  _, ColorPieBtnU2 = uiColorEdit4('ColorPieBtnU2', ColorPieBtnU2)
  _, ColorPieBtnD1 = uiColorEdit4('ColorPieBtnD1', ColorPieBtnD1)
  _, ColorPieBtnD2 = uiColorEdit4('ColorPieBtnD2', ColorPieBtnD2)
  _, ColorPieBtnHoverd = uiColorEdit4('ColorPieBtnHoverd', ColorPieBtnHoverd)
  uiReadOnlyColorBtn("ReaChord Reader", 0x696969FF, w)
  _, RDColorBackground = uiColorEdit3('RDColorBackground', RDColorBackground)
  _, RDColorTextLight = uiColorEdit3('RD_Color_Text_Light', RDColorTextLight)
  _, RDColorTextGray = uiColorEdit3('RD_Color_Text_Gray', RDColorTextGray)
  uiReadOnlyColorBtn("Action", 0x696969FF, w)
  if uiColorBtn("Save", 0x838B8BFF, (w-main_window_w_padding)/2, 100 ) then
    local colors = {}
    colors["ColorMainBackground"] = ColorMainBackground
    colors["ColorPianoWhite"] = ColorPianoWhite
    colors["ColorPianoBlack"] = ColorPianoBlack
    colors["ColorGray"] = ColorGray
    colors["ColorPink"] = ColorPink
    colors["ColorYellow"] = ColorYellow
    colors["ColorDarkPink"] = ColorDarkPink
    colors["ColorMiniPianoBlack"] = ColorMiniPianoBlack
    colors["ColorRed"] = ColorRed
    colors["ColorBlue"] = ColorBlue
    colors["ColorNormalNote"] = ColorNormalNote
    colors["ColorBtnHover"] = ColorBtnHover
    colors["ColorChordPadDefault"] = ColorChordPadDefault
    colors["ColorPieBtnLR"] = ColorPieBtnLR
    colors["ColorPieBtnU1"] = ColorPieBtnU1
    colors["ColorPieBtnU2"] = ColorPieBtnU2
    colors["ColorPieBtnD1"] = ColorPieBtnD1
    colors["ColorPieBtnD2"] = ColorPieBtnD2
    colors["ColorPieBtnHoverd"] = ColorPieBtnHoverd
    colors["RDColorBackground"] = RDColorBackground
    colors["RDColorTextLight"] = RDColorTextLight
    colors["RDColorTextGray"] = RDColorTextGray
    R_SaveColorConf(colors)
  end
  r.ImGui_SameLine(ctx)
  if uiColorBtn("Reset", 0x838B8BFF, (w-main_window_w_padding)/2, 100 ) then
    local colors = {}
    R_SaveColorConf(colors)
  end
end

local function refreshWindowSize()
  w, h = r.ImGui_GetWindowSize(ctx)
  w, h = w - main_window_w_padding * 2, h - 25
  --! REDUCE SIZE OF WINDOW WHEN CICRLE IS SHOWN (FOR DYNAMIC BUTTON EXPAND/SHRINK)
  if package.config:sub(1, 1) == "/" then
    -- mac or linux?
    -- h = h -15
  end

end

local function loop()
  r.ImGui_PushFont(ctx, G_FONT)
  r.ImGui_SetWindowSize(ctx, min_w, min_h, r.ImGui_Cond_FirstUseEver())
  r.ImGui_SetNextWindowSizeConstraints(ctx, min_w, min_h, min_w, min_h)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowPadding(), main_window_w_padding, main_window_h_padding)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowBorderSize(), 0)
  -- r.ImGui_PushStyleColor(ctx, r.ImGui_Col_WindowBg(), ColorMainBackground)

  local window_flags = r.ImGui_WindowFlags_None()
  window_flags = window_flags | r.ImGui_WindowFlags_NoScrollbar()
  window_flags = window_flags | r.ImGui_WindowFlags_NoNav()
  window_flags = window_flags | r.ImGui_WindowFlags_NoDocking()

  local visible, open = r.ImGui_Begin(ctx, 'ReaChord ColorPalette', true, window_flags)
  if visible then
    -- todo fetch color from conf
    refreshWindowSize()
    uiMain()
    r.ImGui_End(ctx)
  end
  r.ImGui_PopFont(ctx)

  if open then
    r.defer(loop)
  end
  r.ImGui_PopStyleVar(ctx, 2)
  -- r.ImGui_PopStyleColor(ctx, 1)
end


local function startUi()
  loop()
end

r.defer(startUi)
