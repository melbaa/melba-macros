-- requires easyloot
-- requires lootres

setfenv(1, melba_macros.env)


function extract_itemlink(msg)
    local _, _, itemLink = string.find(msg, "(|c%x+|Hitem:%d+:%d+:%d+:%d+|h%[.-%]|h|r)")
    if not itemLink then
        say('an item link is required. use shift-click')
        return
    end

    local _, _, itemid = string.find(itemLink, "(item:%d+:%d+:%d+:%d+)");
    if not itemid then
        say('itemid not found for ' .. itemLink)
    end
    local itemname, _, itemrarity = GetItemInfo(itemid)
    if not itemname then
        say('itemname not found for ' .. itemLink)
    end
    return itemLink, itemid, itemname
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
    return result
end

global.SLASH_SOFTRESERVE1 = '/sr'
global.SLASH_MAINSPEC1 = '/ms'
global.SLASH_OFFSPEC1 = '/os'

function global.SlashCmdList.SOFTRESERVE(msg)
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then return end
    local msg = build_roll_string('SR', itemlink, itemname)
    global.SlashCmdList.MASTERLOOTING(msg)
end

function global.SlashCmdList.MAINSPEC(msg)
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then return end
    local msg = build_roll_string('MS', itemlink, itemname)
    global.SlashCmdList.MASTERLOOTING(msg)
end

function global.SlashCmdList.OFFSPEC(msg)
    local itemlink, itemid, itemname = extract_itemlink(msg)
    if not itemlink or not itemid or not itemname then return end
    local msg = build_roll_string('OS', itemlink, itemname)
    global.SlashCmdList.MASTERLOOTING(msg)
end

