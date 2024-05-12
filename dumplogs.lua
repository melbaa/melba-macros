local say = melba_macros.env.say

function dumplogs()
	local class = string.lower(UnitClass("player"))
	TargetUnit('player')
	local spellname = nil
	if class == 'warrior' then
		spellname = 'taunt'
	elseif class == 'priest' then
		spellname = 'dispel magic'
		spellname = 'mind soothe'
		spellname = 'devouring plague'
	else
		say('unknown class')
		return
	end
	for i=1, 400 do
		CastSpellByName(spellname)
	end
end

SLASH_DL1="/dl";

SlashCmdList["DL"] = dumplogs


