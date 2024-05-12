setfenv(1, melba_macros.env)
melba_macros:RegisterEvent("PARTY_INVITE_REQUEST")

function PARTY_INVITE_REQUEST_OnEvent(arg1)
    say(arg1)
    if is_friend(arg1) or is_guild_mate(arg1) then
        accept_group_invite();
    end
end


function accept_group_invite()
    AcceptGroup();
    StaticPopup_Hide("PARTY_INVITE");
    PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav");
    UIErrorsFrame:AddMessage("Group Auto Accept");
end


function is_friend(name)
    for i = 1, GetNumFriends() do
        if GetFriendInfo(i) == name then
            return true
        end
    end
    return nil
end


function is_guild_mate(name)
    if IsInGuild() then
        local ngm=GetNumGuildMembers()
        for i=1, ngm do
            n, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i);
            if strlower(n) == strlower(name) then
              return true
            end
        end
    end
    return nil
end


