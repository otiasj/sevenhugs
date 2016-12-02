-- Philips Hue control.
local control = require 'sevenhugs.remote.control'
local hue = control.class()

hue.description = {
    icon = 'hue',
    capability = 'light.dim',
}

local http = require 'http'

function hue:close()
    if self.req then
        self.req:close()
    end
end

function hue:query(ui)
    local url = string.format('http://%s/api/%s/lights/%d',
        self.params.address, self.params.user, self.params.light)
    self.req = http.get{
        url = url,
        result_max = 1024,
        done = function(result)
            local state = result.content:match('"on":%s*(%a+)')
            local bri = result.content:match('"bri":%s*(%d+)')
            if state then
                ui:state(state == 'true', (bri - 1) / 253)
            else
                ui:error('can not parse state')
            end
        end,
        fail = function(err, result)
            ui:error(err)
        end,
    }
end

function hue:set(ui, state, brightness)
    local url = string.format('http://%s/api/%s/lights/%d/state',
        self.params.address, self.params.user, self.params.light)
    local data
    if state then
        data = string.format('{"on":%s,"bri":%d}',
            state and 'true' or 'false', 1 + math.floor(brightness * 253))
    else
        data = string.format('{"on":%s}', state and 'true' or 'false')
    end
    self.req = http.put{
        url = url,
        data = data,
        result_max = 1024,
        done = function(result)
            local err = result.content:match('"error"')
            if not err then
                ui:state(state, brightness)
            else
                ui:error('can not set state')
            end
        end,
        fail = function(err, result)
            ui:error(err)
        end,
    }
end

return hue
