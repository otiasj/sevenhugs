local common = require 'common'
local http = require 'http'
local cc = require 'control.sonos'

params = {
    address = '192.168.0.51',
}
commands = {
    set_state = 1,
    set_volume = 1,
    command = 1,
}
command, command_args = common.argparse(params, commands, arg)

c = cc(params)
http.run()
if command then
    c[command](c, common.ui, table.unpack(command_args))
    http.run()
end
c:query(common.ui)
http.run()
