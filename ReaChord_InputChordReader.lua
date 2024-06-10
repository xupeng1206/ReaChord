--@noindex
--NoIndex: true

--// USER CONFIG AREA 
-- RDColorBackground = "#333333"
RDColorBackground = "#333333"
RDColorTextLight = "White"
RDColorTextGray = "Gray"

no_regions_text = true -- set to false to desactivate "NO REGIONS UNDER PLAY CURSOR" instructions
console = true         -- Display debug messages in the console

--// -------------------- END OF USER CONFIG AREA


--// INITIAL VALUES //--
font_size = 40
font_name = "Arial"
format = 0

vars = {}
vars.wlen = 640
vars.hlen = 270
vars.docked = 0
vars.xpos = 100
vars.ypos = 100

ext_name = "ReaChord InputChordReader"

region_duration = 1
current_chords = "No Chord Detected"

-- Performance
local reaper = reaper

dofile(reaper.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')
dofile(reaper.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Theory.lua')
dofile(reaper.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Reaper.lua')


-- DEBUG
function Msg(value)
    if console then
        reaper.ShowConsoleMsg(tostring(value) .. "\n")
    end
end

function initChordDisplay()
    current_chords = "No Notes"
end

-- Set ToolBar Button State
function SetButtonState(set)
    local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
    reaper.SetToggleCommandState(sec, cmd, set or 0)
    reaper.RefreshToolbar2(sec, cmd)
end

--// COLOR FUNCTIONS //--
function INT2RGB(color_int)
    if color_int >= 0 then
        R, G, B = reaper.ColorFromNative(color_int)
    else
        R, G, B = 255, 255, 255
    end
    rgba(R, G, B, 255)
end

function rgba(r, g, b, a)
    if a ~= nil then gfx.a = a / 255 else a = 255 end
    gfx.r = r / 255
    gfx.g = g / 255
    gfx.b = b / 255
end

function HexToRGB(value)
    local hex = value:gsub("#", "")
    local R = tonumber("0x" .. hex:sub(1, 2))
    local G = tonumber("0x" .. hex:sub(3, 4))
    local B = tonumber("0x" .. hex:sub(5, 6))

    if R == nil then R = 0 end
    if G == nil then G = 0 end
    if B == nil then B = 0 end

    gfx.r = R / 255
    gfx.g = G / 255
    gfx.b = B / 255
end

function color(col)
    if string.find(col, "#.+") ~= nil then
        color2 = col
        HexToRGB(color2)
    end
    if col == "White" then HexToRGB("#FFFFFF") end
    if col == "Silver" then HexToRGB("#C0C0C0") end
    if col == "Gray" then HexToRGB("#808080") end
    if col == "Black" then HexToRGB("#000000") end
    if col == "Red" then HexToRGB("#FF0000") end
    if col == "Maroon" then HexToRGB("#800000") end
    if col == "Yellow" then HexToRGB("#FFFF00") end
    if col == "Olive" then HexToRGB("#808000") end
    if col == "Lime" then HexToRGB("#00FF00") end
    if col == "Green" then HexToRGB("#008000") end
    if col == "Aqua" then HexToRGB("#00FFFF") end
    if col == "Teal" then HexToRGB("#008080") end
    if col == "Blue" then HexToRGB("#0000FF") end
    if col == "Navy" then HexToRGB("#000080") end
    if col == "Fuchsia" then HexToRGB("#FF00FF") end
    if col == "Purple" then HexToRGB("#800080") end
end

--// ELEMENTS //--
function DrawProgressBar() -- Idea from Heda's Notes Reader
    -- progress_percent = (play_pos - region_start) / region_duration
    progress_percent = 0
    rect_h = gfx.h / 10

    INT2RGB(region_color)
    gfx.rect(0, 0, gfx.w, rect_h)

    rgba(255, 255, 255, 200)
    gfx.rect(0, 0, gfx.w * progress_percent, rect_h)
    gfx.y = rect_h * 2
end

function StringArea(string, ratio)
    gfx.setfont(1, font_name, 100)

    str_w, str_h = gfx.measurestr(string)
    fontsizefit = (gfx.w / (str_w + 50)) * 100           -- new font size needed to fit.
    fontsizefith = ((gfx.h - gfx.y) / (str_h + 0)) * 100 -- new font size needed to fit in vertical.

    font_size = math.min(fontsizefit, fontsizefith)
    gfx.setfont(1, font_name, font_size * ratio)
    str_w, str_h = gfx.measurestr(string)
    return str_w, str_h, font_size * ratio
end

function CenterAndResizeText(string)
    gfx.setfont(1, font_name, 100)

    str_w, str_h = gfx.measurestr(string)
    fontsizefit = (gfx.w / (str_w + 50)) * 100           -- new font size needed to fit.
    fontsizefith = ((gfx.h - gfx.y) / (str_h + 0)) * 100 -- new font size needed to fit in vertical.

    font_size = math.min(fontsizefit, fontsizefith)
    gfx.setfont(1, font_name, font_size)

    str_w, str_h = gfx.measurestr(string)
    gfx.x = gfx.w / 2 - str_w / 2
    gfx.y = gfx.y
end

function GFXPrintLine(string)
    CenterAndResizeText(string)
    color(RDColorTextGray)
    gfx.printf(string)
    gfx.y = gfx.y + font_size
end

function DrawBackground()
    color(RDColorBackground)
    gfx.rect(0, 0, gfx.w, gfx.h)
end

local function refreshColors()
    RDColorBackground = "#333333"
    RDColorTextLight = "White"
    RDColorTextGray = "Gray"
    local colors = R_GetColorConf()
    for name, color in pairs(colors) do
      if name == "RDColorBackground" then
        RDColorBackground = '#'..color:sub(5,10)
      end
      if name == "RDColorTextLight" then
        RDColorTextLight = '#'..color:sub(5,10)
      end
      if name == "RDColorTextGray" then
        RDColorTextGray = '#'..color:sub(5,10)
      end
    end
  end


--// INIT //--
function init()
    -- R_ImportChordTrack()
    GetExtStates()
    gfx.init("ReaChord NoteReader", vars.wlen, vars.hlen, vars.docked, vars.xpos, vars.ypos) -- name,width,height,dockstate,xpos,ypos
    gfx.setfont(1, font_name, font_size, 'b')
    --color(text_color)
    refreshColors()
end

function DoExitFunctions()
    SetButtonState(-1)
    SaveState()
end

function SaveState()
    vars.docked, vars.xpos, vars.ypos, vars.wlen, vars.hlen = gfx.dock(-1, 0, 0, 0, 0)
    for k, v in pairs(vars) do
        SaveExtState(k, v)
    end
end

function SaveExtState(var, val)
    reaper.SetExtState(ext_name, var, tostring(val), true)
end

function GetExtState(var, val)
    if reaper.HasExtState(ext_name, var) then
        local t = type(val)
        val = reaper.GetExtState(ext_name, var)
        if t == "boolean" then
            val = toboolean(val)
        elseif t == "number" then
            val = tonumber(val)
        else
        end
    end
    return val
end

function GetExtStates()
    for k, v in pairs(vars) do
        vars[k] = GetExtState(k, v)
    end
end

--// MAIN //--
function run()
    offset = reaper.GetProjectTimeOffset(proj, false)

    DrawBackground()

    -- PLAY STATE
    play_state = reaper.GetPlayState()
    if play_state == 0 then play_pos = reaper.GetCursorPosition() else play_pos = reaper.GetPlayPosition() end

    initChordDisplay()

    is_region, region_start, region_end, region_meta = R_GetChordItemMeteByPosition(play_pos)
    region_color = 0
    if is_region then
        -- region_duration = region_end - region_start
        -- local meta_split = StringSplit(region_meta, "|")
        -- current_chords = ListJoinToString(StringSplit(meta_split[2], ","), " ")
    else
        gfx.y = 0
    end
    local scale_root = reaper.GetExtState("ReaChord", "ScaleRoot")
    if scale_root == nil or scale_root == "" then
        scale_root = "C"
    end
    local chords, chord_details = R_GetMIDIInputChord(scale_root)
    current_chords = ListJoinToString(chords, " | ")

    if gfx.mouse_cap == 2 and (not is_region or gfx.mouse_y < rect_h) then
        local dock = gfx.dock(-1) == 0 and "Dock" or "Undock"
        gfx.x = gfx.mouse_x
        gfx.y = gfx.mouse_y
        if gfx.showmenu(dock) == 1 then
            if gfx.dock(-1) == 0 then gfx.dock(1) else gfx.dock(0) end
        end
    end

    -- From SPK77's Clock script
    -- CHANGE FORMAT WITH A CLICK
    if mouse_state == 0 and gfx.mouse_cap == 2 and gfx.mouse_x > 5 and gfx.mouse_x < gfx.w - 5 and gfx.mouse_y > 5 and gfx.mouse_y < gfx.h - 5 then
        mouse_state = 1
        if format < 2 then
            format = format + 1
        else
            format = 0
        end
    end

    if gfx.mouse_cap == 0 then mouse_state = 0 end

    -- Left clik return cursor at the begining of the region smooth seek
    if gfx.mouse_cap == 1 then
        if is_region then
            if gfx.mouse_y < rect_h then
                reaper.SetEditCurPos(region_start, false, true)
            else
                reaper.Main_OnCommand(40616, 0)
            end
        end
    end

    -- DRAW
    if current_chords ~= "" then
        DrawProgressBar()
        if format > 0 then
            GFXPrintLine(current_chords)
        else
            GFXPrintLine(current_chords)
        end
    else
        GFXPrintLine("No Chord Detected")
    end

    gfx.update()

    char = gfx.getchar()
    if char == 27 or char == -1 then gfx.quit() else reaper.defer(run) end
end -- END DEFER

--// RUN //--
SetButtonState(1)
init()
run()
reaper.atexit(DoExitFunctions)
