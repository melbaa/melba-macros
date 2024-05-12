-- requires AdvancedVanillaCombatLog

setfenv(1, melba_macros.env)


local myname = UnitName("player")

function parse_combatlog(arg1)
    local actionStatus = "Hit";

    local _, _, spellEffect, creature, dmg = string.find(arg1, myname .. " 's (.*) hits (.*) for (.*).");
    
    if(spellEffect == nil or creature == nil or dmg == nil) then
        _, _, spellEffect, creature, dmg = string.find(arg1, myname .. " 's (.*) crits (.*) for (.*).");
        actionStatus = "Crit";
    end
    
    if(spellEffect == nil or creature == nil or dmg == nil) then
        _, _, spellEffect, creature = string.find(arg1, myname .. " 's (.*) was resisted by (.*).");
        dmg = 0;
        actionStatus = "Resist";
    end

    if(spellEffect == nil or creature == nil or dmg == nil) then
        _, _, spellEffect, creature = string.find(arg1, myname .. " performs (.*) on (.*).");
        dmg = 0;
        actionStatus = "Perform";
    end
    
    if(spellEffect == nil or creature == nil or dmg == nil) then
        _, _, spellEffect, creature = string.find(arg1, myname .. " 's (.*) misses (.*).");
        dmg = 0;
        actionStatus = "Miss";
    end
    
    if(spellEffect == nil or creature == nil or dmg == nil) then
        _, _, spellEffect, creature = string.find(arg1, myname .. " 's (.*) was dodged by (.*).");
        dmg = 0;
        actionStatus = "Dodge";
    end

    if(spellEffect == nil or creature == nil or dmg == nil) then
        _, _, spellEffect, creature = string.find(arg1, myname .. " 's (.*) was parried by (.*).");
        dmg = 0;
        actionStatus = "Parry";
    end
    
    if(spellEffect == nil or creature == nil or dmg == nil) then
        actionStatus = "Unknown";
    end

    if((actionStatus == "Resist" or actionStatus == "Miss" or actionStatus == "Dodge" or actionStatus == "Parry") and spellEffect == "Sunder Armor") then
        --if UnitClassification("target") == "worldboss" then
            --SendChatMessage("Sunder Armor: Failed", "SAY"); 
        --end
        local msg = "sunder armor: failed (" .. actionStatus .. ")"
        -- say(msg)
        if GetZoneText() == "Blood Ring" then return end
        SendChatMessage(msg,"SAY",nil);
    elseif(actionStatus == "Unknown") then
        say("UNPARSED3: "..arg1);
    end
end


