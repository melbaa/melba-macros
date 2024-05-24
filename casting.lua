setfenv(1, melba_macros.env)

function skip_trinket(itemLink)
    local skiplist = {
        "Briarwood Reed",
        "Royal Seal of Eldre'Thalas",
        "Carrot on a Stick",
        "Goblin Car Key",
    }
    for k, trinket_name in ipairs(skiplist) do
        if string.find(itemLink, trinket_name) then
            return true
        end
    end
    return false
end

function melba_macros.cast_nobuff(spellname, buffname)
    -- local unit = UnitName("target")
    -- say(unit)
    if not IsShiftKeyDown() and global.Roids.HasBuffName(buffname, "target") then
        return
    end
    CastSpellByName(spellname)
end

function melba_macros.cast_type_with_trinkets(spellname, cast_type)
    local cast_fn = nil
    if cast_type == nil or cast_type == "cast" then
        cast_fn = CastSpellByName
    elseif cast_type == "pfcast" then
        cast_fn = global.SlashCmdList.PFCAST
    else
        say("unknown cast_type")
        return
    end

    if UnitAffectingCombat("player")
    and GetInventoryItemCooldown("player", 13)==0
    and not IsShiftKeyDown() -- shift disables trinket activation
    and not skip_trinket(GetInventoryItemLink("player", 13)) then
        SpellStopCasting();
        UseInventoryItem(13)
        SpellStopCasting();
    else
        cast_fn(spellname)
    end
end

function melba_macros.cast_with_trinkets(spellname)
    melba_macros.cast_type_with_trinkets(spellname)
end

function melba_macros.pfcast_with_trinkets(spellname)
    melba_macros.cast_type_with_trinkets(spellname, "pfcast")
end

function melba_macros.is_trinket_ready(trinket_name)
    for i=13, 14 do
        local itemLink = GetInventoryItemLink("player", i)
        if itemLink and string.find(itemLink, trinket_name) then
            local start, duration, enable = GetInventoryItemCooldown("player", i)
            return start+duration-2 <= GetTime()
        end
    end

    local bag,slot = FindItemInBags(trinket_name)
    if bag == nil then return nil end
    local  start, duration, enable = GetContainerItemCooldown(bag, slot)
    return start+duration-30-2 <= GetTime()
end

function melba_macros.use_trinket(trinket_name)
    for i=13, 14 do
        local itemLink = GetInventoryItemLink("player", i)
        if string.find(itemLink, trinket_name) then
            return UseInventoryItem(i);
        end
    end
end

function melba_macros.use_slayers_trinket()
    melba_macros.use_trinket("Slayer's Crest")
    melba_macros.use_trinket("Badge of the Swarmguard")
end



function GetSpellCooldownByName(spellName)
    local checkFor = function(bookType)
        local i = 1
        while true do
            local name, spellRank = GetSpellName(i, bookType);
            
            if not name then
                break;
            end
            
            if name == spellName then
                local start, duration = GetSpellCooldown(i, bookType);
                return start, duration;
            end
            
            i = i + 1
        end
        return nil, nil;
    end
    
    
    -- local start, duration = checkFor(BOOKTYPE_PET);
    local start, duration = checkFor(BOOKTYPE_SPELL);
    return start, duration
end



