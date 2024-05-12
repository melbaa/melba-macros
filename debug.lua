local say = melba_macros.env.say
local print = melba_macros.env.print

function debuglink(link)
    -- /script DEFAULT_CHAT_FRAME:AddMessage("\124cffa335ee\124Hitem:60486:0:0:0:0:0:0:0:0\124h[Fishbringer]\124h\124r");
    --/script DEFAULT_CHAT_FRAME:AddMessage("\124cffffffff\124Hitem:13423:0:0:0:0:0:0:0:0\124h[Stonescale Oil]\124h\124r");
    -- "|cffff8000|Hitem:19019:0:0:0|h[Thunderfury, Blessed Blade of the Windseeker]|h|r"
    --/script DEFAULT_CHAT_FRAME:AddMessage("\124cffffffff\124Hitem:13423:0:0:0:0:0:0:0:0\124h[Alyssane's Tears]\124h\124r");
    --/script DEFAULT_CHAT_FRAME:AddMessage("\124cffa335ee\124Hitem:23014:1900:0:0\124h[Alyssane and Maryhuff's Tears]\124h\124r");

    local _, _, itemId = string.find(link, "item:(%d+):%d+:%d+:%d+")
    -- say('itemId ' .. itemId)
    itemId = tonumber(itemId)
    -- say('itemId ' .. itemId)
    local itemName, itemLink, itemQuality, itemRequiredLevel, itemType, itemSubType, itemCount, itemEquipLoc, itemTexture = GetItemInfo(itemId);
    if itemTexture then
        say('itemTexture ' .. itemTexture)
    else
        say('itemTexture not found')
    end

    local printable = gsub(link, "\124", "\124\124");
    say("Here's what it really looks like: \"" .. printable .. "\"");
end





function GetItemLinkByName(name)
  for itemID = 1, 65200 do
    local itemName, hyperLink, itemQuality = GetItemInfo(itemID)
    if (itemName and itemName == name) then
      local _, _, _, hex = GetItemQualityColor(tonumber(itemQuality))
      local fulltxt = hex.. "|H"..hyperLink.."|h["..itemName.."]|h|r"
      print(fulltxt)
      return hex.. "|H"..hyperLink.."|h["..itemName.."]|h|r"
    end
  end
end



function GetLockedItemInBags()
    for bag=-2, 11 do
        local bagsize = GetContainerNumSlots(bag)
        for slot=1, bagsize do
            local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
            if locked then
                local link = GetContainerItemLink(bag, slot)
                print(link)
            end
        end
    end
end


-- local hstexture = 'Ability_Rogue_Ambush'
-- local hsslot = find_action_slot(hstexture)
function find_action_slot(spellTexture, verbose)
    -- IsUsableAction / IsCurrentAction / IsAutoRepeatAction
	for i = 1, 120 do
        local texture = GetActionTexture(i)
        if verbose then
            print(tostring(i) .. ' ' .. tostring(texture))
        end
        if ( texture ~= nil and strfind(texture, spellTexture)) then return i; end;
	end;
	return nil
end;



--[[
--was a test to see if nameplates can be found iterating through all frames
function findplates()
    local worldFrameChildCount = WorldFrame:GetNumChildren()
    local worldFrames = {WorldFrame:GetChildren()}
    for index = 1, worldFrameChildCount do
        local plate = worldFrames[index]
        if plate ~= nil and plate:GetName() == nil then
            -- This is a standard vanilla wow nameplate
            if plate["name"] then
                print('found builtin plate')
            else
                -- this is a modified pfUI/Shagu nameplate
                local _, shaguplate = plate:GetChildren()
                if shaguplate ~= nil and type(shaguplate.platename) == "string" then
                    print(shaguplate.platename)
                end
            end
        end
    end
end
--]]
