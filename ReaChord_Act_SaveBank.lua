r = reaper
print = r.ShowConsoleMsg
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Util.lua')
dofile(r.GetResourcePath() .. '/Scripts/ReaChord/ReaChord_Reaper.lua')

local ctx = r.ImGui_CreateContext('ReaChord-SaveBank', r.ImGui_ConfigFlags_DockingEnable())
local G_FONT = r.ImGui_CreateFont('sans-serif', 15)
r.ImGui_Attach(ctx, G_FONT)

B_UI_OPEN = false
B_UI_VISIBLE = false
B_BANK_TAG = "Pattern 1"
B_FULL_CHORD_PATTERNS = ""
B_CHORD_PATTERNS = ""

local function loop()
  r.ImGui_PushFont(ctx, G_FONT)
  r.ImGui_SetNextWindowSize(ctx, 400, 120, r.ImGui_Cond_FirstUseEver())
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowPadding(),10, 10)
  r.ImGui_PushStyleVar(ctx, r.ImGui_StyleVar_WindowBorderSize(),0)

  local window_flags = r.ImGui_WindowFlags_None()
  window_flags = window_flags | r.ImGui_WindowFlags_NoScrollbar()
  window_flags = window_flags | r.ImGui_WindowFlags_NoNav()
  window_flags = window_flags | r.ImGui_WindowFlags_NoDocking()

  B_UI_VISIBLE, B_UI_OPEN = r.ImGui_Begin(ctx, 'ReaChord-SaveBank', true, window_flags)
  
  if B_UI_VISIBLE then
    -- input text & button
    r.ImGui_Text(ctx, B_CHORD_PATTERNS)
    r.ImGui_Text(ctx, "")
    if r.ImGui_Button(ctx, "SaveBank", 100) then
        if B_CHORD_PATTERNS == 'Please select a chord progression.' then
            B_UI_OPEN = false
        else
            local full_bk = B_BANK_TAG .. '@'.. B_CHORD_PATTERNS .. '@' .. B_FULL_CHORD_PATTERNS
            R_SaveBank(full_bk)
            B_UI_OPEN = false
        end
    end
    r.ImGui_SameLine(ctx)
    _, B_BANK_TAG = r.ImGui_InputText(ctx, 'Bank Tag##tag', B_BANK_TAG)

    r.ImGui_End(ctx)
  end
  r.ImGui_PopFont(ctx)
  
  if B_UI_OPEN then
    r.defer(loop)
  end
  r.ImGui_PopStyleVar(ctx, 2)
end

local function init()
    B_FULL_CHORD_PATTERNS = R_SelectChordItems()
    local simple_chords = {}
    local chords = StringSplit(B_FULL_CHORD_PATTERNS, "~")
    if #chords>1 then
        for idx, chord in ipairs(chords) do
            local chord_name = StringSplit(chord, "|")[1]
            local chord_len = StringSplit(chord, "|")[5]
            local full_chord = chord_name .. '*' .. chord_len
            table.insert(simple_chords, full_chord)
        end
        B_CHORD_PATTERNS = ListJoinToString(simple_chords, "->")
    else
        B_CHORD_PATTERNS = 'Please select a chord progression.'
    end
end

local function startUi()
  init()
  loop()
end

r.defer(startUi)
