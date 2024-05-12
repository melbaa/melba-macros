setfenv(1, melba_macros.env)

global.star_mark = 1
global.circle_mark = 2
global.diamond_mark = 3
global.triangle_mark = 4
global.moon_mark = 5
global.square_mark = 6
global.cross_mark = 7
global.skull_mark = 8


local mark_names = {"Star/Yellow","Circle/Orange","Diamond/Purple","Triangle/Green","Moon","Square/Blue","Cross","Skull"}
function melba_macros.shackle_announce(which_mark)
    local ti = which_mark or GetRaidTargetIndex("target");
    local msg = 'shackle'
    if ti then
        msg = msg .. ' -- ' .. mark_names[ti]
    end
    msg = msg .. ' -- ' .. UnitName("target")
    SendChatMessage(msg,"SAY",nil);
end

mark2idx = {
    star = global.star_mark,
    yellow = global.star_mark,
    circle = global.circle_mark,
    orange = global.circle_mark,
    diamond = global.diamond_mark,
    purple = global.diamond_mark,
    triangle = global.triangle_mark,
    green = global.triangle_mark,
    moon = global.moon_mark,
    square = global.square_mark,
    blue = global.square_mark,
    cross = global.cross_mark,
    skull = global.skull_mark,
}

local current_mark = global.skull_mark

function melba_macros.apply_mark()
    SetRaidTarget("target", current_mark)
    display('marked with ' .. mark_names[current_mark])
end

global.SLASH_SETMARK1 = '/setmark'
function global.SlashCmdList.SETMARK(message)

    local commandlist = { }
    local command

    for command in gfind(message, "[^ ]+") do
        table.insert(commandlist, command)
    end

    if not commandlist[1] then
        display('current mark ' .. mark_names[current_mark])
        return
    end


    commandlist[1] = string.lower(commandlist[1])
    print(commandlist[1])

    local mark = commandlist[1]
    local markidx = mark2idx[mark]
    if markidx == nil then
        display('unknown mark ' .. message)
        return
    end
    current_mark = markidx
end


