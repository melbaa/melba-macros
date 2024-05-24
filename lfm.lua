local copyTable = melba_macros.env.copyTable


-- date [format, unixts] - https://www.lua.org/manual/5.1/manual.html#pdf-os.date
-- time [datetable] - unix time
-- GetTime() - system uptime in seconds
-- GetGameTime()
--[[
%a	abbreviated weekday name (e.g., Wed)
%A	full weekday name (e.g., Wednesday)
%b	abbreviated month name (e.g., Sep)
%B	full month name (e.g., September)
%c	date and time (e.g., 09/16/98 23:48:10)
%d	day of the month (16) [01-31]
%H	hour, using a 24-hour clock (23) [00-23]
%I	hour, using a 12-hour clock (11) [01-12]
%M	minute (48) [00-59]
%m	month (09) [01-12]
%p	either "am" or "pm" (pm)
%S	second (10) [00-61]
%w	weekday (3) [0-6 = Sunday-Saturday]
%x	date (e.g., 09/16/98)
%X	time (e.g., 23:48:10)
%Y	full year (1998)
%y	two-digit year (98) [00-99]
%%	the character `%´



os.time() - get current epoch value
os.time{ ... } - get epoch value for local date/time values
os.date("*t"),os.date("%format") - get your local date/time
os.date("!*t") or os.date("!%format") - get GMT date/time
os.date("*t", timestamp),os.date("%format", timestamp) - get your local date/time for given timestamp
os.date("!*t", timestamp) or os.date("!%format", timestamp) - get GMT date/time for given timestamp
]]
function melba_macros.lfm_mc(needtxt)

    local dt = date("!*t")
    local nowts = time(dt)
    -- sunday 1, monday 2, tuesday 3 wed 4 thurs 5 fri 6
    local goalday = 6

    local goaldiff = goalday - dt.wday
    local dayname = 'friday'
    if goaldiff == 1 then
        dayname = 'tomorrow'
    elseif goaldiff == 0 then
        dayname = 'today'
    end

    -- in how many hours?
    -- 18:30 ST
    local goaldt = copyTable(dt)
    goaldt.hour = 18
    --goaldt.min = 30
    goaldt.min = 00
    for i=0, 7 do
        --print(goaldt.day)
        local testingts = time(goaldt)
        local testingdt = date("*t", testingts)
        print(testingdt.day .. ' ' .. testingdt.month)
        print('wday ' .. testingdt.wday)
        if testingdt.wday == goalday then break end
        goaldt.day = goaldt.day + 1
    end
    local hours_remaining = (time(goaldt)-nowts) / 3600

    if hours_remaining <= 0 then
        print('nothing to do. negative hours_remaining ' .. hours_remaining)
        return
    end

    print('unrounded in hours' .. hours_remaining)
    -- hours_remaining = math.floor(hours_remaining+0.5)
    -- print('rounded in hours' .. hours_remaining)
    local minutes_remaining = math.floor(math.fmod(hours_remaining, 1) * 60)
    hours_remaining = math.floor(hours_remaining)

    local days_remaining = 0
    while hours_remaining >= 24 do
        days_remaining = days_remaining + 1
        hours_remaining = hours_remaining - 24
    end

    local days_remaining_fmt = ''
    if days_remaining > 0 then
        if days_remaining == 1 then
            days_remaining_fmt = ' ' .. days_remaining .. ' day'
        else
            days_remaining_fmt = ' ' .. days_remaining .. ' days'
        end
    end

    local hours_remaining_fmt = ''
    if hours_remaining > 0 then
        hours_remaining_fmt = ' ' .. hours_remaining .. ' hr'
    end

    local minutes_remaining_fmt = ''
    if minutes_remaining > 5 then
        minutes_remaining_fmt = ' ' .. tostring(minutes_remaining) .. ' mins'
    end

    local msg = 'LFM ' .. needtxt .. ' for MC ' .. dayname .. ' ' 
        .. string.format("%02d", goaldt.hour) .. ':' .. string.format("%02d", goaldt.min) .. ' UTC (in' .. days_remaining_fmt .. hours_remaining_fmt .. minutes_remaining_fmt .. ') 1sr>ms>os+1 || signups https://discord.gg/88uqpc7 || blue or better gear'
    -- LFM for MC in 1 hr. https://discord.gg/88uqpc7 | blue or better gear
    -- LFM for MC in 50min. https://discord.gg/88uqpc7 | blue or better gear
    -- LFM for MC now. in https://discord.gg/88uqpc7 | blue or better gear

    -- find world channel
    local chanid = nil
    for i=0,25 do
        local id, name = GetChannelName(i);
        if name and strlower(name) == 'world' then
            chanid = id
            break
        end
    end

    if chanid == nil then
        print('error: channel not found')
        return
    end
    print(msg .. ' chanid ' .. chanid)
    if IsShiftKeyDown() then return end -- press shift for test mode
    SendChatMessage(msg, "CHANNEL", nil, chanid)
end





