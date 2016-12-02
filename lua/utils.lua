local utils = {}

-- Dump a table in a human readable format, handle recursive tables, do not
-- output a terminating newline.
function utils.dump_nonl(tt, indent, done)
    local done = done or {}
    local indent = indent or ''
    if type(tt) == 'table' and not done[tt] then
        io.write('{\n')
        done[tt] = true
        local newindent = indent .. '  '
        local nextkey = 1
        for key, value in pairs(tt) do
            io.write(newindent)
            if key ~= nextkey then
                nextkey = nil
                io.write('[')
                utils.dump_nonl(key, newindent, done)
                io.write('] = ')
            else
                nextkey = nextkey + 1
            end
            utils.dump_nonl(value, newindent, done)
            io.write(',\n')
        end
        io.write(indent .. '}')
    elseif type(tt) == 'string' then
        io.write(string.format('%q', tt))
    else
        io.write(tostring(tt))
    end
end

-- Same as dump_nonl, but output a newline.
function utils.dump(tt)
    utils.dump_nonl(tt)
    io.write('\n')
end

-- Serialize a table so that it can be read back.  Do not handle recursive
-- tables.
function utils.serialize(tt)
    if type(tt) == 'table' then
        local ret = {'{'}
        local nextkey = 1
        for key, value in pairs(tt) do
            if key ~= nextkey then
                nextkey = nil
                table.insert(ret, '[')
                table.insert(ret, utils.serialize(key))
                table.insert(ret, ']=')
            else
                nextkey = nextkey + 1
            end
            table.insert(ret, utils.serialize(value))
            table.insert(ret, ',')
        end
        table.insert(ret, '}')
        return table.concat(ret, '')
    elseif type(tt) == 'string' then
        return string.format('%q', tt)
    else
        return tostring(tt)
    end
end

return utils
