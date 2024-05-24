local say = melba_macros.env.say
local display = melba_macros.env.display
local print = melba_macros.env.print
local GetSpellCooldownByName = melba_macros.env.GetSpellCooldownByName



local function mortal_strike_talented()
    local nameTalent, icon, tier, column, currRank, maxRank= GetTalentInfo(unpack(melba_macros.TALENT_MS))
    return currRank == 1
end

local function bloodthirst_talented()
    local nameTalent, icon, tier, column, currRank, maxRank= GetTalentInfo(unpack(melba_macros.TALENT_BT))
    return currRank == 1
end


local function is_mh_1h()
    local slotId = 16 -- aka GetInventorySlotInfo("MainHandSlot")
    local _,_,itemId = string.find(GetInventoryItemLink("player", slotId) or "","item:(%d+)")
    local _, _, _, _, _, _, _, equipSlot, _ = GetItemInfo(itemId or "")
    -- print(equipSlot)
    return equipSlot == 'INVTYPE_WEAPON'
end

function melba_macros.target_executable()
    if not UnitExists("target") then return end
    if not UnitAffectingCombat("target") then return end
    if not UnitCanAttack("player", "target") then return end
    local healthAmount = UnitHealth("target")
    local healthPercentage = 100 * healthAmount / UnitHealthMax("target")
    -- to allow some time to apply debuffs and use cooldowns before executes
    return healthPercentage <= 20
end

function melba_macros.sunderarmor()
    Roids.DoCast("!Attack");
    Roids.DoCast("[stance:3 nomybuff:Battle Shout] Battle Shout");
    Roids.DoCast("Sunder Armor");
    if is_mh_1h() then Roids.DoCast("[mypower>50] Heroic Strike") end
end




function melba_macros.use_deathwish()
    Roids.DoCast("Death Wish")
    Roids.DoCast("[mydebuff:Death_Wish] Berserking")
    -- what do here? maybe GetZoneText() == "Naxxramas"
    -- Roids.DoUse("[mydebuff:Death_Wish] Juju Flurry")
end

function melba_macros.target_nearest_enemy()
    if GetUnitName("target")==nil or UnitIsDead("target") then TargetNearestEnemy() end
end


local function cast_primary_dps_ability()
    if bloodthirst_talented() then
        Roids.DoCast("[nocooldown:Bloodthirst] Bloodthirst")
    elseif mortal_strike_talented() then
        Roids.DoCast("[nocooldown:Mortal_Strike] Mortal Strike")
    else
        Roids.DoCast("Shield Slam")
    end

    -- zerk after BT in case rage is not enough
    Roids.DoCast("[myhp<60] berserking")
end

local global_cooldown = 1.5
local input_lag = 0.1
local cleavepowerreq = 20
local wwpowerreq = 25
local btpowerreq = 30
local hspowerreq = 15
local revengepowerreq = 5
local sbpowerreq = 10
function melba_macros.dps_rotation()
    --[[
    the rotation is relatively complex and depends on what you're doing and how much rage you have
    there's a dps rotation
    there's a tank (threat) rotation

    the basic dps prio is bt > ww > hs/cleave > hamstring
    the basic tank threat prio is bt/hs then revenge/hs then sunder/hs
    with 2h, you don't wanna hs

    unbuffed rage gain with 2h 14 rage
    unbuffed rage gain with crit 2h 26 rage
    unbuffed cost of cleave 20 + ((14+26)/2) = 20 + 20 = 40 ?????
    execute + normal attack = 600dmg for 15 rage.
    bt + normal attack = 750 dmg for 15 rage
    cleave on 2 targets = ~700 dmg for 40-50 rage ???? wtf? cleave when on full rage only?

    with daggers, you prolly don't wanna ww/cleave
    --]]
    Roids.DoCast("!Attack");

    local stance = Roids.GetCurrentShapeshiftIndex()
    if stance == 2 then
        -- def stance, we tanking
        cast_primary_dps_ability()
        Roids.DoCast("Revenge")
        if is_mh_1h() then Roids.DoCast("Heroic Strike") end
        --[[
        random sunders cause issues at razuv
        can waste gcds
        Roids.DoCast("[mypower>75] Sunder Armor")
        --]]
    elseif stance == 3 or stance == 1 then
        -- is target worth executing? eg <20 rage and mob hp > 800
        if melba_macros.target_executable() then
            Roids.DoCast("Execute")
        else
            cast_primary_dps_ability()
            Roids.DoCast("[stance:1] Overpower")
        end

        if stance == 1 and GetZoneText() ~= "Blood Ring" then
            say('why are you in battle stance????')
        end
    end

    -- rage dumps ignoring rotation
    Roids.DoCast("[stance:3 nomybuff:Battle Shout] Battle Shout"); -- battle shout uptime too important
    if is_mh_1h() then Roids.DoCast("[stance:3 mypower>30] Heroic Strike") end
    Roids.DoCast("[stance:3 mypower>45] Whirlwind");

    Roids.DoCast("[nomybuff:Battle Shout] Battle Shout");

    local now = GetTime()

    if bloodthirst_talented() then
        local btstart, btdur = GetSpellCooldownByName("Bloodthirst")
        btremain = (btstart + btdur) - now

        -- we won't do anything before a bt
        if btremain <= global_cooldown + input_lag then return end
    end

    if mortal_strike_talented() then
        local msstart, msdur = GetSpellCooldownByName("Mortal Strike")
        msremain = (msstart + msdur) - now

        -- say(msremain)
        -- we won't do anything before a ms
        if msremain <= global_cooldown + input_lag then return end

    end


    local wwstart, wwdur = GetSpellCooldownByName("Whirlwind")
    local wwremain = (wwstart + wwdur) - now

    -- we'll allow a hamstring if ww on cd
    if wwremain > global_cooldown + input_lag then
        if is_mh_1h() then
            Roids.DoCast("[stance:3 nomybuff:Flurry mypower>55] hamstring")
        else
            -- nothing else to do as 2h, hms is a rage dump
            Roids.DoCast("[stance:3 mypower>55] hamstring")
        end
    end

    if is_mh_1h() then Roids.DoCast("[mypower>45] Heroic Strike") end
end

function melba_macros.dps_rotation_single_target_pool_rage()
    Roids.DoCast("!Attack");

    Roids.DoCast("[nomybuff:Battle Shout] Battle Shout");

    local now = GetTime()
    local mypower = 100 / UnitManaMax("player") * UnitMana("player");

    -- we save rage for a whirlwind for next pack
    local btcast = '[mypower>' .. (btpowerreq + wwpowerreq) .. '] Bloodthirst'
    Roids.DoCast(btcast)

    -- we'll rage dump with a ww, because we have another ww
    local wwcast = '[mypower>' .. (wwpowerreq + wwpowerreq) .. '] Whirlwind'
    Roids.DoCast(wwcast)


    if is_mh_1h() then
        -- we save rage for bt + ww because it can queue together with them losing too much rage
        local hscast = '[mypower>' .. (btpowerreq + wwpowerreq + hspowerreq) .. '] Heroic Strike'
        Roids.DoCast(hscast)
    else
        local wwstart, wwdur = GetSpellCooldownByName("Whirlwind")
        local wwremain = (wwstart + wwdur) - now
        if wwremain > global_cooldown + input_lag then
            -- nothing else to do as 2h, hms is a rage dump
            Roids.DoCast("[stance:3 mypower>55] hamstring")
        end
    end
end



function melba_macros.cleave_rotation()
    -- dw cleave vs 2 mobs. use 2h wep vs 3+ mobs
    Roids.DoCast("!Attack");

    local mypower = 100 / UnitManaMax("player") * UnitMana("player");
    local stance = Roids.GetCurrentShapeshiftIndex()
    local now = GetTime()
    local wwstart, wwdur = GetSpellCooldownByName("Whirlwind")
    local wwremain = (wwstart + wwdur) - now

    if stance == 3 and wwremain <= 0 and not is_mh_1h() and mypower < wwpowerreq
    then
        display("rage pot??")

        --[[
        -- loses lip/cs combo on trash too often
            Roids.DoUse("Great Rage Potion")
            -- GetZoneText()
        ]]
    end

    Roids.DoCast("[stance:3] Whirlwind")

    if stance == 3 and wwremain <= global_cooldown + input_lag
    and mypower < (btpowerreq+wwpowerreq)
    then return end
    -- don't wanna wait to 100 rage for a cleave because it loses wf procs. let's try 80
    -- 80 is still too much, still losing rage by going over 100. let's try 60
    -- 60 still too much? try 30
    -- local cleavecast = '[mypower>' .. (btpowerreq + btpowerreq) .. '] Cleave'
    local cleavecast = '[mypower>' .. (btpowerreq) .. '] Cleave'
    Roids.DoCast(cleavecast)
    --Roids.DoCast("bloodthirst")

    Roids.DoCast("[nomybuff:Battle Shout] Battle Shout");
    Roids.DoCast("[stance:3 nomybuff:Flurry mypower>70] hamstring")
end


function melba_macros.fullmit_rotation()
    -- prio shield block and revenge, then bt/hs
    -- hs remains in the dps rotation only as a threat dump, because it's too hard to 1 button queue it correctly
    -- main problem is a hsq runs with delay so it's hard to compute the power we have
    Roids.DoCast("!Attack");
    Roids.DoCast("Shield Block")
    Roids.DoCast("Revenge");
    cast_primary_dps_ability()

    local now = GetTime()
    local sbstart, sbdur = GetSpellCooldownByName("Shield Block")
    local sbremain = (sbstart + sbdur) - now
    --local btstart, btdur = GetSpellCooldownByName("Bloodthirst")
    --local btremain = (btstart + btdur) - now

    -- we wont do anything before shield block
    if sbremain <= global_cooldown + input_lag then return end

    local mypower = 100 / UnitManaMax("player") * UnitMana("player");
    --print(mypower)

    -- we save rage for shield block
    local btcast = '[mypower>' .. (btpowerreq + sbpowerreq + revengepowerreq) .. '] Bloodthirst'
    local hscast = '[mypower>' .. (btpowerreq + sbpowerreq + revengepowerreq + hspowerreq) .. '] Heroic Strike'

    Roids.DoCast(btcast)
    Roids.DoCast(hscast)
end


