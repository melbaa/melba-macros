
local outfit2mh = {
    -- on pw we use widow's remorse for the extra stam, armor
    -- miti_pw = "Widow's Remorse",
    dps = 'The Castigator',
    dps_dme = 'The Castigator',
}
function melba_macros.equip_mh()

    -- local name, outfit = Outfitter_GetCurrentOutfitInfo()
    -- mainhand = outfit2mh[name] or mainhand

    -- local outfit = Outfitter_GetInventoryOutfit()
    -- local mainhand = "Widow's Remorse"

    local mainhand = nil
    if melba_macros.is_tanking() then
        mainhand = 'Thunderfury, Blessed Blade of the Windseeker'
    else
        mainhand = 'The Hungering Cold'
    end
    Roids.DoUse(mainhand)
end

function melba_macros.equip_oh()
    local offhand = nil
    if melba_macros.is_tanking() then
        offhand = "The Hungering Cold"
    else
        offhand = "Iblis, Blade of the Fallen Seraph"
    end
    Roids.DoEquipOffhand(offhand)
end

function melba_macros.is_tanking()
    if VCB_SAVE["MISC_disable_BB"] then
        return false
    else
        return true
    end
end


function melba_macros.equip_shield()
    -- local shield = 'The Plague Bearer'
    -- local shield = 'Blessed Qiraji Bulwark'
    local shield = 'The Face of Death'
    if not Roids.HasWeaponEquipped('Shields') then
        Roids.DoUse(shield)
    end
end




