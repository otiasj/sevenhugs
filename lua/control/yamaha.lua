-- Yamaha control receiver.
--
--
-- Tested on Yamaha receiver RX-V473
-- you can query the capabilities of the receiver with :
-- get(self.params.address, '/desc.xml', '', done, fail)
--
-- ctrl commands (post request):
-- post(self.params.address, 'ctrl', cmd, done, fail)
--
-- some cmd samples (check the desc.xml file for more):
-- status = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Basic_Status>GetParam</Basic_Status></Main_Zone></YAMAHA_AV>'
-- powerOn = '<YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Power>On</Power></Power_Control></Main_Zone></YAMAHA_AV>'
-- volume = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>%s</Val><Exp>1</Exp><Unit>dB</Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>'
--
-- 


local control = require 'sevenhugs.remote.control'
local yamaha = control.class()

yamaha.description = {
    capability = 'speaker',
}

local http = require 'http'


function yamaha:init()
     
end


function yamaha:close()
    if self.req then
        self.req:close()
    end
end

local function get(ip, control, data, done, fail)
	local url = string.format('http://%s:80/YamahaRemoteControl%s', ip, control)
	return http.post{
	url = url,
	data = data,
	done = done,
	fail = fail,
	}
end

local function post(ip, control, data, done, fail)
	local url = string.format('http://%s:80/YamahaRemoteControl%s', ip, control)
	return http.post{
	url = url,
	data = data,
	done = done,
	fail = fail,
	}
end

local function parseResult(ui, content) 
	local power = content:match('<Power_Control><Power>([%a_]+)<')
	if power then
		print('power is:'..power)
	end

    	local currentVolume = content:match('<Volume><Lvl><Val>(-%d+)<')
	if (currentVolume) then
		print('volume is:'..currentVolume)
		ui:state(state, currentVolume / 100)
	end
	
	local selectedInput = content:match('<Input><Input_Sel>([%a_]+[%d+]+)<')
	if (selectedInput) then
		print('input is:'..selectedInput)
	end
end

function yamaha:query(ui)
	local status = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Basic_Status>GetParam</Basic_Status></Main_Zone></YAMAHA_AV>'

        self.req = post(self.params.address, '/ctrl', status,
	function(result)
		parseResult(ui, result.content)
	    --print(result) 
    	end,
	function(err, result)
           ui:error(err)
        end
	)
end

-- range should be retrieved from desc.xml <range>-805,165,5<range> values are min,max,increment? in decibels
-- the real range is -805 to 165 but this would be too anoying to test at max volume 
function yamaha:set_volume(ui, volume)
	local minVolumeDb=-90
	local maxVolumeDb=-20
	local range=math.abs(minVolumeDb) + math.abs(maxVolumeDb)
	local increment=5
	local volumeInDb=-33.0
	if volume == 0.0 then
		volumeInDb = minVolumeDb;
	else
		volumeInDb = (range * volume) - math.abs(minVolumeDb)
	end
	volumeInDb=-25.5

	-- unfortunately this API can not work as is, the yamaha receiver only accepct increments of volume changes
	-- we would need to send several request in response to the set_volume command
	local setVolumeCmd = string.format('<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>%s</Val><Exp>1</Exp><Unit>dB</Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>', volumeInDb)

        self.req = post(self.params.address, '/ctrl', setVolumeCmd,
	function(result)
	    --print(result)
	    parseResult(ui, result.content)
    	end,
	function(err, result)
           ui:error(err)
        end
	)
end

-- receivers dont really play anything unless they are in tuner mode, so this will turn on/off the receiver
function yamaha:set_state(ui, state)
print(command)
	local power = state and 'On' or 'Standby'
	local status = string.format('<YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Power>%s</Power></Power_Control></Main_Zone></YAMAHA_AV>', power)
	
        self.req = post(self.params.address, '/ctrl', status,
	function(result)
	    --print(result)
	    parseResult(ui, result.content)
    	end,
	function(err, result)
           ui:error(err)
        end
	)
	
end

--select the receiver input TUNER, PC, USB, NET RADIO, AV1-7, AUDIO1-4, HDMI1-4....
function yamaha:command(ui, command)
	print(command)
	local status = string.format('<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>%s</Input_Sel></Input></Main_Zone></YAMAHA_AV>', command)
	
        self.req = post(self.params.address, '/ctrl', status,
	function(result)
	    --print(result)
	    parseResult(ui, result.content)
    	end,
	function(err, result)
           ui:error(err)
        end
	)
end

-- status response is :
-- {
--  ["content"] = "<YAMAHA_AV rsp=\"GET\" RC=\"0\"><Main_Zone><Basic_Status><Power_Control><Power>On</Power><Sleep>Off</Sleep></Power_Control><Volume><Lvl><Val>-345</Val><Exp>1</Exp><Unit>dB</Unit></Lvl><Mute>Off</Mute></Volume><Input><Input_Sel>HDMI4</Input_Sel><Input_Sel_Item_Info><Param>HDMI4</Param><RW>RW</RW><Title>  HDMI4  </Title><Icon><On>/YamahaRemoteControl/Icons/icon004.png</On><Off></Off></Icon><Src_Name></Src_Name><Src_Number>1</Src_Number></Input_Sel_Item_Info></Input><Surround><Program_Sel><Current><Straight>Off</Straight><Enhancer>Off</Enhancer><Sound_Program>5ch Stereo</Sound_Program></Current></Program_Sel><_3D_Cinema_DSP>Off</_3D_Cinema_DSP></Surround><Sound_Video><Tone><Bass><Val>20</Val><Exp>1</Exp><Unit>dB</Unit></Bass><Treble><Val>0</Val><Exp>1</Exp><Unit>dB</Unit></Treble></Tone><Direct><Mode>Off</Mode></Direct><HDMI><Standby_Through_Info>Off</Standby_Through_Info><Output><OUT_1>On</OUT_1></Output></HDMI><Adaptive_DRC>Off</Adaptive_DRC></Sound_Video></Basic_Status></Main_Zone></YAMAHA_AV>",
--  ["status_code"] = 200,
--  ["headers"] = {
--    ["server"] = "AV_Receiver/3.1 (RX-V473)",
--    ["content-type"] = "text/xml; charset=\"utf-8\"",
--    ["content-length"] = "1004",
--  },
--}

--local function query_volume(self, ui, state)
--    self.req = request(self.params.address,
--        '/MediaRenderer/RenderingControl/Control', 'RenderingControl',
--        'GetVolume',
--        { InstanceID = 0, Channel = 'Master' },
--        function(result)
--            volume = result.content:match('<CurrentVolume>(%d+)<')
--            if volume then
--                ui:state(state, volume / 100)
--            else
--                ui:error('can not parse volume')
--            end
--        end,
--        function(err, result)
--            ui:error(err)
--        end
--    )
--end
--
--function yamaha:set_state(ui, state)
--    local action = state and 'Play' or 'Pause'
--    self.req = request(self.params.address,
--        '/MediaRenderer/AVTransport/Control', 'AVTransport', action,
--        { InstanceID = 0, Speed = 1 },
--        function(result)
--            query_volume(self, ui, state)
--        end,
--        function(err, result)
--            ui:error(err)
--        end
--    )
--end
--

return yamaha


