package.path = '../../?.lua;../../sim/?.lua;../../../base/lua/?.lua;'
    .. package.path
local common = {}
local utils = require 'utils'

common.ui = {
    state = function(self, ...)
        print('state', utils.serialize({...}))
    end,
    error = function(self, err)
        print(err)
    end,
    current = {},
}

function common.argparse_help(table, commands, arg, ret)
    io.write('usage: ' .. arg[0] .. ' [--debug]')
    for k, v in pairs(table) do
        io.write(' [--' .. k .. ' VALUE]')
    end
    if commands then
        io.write('\n        ')
    end
    for k, v in pairs(commands) do
        io.write(' [--' .. k)
        for i = 1, v do
            io.write(' VALUE')
        end
        io.write(']')
    end
    io.write('\n')
    os.exit(ret)
end

function common.argparse(table, commands, arg)
    local i = 1
    local command, command_args
    while arg[i] do
        if arg[i] == '--help' then
            common.argparse_help(table, commands, arg, 0)
        elseif arg[i] == '--debug' then
            local http = require 'http'
            http.debug = 1
            i = i + 1
        else
            k = arg[i]:match('^--([_%a]+)$')
            if k and table[k] and arg[i+1] then
                table[k] = arg[i+1]
                i = i + 2
            elseif not command and k and commands[k]
                and arg[i+commands[k]] then
                command = k
                command_args = {}
                for j = 1, commands[k] do
                    ch, err = load('return ' .. arg[i+j])
                    if not ch then
                        print(err)
                        common.argparse_help(table, commands, arg, 1)
                    end
                    command_args[j] = ch()
                end
                i = i + 1 + commands[k]
            else
                common.argparse_help(table, commands, arg, 1)
            end
        end
    end
    return command, command_args
end

return common
