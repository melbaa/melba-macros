setfenv(1, melba_macros.env)

local DEFAULT_CHAT_FRAME = global.DEFAULT_CHAT_FRAME

display_lastmsg = ''
display_lastts = 0

function say(msg)
    DEFAULT_CHAT_FRAME:AddMessage("melba-macros: " .. (msg or "nil"))
end

message = function(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cffcccc33INFO: |cffffff55" .. ( msg or "nil" ))
end

print = message


function display(msg)
    if global.MikSBT.DisplayMessage then
        global.MikSBT.DisplayMessage(msg, nil, false, .2, .7, .9)
    end
    print(msg)

end

function display_ratelimited(msg)
    local ts = GetTime()

    if msg ~= display_lastmsg then
        display(msg)
        display_lastmsg = msg
        display_lastts = GetTime()
        return
    end

    if ts >= display_lastts + 2 then
        display(msg)
        display_lastmsg = msg
        display_lastts = GetTime()
        return
    end
end


function colorize(txt, prependAppName)
    if prependAppName == true then
        source = 'melba: ' .. txt
    end

    txt = string.gsub(txt, "@B", "|cFF008fec")
    txt = string.gsub(txt, "@W", "|cFFFFFFFF")
    txt = string.gsub(txt, "@Y", "|cFFFFFF00")
    txt = string.gsub(txt, "@R", "|cFFFF5179")
    txt = string.gsub(txt, "@G", "|cFF00FF7F")

    return txt
end





