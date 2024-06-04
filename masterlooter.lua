-- requires easyloot
-- requires lootres

setfenv(1, melba_macros.env)

last_itemlink_rolled = ''
last_roll_type = ''

function extract_itemlink(msg)
    local _, _, itemlink = string.find(msg, "(|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[.-%]|h|r)")
    if not itemlink then
        say('an item link is required. use shift-click')
        return
    end

    local _, _, itemid = string.find(itemlink, "(item:%d+:%d+:%d+:%d+)");
    if not itemid then
        say('itemid not found for ' .. itemlink)
    end
    local itemname, _, itemrarity = GetItemInfo(itemid)
    if not itemname then
        say('itemname not found for ' .. itemlink)
    end
    last_itemlink_rolled = itemlink
    return itemlink, itemid, itemname
end

function reserved_players(itemname)
    local result = ''

    for playerName, item in next, global.LOOTRES_RESERVES do
        if (string.lower(itemname) == string.lower(item)) then
            if string.len(result) ~= 0 then
                result = result .. ' '
            end
            result = result .. playerName
        end
    end
    return result
end

function build_roll_string(rolltype, itemlink, itemname)
    local result = itemlink .. ' ' .. rolltype
    if rolltype == 'SR' then
        local reserves = reserved_players(itemname)
        if reserves ~= '' then
            result = result .. ' (' .. reserves .. ')'
        end
    end
    last_roll_type = rolltype
    return result
end

global.SLASH_SOFTRESERVE1 = '/sr'
global.SLASH_MAINSPEC1 = '/ms'
global.SLASH_OFFSPEC1 = '/os'
global.SLASH_FREEROLL1 = '/freeroll'
global.SLASH_CHECKSR1 = '/checksr'

function global.SlashCmdList.SOFTRESERVE(msg)
    last_itemlink_rolled = ''
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then return end
    local msg = build_roll_string('SR', itemlink, itemname)
    global.SlashCmdList.MASTERLOOTING(msg)
end

function global.SlashCmdList.MAINSPEC(msg)
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then
        say('no itemlink found. using last_itemlink_rolled')
        msg = last_itemlink_rolled
    end
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then return end
    local msg = build_roll_string('MS', itemlink, itemname)
    global.SlashCmdList.MASTERLOOTING(msg)
end

function global.SlashCmdList.OFFSPEC(msg)
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then
        say('no itemlink found. using last_itemlink_rolled')
        msg = last_itemlink_rolled
    end
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then return end
    local msg = build_roll_string('OS', itemlink, itemname)
    global.SlashCmdList.MASTERLOOTING(msg)
end

function global.SlashCmdList.FREEROLL(msg)
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then
        say('no itemlink found. using last_itemlink_rolled')
        msg = last_itemlink_rolled
    end
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then return end
    local msg = build_roll_string('FREE', itemlink, itemname)
    global.SlashCmdList.MASTERLOOTING(msg)
end

function global.SlashCmdList.CHECKSR(msg)
    for i = 1, GetNumRaidMembers() do
        if (GetRaidRosterInfo(i)) then
            local n, _, _, _, _, _, z = GetRaidRosterInfo(i);
            if global.LOOTRES_RESERVES[n] == nil then
                local warnmsg = 'no SR for ' .. n
                say(warnmsg)
                if string.len(msg) ~= 0 then
                    SendChatMessage(warnmsg, "RAID")
                end
            end
        end
    end
end
