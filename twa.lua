function melba_macros.twa_get_assigned()
    -- assigned if in a twa cell
    local assigned = {}

    for i, row in TWA.data do
        for j, cell in row do
            assigned[cell] = 1
        end
    end
    return assigned
end

function melba_macros.filter_offline(candidates, online)
    local online2 = {}
    for k, v in pairs(candidates) do
        local name = k
        if type(k) == 'number' then name = v end

        if online[name] then
            if type(k) == 'number' then 
                table.insert(online2, name)
            else
                online2[name] = 1
            end
        end
    end
    return online2
end

function melba_macros.get_raid_online()
    local online = {}
    for i = 1, GetNumRaidMembers() do
        if (GetRaidRosterInfo(i)) then
            local n, _, _, _, _, _, z = GetRaidRosterInfo(i);
            if z ~= 'Offline' then
                online[n] = 1
            end
        end
    end
    return online
end



function melba_macros.twa_assign_column(columnidx, candidates, checkoffline)

    for rowidx = 1, table.getn(TWA.data) do
        if TWA.data[rowidx][columnidx] == '-' then
            local assigned = melba_macros.twa_get_assigned()

            if checkoffline then
                local online = melba_macros.get_raid_online()
                assigned = melba_macros.filter_offline(assigned, online)
                candidates = melba_macros.filter_offline(candidates, online)
            end

            for _, candidate in candidates do
                if not assigned[candidate]
                then
                    TWA.data[rowidx][columnidx] = candidate
                    break
                end
            end
        end
    end
end

function melba_macros.twa_trash(checkoffline)

    --[[
    TWA.raid = {
        ['warrior'] = { 'warr1', 'warr2', 'warr3', 'warr4' },
        ['paladin'] = { 'pala1', 'pala2', 'pala3', 'pala4', },
        ['druid'] = { 'druid1', 'druid2', 'druid3', 'druid4' },
        ['warlock'] = { 'wl1', 'wl2', 'wl3' },
        ['mage'] = { 'mage1', 'mage2', 'mage3' },
        ['priest'] = { 'priest1', 'priest2', 'priest3', 'priest4', 'priest5', 'priest6', 'priest7' },
        ['rogue'] = { 'rogue1', 'rogue2', 'rogue3' },
        ['shaman'] = { 'sham1', 'sham2', 'sham3', 'sham4' },
        ['hunter'] = { 'hunt1', 'hunt2', 'hunt3' },
    }
    ]]

    local marks = {'Skull', 'Cross', 'Circle', 'Diamond', 'Triangle', 'Star'}
    local tanks = {'tank1', 'tank2', 'tank3', 'tank4', 'tank5', 'tank6'}
    local healers = {'healer1', 'healer2', 'healer3', 'healer4', 'healer5', 'healer6', 'healer7', 'healer8', 'healer9', 'healer10', 'healer11', 'healer12'}

    melba_macros.twa_assign_column(1, marks)
    melba_macros.twa_assign_column(2, tanks, checkoffline)
    melba_macros.twa_assign_column(5, healers, checkoffline)
    melba_macros.twa_assign_column(6, healers, checkoffline)

    TWA.PopulateTWA()

    --TWA.data[i] = d
    --  [1] = { "Skull", "-", "-", "-", "-", "-", "-" },
end
-- twa assignments section end


