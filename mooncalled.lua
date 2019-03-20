--Copyright (c) 2018, Vanyar
--All rights reserved.

--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:

--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of <addon name> nor the
--      names of its contributors may be used to endorse or promote products
--      derived from this software without specific prior written permission.

--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

_addon.author = 'Vanyar'
_addon.name = 'MoonCalled'
_addon.version = '0.1'
_addon.commands = {'mooncalled', 'moony'}

config = require('config')
texts = require('texts')
packets = require('packets')
res = require('resources')

defaults = {}
defaults.pos = {}
defaults.pos.x = 20
defaults.pos.y = 400
defaults.text = {}
defaults.text.font = 'Consolas'
defaults.text.size = 12

settings = config.load(defaults)
uiBox = texts.new(settings)
local enabled = true
local debugMode = false
local endrain = T{'First Quarter Moon','Waxing Gibbous','Full Moon','Waning Gibbous'}
local enaspir = T{'Last Quarter Moon','Waning Crescent','New Moon','Waxing Crescent'}

windower.register_event('addon command',function (...)
    cmd = {...}
    if cmd[1] ~= nil then
        if cmd[1]:lower() == "help" then
            print('MoonCalled is a little helper for Fenrirs "Heavenward Howl"')
						print('You can either use //mooncalled or //moony')
            print('To show or hide MoonCalled you can do either of the following:')
            print('Show helper: //moony on  or  //moony show')
						print('Hide helper: //moony off  or  //moony hide')
						print('Toggle Helper //moony toggle')
						print('~Moony, Wormtail, Padfoot and Prong')
        end

        if cmd[1]:lower() == "on" or cmd[1]:lower() == "show" then
            enabled = true
            print('MoonCalled Enabled')
        end

        if cmd[1]:lower() == "off" or cmd[1]:lower() == "hide" then
            enabled = false
            print('MoonCalled Disabled')
        end

        if cmd[1]:lower() == "toggle" then
          if enabled == false then
            enabled = true
            print('MoonCalled Enabled')
          else
            enabled = false
          	print('MoonCalled Disabled')
          end
        end

				if cmd[1]:lower() == "debug" then
					if debugMode == false then
						debugMode = true
						print('MoonCalled Debug Enabled')
					else
						debugMode = false
						print('MoonCalled Debug Disabled')
					end
				end
    end
end)

windower.register_event('prerender', function()
	local player = windower.ffxi.get_player()
	local ffInfo = windower.ffxi.get_info()
	local moonPhase = res.moon_phases[ffInfo.moon_phase].en
	local moonPct = ffInfo.moon
	if player and enabled == true then
		if S{player.main_job, player.sub_job}:contains('SMN') then
			msg = ''
			if debugMode == true then
				local zone = res.zones[ffInfo.zone].en
        local day = res.days[ffInfo.day].en
        local weather = res.weather[ffInfo.weather].en

				msg = msg ..'============================\n'
				msg = msg ..'=== Debug Mode\n'
				msg = msg ..'============================\n\n'
				msg = msg ..'Zone: '..zone..'\n'
				msg = msg ..'Day: '..day..'\n'
				msg = msg ..'Weather: '..weather..'\n'
				msg = msg ..'System Time: '..os.time()..'\n'
				if moonPct <= 50 then
					msg = msg ..'Value based on %: Enaspir\n'
				elseif moonPct >= 51 then
					msg = msg ..'Value based on %: Endrain\n'
				end
				for i,effect in pairs(endrain) do
			    if S{moonPhase}:contains(effect) then
						msg = msg ..'Value based on Phase: Endrain\n'
					end
				end
				for i,effect in pairs(enaspir) do
			    if S{moonPhase}:contains(effect) then
						msg = msg ..'Value based on Phase: Enaspir\n'
					end
				end
				msg = msg ..'\n'
				msg = msg ..'============================\n\n\n'
			end
			msg = msg .. '~~ '..moonPhase..' ('..moonPct..'%) ~~\n'
			if moonPhase == 'New Moon' then
				msg = msg ..'Heavenward Howl: Enaspir (5%)\n'
				msg = msg ..'Ecliptic   Howl: Accuracy+ 1 || Evasion+ 25 \n'
			elseif moonPhase == 'Waxing Crescent' then
				msg = msg ..'Heavenward Howl: Enaspir (4% - 2%) \n'
				msg = msg ..'Ecliptic   Howl: Accuracy+ 5-9 || Evasion+ 21-17 \n'
			elseif moonPhase == 'First Quarter Moon' then
				msg = msg ..'Heavenward Howl: Endrain (5%)\n'
				msg = msg ..'Ecliptic   Howl: Accuracy+ 13 || Evasion+ 13 \n'
			elseif moonPhase == 'Waxing Gibbous' then
				msg = msg ..'Heavenward Howl: Endrain (8% - 12%)\n'
				msg = msg ..'Ecliptic   Howl: Accuracy+ 17-21 || Evasion+ 9-5 \n'
			elseif moonPhase == 'Full Moon' then
				msg = msg ..'Heavenward Howl: Endrain (15%)\n'
				msg = msg ..'Ecliptic   Howl: Accuracy+ 25 || Evasion+ 1 \n'
			elseif moonPhase == 'Waning Gibbous' then
				msg = msg ..'Heavenward Howl: Endrain (12% - 8%)\n'
				msg = msg ..'Ecliptic   Howl: Accuracy+ 21-17 || Evasion+ 5-9 \n'
			elseif moonPhase == 'Last Quarter Moon' then
				msg = msg ..'Heavenward Howl: Enaspir (1%)\n'
				msg = msg ..'Ecliptic   Howl: Accuracy+ 13 || Evasion+ 13 \n'
			elseif moonPhase == 'Waning Crescent' then
				msg = msg ..'Heavenward Howl: Enaspir (2% - 4%)\n'
				msg = msg ..'Ecliptic   Howl: Accuracy+ 9-5 || Evasion+ 17-21 \n'
			end
			uiBox:text(msg)
			uiBox:visible(true)
		else
			uiBox:text('')
			uiBox:hide()
		end
	else
		uiBox:hide()
	end
end)
