-- Sonos control.
local control = require 'sevenhugs.remote.control'
local sonos = control.class()

sonos.description = {
    capability = 'speaker',
}

local http = require 'http'

function sonos:close()
    if self.req then
        self.req:close()
    end
end

local function request(address, control_url, service_type, action, params, done, fail)
    local url = string.format('http://%s:1400%s', address, control_url)
    local data_params = {}
    for key, value in pairs(params) do
        table.insert(data_params, string.format('<%s>%s</%s>', key,
            tostring(value), key))
    end
    local data = string.format('<?xml version="1.0"?>\
    <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"\
        s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">\
        <s:Body>\
            <u:%s xmlns:u="urn:schemas-upnp-org:service:%s:1">\
                %s\
            </u:%s>\
        </s:Body>\
    </s:Envelope>', action, service_type,
        table.concat(data_params, '\n                '), action)
    return http.post{
        url = url,
        data = data,
        headers = {
            ['Content-type'] = 'text/xml; charset="utf-8"',
            ['SOAPACTION'] = string.format('"urn:schemas-upnp-org:service:%s:1#%s"',
                service_type, action),
        },
        done = done,
        fail = fail,
    }
end

local function query_volume(self, ui, state)
    self.req = request(self.params.address,
        '/MediaRenderer/RenderingControl/Control', 'RenderingControl',
        'GetVolume',
        { InstanceID = 0, Channel = 'Master' },
        function(result)
            volume = result.content:match('<CurrentVolume>(%d+)<')
            if volume then
                ui:state(state, volume / 100)
            else
                ui:error('can not parse volume')
            end
        end,
        function(err, result)
            ui:error(err)
        end
    )
end

function sonos:query(ui)
    self.req = request(self.params.address,
        '/MediaRenderer/AVTransport/Control', 'AVTransport',
        'GetTransportInfo',
        { InstanceID = 0 },
        function(result)
            playing = result.content:match('<CurrentTransportState>([%a_]+)<')
            if playing then
                query_volume(self, ui, playing == 'PLAYING'
                    or playing == 'TRANSITIONING')
            else
                ui:error('can not parse playing state')
            end
        end,
        function(err, result)
            ui:error(err)
        end
    )
end

function sonos:set_state(ui, state)
    local action = state and 'Play' or 'Pause'
    self.req = request(self.params.address,
        '/MediaRenderer/AVTransport/Control', 'AVTransport', action,
        { InstanceID = 0, Speed = 1 },
        function(result)
            query_volume(self, ui, state)
        end,
        function(err, result)
            ui:error(err)
        end
    )
end

function sonos:set_volume(ui, volume)
    self.req = request(self.params.address,
        '/MediaRenderer/RenderingControl/Control', 'RenderingControl',
        'SetVolume',
        { InstanceID = 0, Channel = 'Master',
            DesiredVolume = math.floor(volume * 100) },
        function(result)
            self:query(ui)
        end,
        function(err, result)
            ui:error(err)
        end
    )
end

function sonos:command(ui, command)
    local action = command == 'next' and 'Next' or 'Previous'
    self.req = request(self.params.address,
        '/MediaRenderer/AVTransport/Control', 'AVTransport', action,
        { InstanceID = 0, Speed = 1 },
        function(result)
            self:query(ui)
        end,
        function(err, result)
            ui:error(err)
        end
    )
end

return sonos
