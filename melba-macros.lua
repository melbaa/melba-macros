melba_macros.initialized = nil
melba_macros.TALENT_MS = nil  -- lazy init
melba_macros.TALENT_BT = nil  -- lazy init


local say = melba_macros.env.say
local display = melba_macros.env.display
local print = melba_macros.env.print
local PARTY_INVITE_REQUEST_OnEvent = melba_macros.env.PARTY_INVITE_REQUEST_OnEvent
local parse_combatlog = melba_macros.env.parse_combatlog
local auto_roll = melba_macros.env.auto_roll












function melba_macros.get_talent_position(name)
	for i = 1, GetNumTalentTabs() do
		for j = 1, GetNumTalents(i) do
			if GetTalentInfo(i, j) == name then return {i, j} end
		end
	end
end


function melba_macros.initialize()
    Chronos.afterInit(melba_macros.initialize2)
    say('initialize')
end

function melba_macros.initialize2()
    melba_macros.TALENT_MS = melba_macros.get_talent_position("Mortal Strike")
    melba_macros.TALENT_BT = melba_macros.get_talent_position("Bloodthirst")
    -- if melba_macros.TALENT_MS == nil then return end
    -- if melba_macros.TALENT_BT == nil then return end
    melba_macros.initialized = 1

    say('initialize2')
end

--melba_macros:RegisterEvent("CHAT_MSG_ADDON")
melba_macros:RegisterEvent("ADDON_LOADED")
--melba_macros:RegisterEvent("SPELLS_CHANGED")
melba_macros:RegisterEvent("LEARNED_SPELL_IN_TAB")
melba_macros:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
melba_macros:RegisterEvent("START_LOOT_ROLL");
--melba_macros:RegisterAllEvents()
melba_macros:SetScript("OnEvent", function()

    if event == "ADDON_LOADED" and arg1 == 'melba-macros' then melba_macros.initialize() return end
    -- if event == "SPELLS_CHANGED" then melba_macros.initialize() return end
    if event == "LEARNED_SPELL_IN_TAB" then melba_macros.initialize2() return end


    if event == "START_LOOT_ROLL" then auto_roll(arg1) return end
    if event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then parse_combatlog(arg1) return end

    if event == "PARTY_INVITE_REQUEST" then
        PARTY_INVITE_REQUEST_OnEvent(arg1)
    end



    --[[
    if event == 'CHAT_MSG_CHANNEL' then return end
    if event == 'CHAT_MSG_CHANNEL_JOIN' then return end
    if event == 'CHAT_MSG_CHANNEL_LEAVE' then return end
    if event == 'UPDATE_CHAT_WINDOWS' then return end
    if event == 'PLAYER_GUILD_UPDATE' then return end
    if event == 'TABARD_CANSAVE_CHANGED' then return end
    if event == 'UNIT_RAGE' then return end
    if event == 'SPELL_UPDATE_USABLE' then return end
    if event == 'UPDATE_INVENTORY_ALERTS' then return end
    if event == 'CURSOR_UPDATE' then return end
    if string.find(event, 'CHAT_MSG') then return end
    say(event)
    ]]

    if event ~= 'CHAT_MSG_ADDON' then return end

    if arg1 == 'Quiver' then return end
    if arg4 == 'Xoanon' and arg3 == 'GUILD' then return end -- spams rank stats
	if string.find(arg1, 'gatherer_') then return end
	if arg1 == 'RAB/BT' then return end
	if arg1 == 'pfQuest' then return end
	if arg1 == 'TW_SHOP' then return end
	if arg1 == 'TW_TRANSMOG' then return end
	if arg1 == 'LFT' then return end
    if arg1 then say('arg1 ' .. arg1) end
    if arg2 then say('arg2 ' .. arg2) end
    if arg3 then say('arg3 ' .. arg3) end
    if arg4 then say('arg4 ' .. arg4) end
    if arg5 then say('arg5 ' .. arg5) end
end)





--[[
old mpowa auras
flurry for hamstring
    buff flurry
    picture hamstring Interface\Icons\Ability_ShockWave
    options invert
    function - return Roids.GetCurrentShapeshiftIndex() == 3
revenge
    function - local start, dur, enabled = GetSpellCooldown(53, BOOKTYPE_SPELL)return IsUsableAction(63) and dur == 0
]]

--[[
revenge macro

#showtooltip Revenge
/run -- CastSpellByName("Revenge")
/run melba_macros.target_nearest_enemy()
/startattack
/cast [stance:2] Revenge
/cast [stance:3] Berserker Rage
--]]

-- /run if GetZoneText()=="Ahn'Qiraj" then CastSpellByName("summon yellow qiraji battle tank") else CastSpellByName("Black Wolf")  end
-- Ruins of Ahn'Qiraj


-- mind flay / arcane missile spam
-- /run if pfUI.castbar.player:GetAlpha() ~= 1 then CastSpellByName("Mind Flay") end -- with pfui
-- /run local f=CnlSpam if not f then f=CreateFrame("Frame")local s,r="SPELLCAST_CHANNEL_ST",f.RegisterEvent r(f,s.."ART")r(f,s.."OP")f:SetScript("OnEvent",function()this.c=event~=s.."OP"end)CnlSpam=f end if not f.c then CastSpellByName("Mind Flay")end -- with default ui
--
--
--
--[[
GetNumQuestChoices()


-- /run SelectGossipActiveQuest(2) CompleteQuest() GetQuestReward(2)

/script SelectGossipAvailableQuest(1)
/script SelectGossipActiveQuest(1)
/script CompleteQuest()
/script SelectGossipOption(1)
/script AcceptQuest()
/script GetQuestReward(1)
]]
