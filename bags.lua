setfenv(1, melba_macros.env)

function FindItemInBags(itemName)
    for bag=-2, 11 do
        local bagsize = GetContainerNumSlots(bag)
        for slot=1, bagsize do
            local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag, slot)
            local link = GetContainerItemLink(bag, slot)
            if link then
                if string.find(link, itemName) then
                    return bag, slot
                end
            end
        end
    end
    return nil, nil
end

