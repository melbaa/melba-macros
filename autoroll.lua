setfenv(1, melba_macros.env)

local AUTO_PASS_NAMES = {
    ["Yellow Qiraji Resonating Crystal"]=true,
    ["Blue Qiraji Resonating Crystal"]=true,
    ["Green Qiraji Resonating Crystal"]=true,
    ["Red Qiraji Resonating Crystal"]=true,
    ["Skin of Shadow"]=true,
    ['Aquamarine']=true,
    ['Wicked Claw']=true,
    ['Deeprock Salt']=true,
    ['Core of Earth']=true,
    ['Coal']=true,
    ['Solid Stone']=true,
    ['Frayed Abomination Stitching']=true,
    ['Scroll of Spirit IV']=true,
    ['Ghoul Skin Tunic']=true,
    ['Harbinger of Doom']=true,
    ['Ring of the Eternal Flame']=true,
    ['Stygian Buckler']=true,
    ["Necro-Knight's Garb"]=true,
    ["Dense Stone"]=true,
    ["Essence Gatherer"]=true,
}

local AUTO_NEED_NAMES = {
    ["Traveler's Backpack"]=true,
    ['Runecloth']=true,
    ['Essence of Earth']=true,
    ['Evil Bat Eye']=true,
    -- ['Major Mana Potion']=true,
    ['Major Healing Potion']=true,
    ['Roasted Quail']=true,
    ['Morning Glory Dew']=true,
    ['Essence of Fire']=true,
    ['Scroll of Protection IV']=true,
    ['Scroll of Stamina IV']=true,
    ['Scroll of Strength IV']=true,
    ['Plans: Radiant Leggings']=true,
    ['Eternium Lockbox']=true,
    ['Essence of Undeath']=true,
    ['Huge Venom Sac']=true,
    ['Small Dream Shard']=true,
    ['Arcane Essence']=true,
    ['Witherbark Coin']=true,
    ['Skullsplitter Coin']=true,
    ['Vilebranch Coin']=true,
    ['Bloodscalp Coin']=true,
    ['Gurubashi Coin']=true,
    ['Sandfury Coin']=true,
    ['Hakkari Coin']=true,
    ['Zulian Coin']=true,
    ['Razzashi Coin']=true,
    ['Purple Hakkari Bijou']=true,
    ['Gold Hakkari Bijou']=true,
    ['Silver Hakkari Bijou']=true,
    ['Blue Hakkari Bijou']=true,
    ['Green Hakkari Bijou']=true,
    ['Bronze Hakkari Bijou']=true,
    ['Yellow Hakkari Bijou']=true,
    ['Orange Hakkari Bijou']=true,
    ['Red Hakkari Bijou']=true,
    ['Bloodvine']=true,
}

local AUTO_GREED_NAMES = {
    ['Star Ruby']=true,
}
function auto_roll(id)
    local _, name, _, quality, bop = GetLootRollItemInfo(id);

    if AUTO_PASS_NAMES[name]
    then
        RollOnLoot(id, 0);
        local _, _, _, hex = GetItemQualityColor(quality)
        say("Auto PASS "..hex..GetLootRollItemLink(id))
        return
    end
    if bop then
        say("ignoring bind on pickup roll")
        return
    end

    if AUTO_NEED_NAMES[name]
    then
        RollOnLoot(id, 1);
        local _, _, _, hex = GetItemQualityColor(quality)
        say("Auto NEED "..hex..GetLootRollItemLink(id))
        return
    end

    if AUTO_GREED_NAMES[name]
    then
        RollOnLoot(id, 2);
        local _, _, _, hex = GetItemQualityColor(quality)
        say("Auto GREED "..hex..GetLootRollItemLink(id))
        return
    end
end
