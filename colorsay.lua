setfenv(1, melba_macros.env)


--[[
colored text
000000 Black
FFFFFF White
FF0000 Red
FF9900 Orange
FFFF00 Yellow
66FF00 Green
00B4FF Blue
CC00FF Purple
/run if(not scm) then scm = SendChatMessage; end; function SendChatMessage(msg, type, lang, chan) scm("\124cffFF9900\124Hitem:19:0:0:0:0:0:0:0\124h" ..msg.."\124h\124r", type, lang, chan);end;
/run if scm then SendChatMessage = scm; end;
]]
local scm_orig = nil
local scm_colors = {
    black='000000',
    white='FFFFFF',
    red='FF0000',
    orange='FF9900',
    yellow='FFFF00',
    green='66FF00',
    blue='00B4FF',
    purple='CC00FF'
}

function colorsay(message)

    -- delayed assignment, cuz other addons also hook this
    if not scm_orig then
        scm_orig = SendChatMessage
    end

    local commandlist = { }
    local command

    for command in gfind(message, "[^ ]+") do
        table.insert(commandlist, command)
    end

    if commandlist[1] then
        commandlist[1] = string.lower(commandlist[1])
    end

    if commandlist[1] == 'off' then
        SendChatMessage = scm_orig;
        say('/colorsay disabled')
        return
    end

    local color = scm_colors[commandlist[1]]

    if color == nil then
        say('/colorsay <color>. colors are black, white, red, orange, yellow, green, blue, purple, off.')
        SendChatMessage = scm_orig;
        say('/colorsay disabled')
        return
    end

    function SendChatMessage(msg, type, lang, chan)
        -- roid-macros hooks this; we have to replicate
        if msg and string.find(msg, "^#showtooltip ") then
            return;
        end
        -- say(' ' .. tostring(type) .. ' ' .. tostring(lang) .. ' ' .. tostring(chan))
        -- avoid colored text in World and General etc
        if string.lower(type) ~= 'channel' then
            msg = "\124cff" .. color
            .. "\124Hitem:19:0:0:0:0:0:0:0\124h"
            .. msg .. "\124h\124r"
        end
        scm_orig(msg, type, lang, chan);
    end
end





global.SlashCmdList["COLORSAY"] = colorsay
global.SLASH_COLORSAY1="/colorsay"
