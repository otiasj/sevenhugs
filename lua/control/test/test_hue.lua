local common = require 'common'
local http = require 'http'
local cc = require 'control.hue'

params = {
    address = '192.168.0.50',
    user = '3f47622e1590232731bd71422dc46d4b',
    light = 1,
}
commands = {
    set = 2,
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
