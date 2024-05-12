setfenv(1, melba_macros.env)

function melba_macros.de_dme()
    local items = {"Merciful Greaves", "Fiendish Machete", "Wintersprout Boots", "Energized Chestplate", "Ring of Demonic Guile"}
    for idx, item in ipairs(items) do
        local bag, slot = FindItemInBags(item)
        if bag == nil then return end
        if slot == nil then return end
        --CastSpellByName("disenchant")
        PickupContainerItem(bag,slot)
        break
    end
end


