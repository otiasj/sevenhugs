package.path = './sim/?.lua;'..package.path
local http = require 'http'

local function done(result)
    print('Success!')
end

local function fail(err, result)
    print('error: ' .. err)
end

r = http.get{
    url = 'http://remote.sevenhugs.com/',
    done = done, fail = fail,
}
http.run()
