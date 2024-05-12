_G = getfenv(0)
melba_macros = CreateFrame("Frame")

BINDING_HEADER_MELBA_MACROS_HEADER = "MELBA MACROS"

melba_macros.env = {
    global=_G,
    melba_macros=melba_macros,
}

setfenv(1, melba_macros.env)

table = global.table
string = global.string
math = global.math

gfind = string.gmatch or string.gfind
strlower = global.strlower
strfind = global.strfind
gsub = global.gsub
assert = global.assert
ipairs = global.ipairs
pairs = global.pairs
type = global.type
getmetatable = global.getmetatable
setmetatable = global.setmetatable
tonumber = global.tonumber
tostring = global.tostring
next = global.next

BOOKTYPE_SPELL = global.BOOKTYPE_SPELL

AcceptGroup = global.AcceptGroup
CastSpellByName = global.CastSpellByName
GetActionTexture = global.GetActionTexture
GetContainerItemCooldown = global.GetContainerItemCooldown
GetContainerItemInfo = global.GetContainerItemInfo
GetContainerItemLink = global.GetContainerItemLink
GetContainerNumSlots = global.GetContainerNumSlots
GetFriendInfo = global.GetFriendInfo
GetGuildRosterInfo = global.GetGuildRosterInfo
GetInventoryItemCooldown = global.GetInventoryItemCooldown
GetInventoryItemLink = global.GetInventoryItemLink
GetItemInfo = global.GetItemInfo
GetItemQualityColor = global.GetItemQualityColor
GetLootRollItemInfo = global.GetLootRollItemInfo
GetLootRollItemLink = global.GetLootRollItemLink
GetNumFriends = global.GetNumFriends
GetNumGuildMembers = global.GetNumGuildMembers
GetRaidTargetIndex = global.GetRaidTargetIndex
GetSpellCooldown = global.GetSpellCooldown
GetSpellName = global.GetSpellName
GetTime = global.GetTime
GetZoneText = global.GetZoneText
IsInGuild = global.IsInGuild
IsShiftKeyDown = global.IsShiftKeyDown
PickupContainerItem = global.PickupContainerItem
PlaySoundFile = global.PlaySoundFile
RollOnLoot = global.RollOnLoot
SendChatMessage = global.SendChatMessage
SetRaidTarget = global.SetRaidTarget
SpellStopCasting = global.SpellStopCasting
StaticPopup_Hide = global.StaticPopup_Hide
UIErrorsFrame = global.UIErrorsFrame
UnitAffectingCombat = global.UnitAffectingCombat
UnitName = global.UnitName
UseInventoryItem = global.UseInventoryItem
