setfenv(1, melba_macros.env)

function strToArray(s)
    s = string.lower(s.." ")
    result = {};
    for match in string.gfind(s, '([^ ]+)') do
         table.insert(result, match)
    end
    return result
end

