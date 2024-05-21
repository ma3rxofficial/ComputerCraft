--[[
  You can download this version using following command:
  pastebin get cVV5qD0g chat
]]

-- спизжено фром май либрейс
function cPrint(string, y2, _term)
	if _term == nil then
		_term = term
	end

    local tX, tY = _term.getSize()
    local b = string.len(string) / 2
    local x = (tX / 2) - b
	local y = tY / 2
	
	if y2 then
	  y = y2
	end

        _term.setCursorPos(x, y)
        _term.write(string)
end

--HUY--
local function modRead(properties, char, _term)
	if _term == nil then
		_term = term
	end

	local w, h = _term.getSize()
	local defaults = {replaceChar = char, history = nil, visibleLength = nil, textLength = nil, 
		liveUpdates = nil, exitOnKey = nil}
	if not properties then properties = {} end
	for k, v in pairs(defaults) do if not properties[k] then properties[k] = v end end
	if properties.replaceChar then properties.replaceChar = properties.replaceChar:sub(1, 1) end
	if not properties.visibleLength then properties.visibleLength = w end

	local sx, sy = _term.getCursorPos()
	local line = ""
	local pos = 0
	local historyPos = nil

	local function redraw(repl)
		local scroll = 0
		if properties.visibleLength and sx + pos > properties.visibleLength + 1 then 
			scroll = (sx + pos) - (properties.visibleLength + 1)
		end

		_term.setCursorPos(sx, sy)
		local a = repl or properties.replaceChar
		if a then _term.write(string.rep(a, line:len() - scroll))
		else _term.write(line:sub(scroll + 1, -1)) end
		_term.setCursorPos(sx + pos - scroll, sy)
	end

	local function sendLiveUpdates(event, ...)
		if type(properties.liveUpdates) == "function" then
			local ox, oy = _term.getCursorPos()
			local a, data = properties.liveUpdates(line, event, ...)
			if a == true and data == nil then
				_term.setCursorBlink(false)
				return line
			elseif a == true and data ~= nil then
				_term.setCursorBlink(false)
				return data
			end
			_term.setCursorPos(ox, oy)
		end
	end

	_term.setCursorBlink(true)
	while true do
		local e, but, x, y, p4, p5 = os.pullEvent()

		if e == "char" then
			local s = false
			if properties.textLength and line:len() < properties.textLength then s = true
			elseif not properties.textLength then s = true end

			local canType = true
			if not properties.grantPrint and properties.refusePrint then
				local canTypeKeys = {}
				if type(properties.refusePrint) == "table" then
					for _, v in pairs(properties.refusePrint) do
						table.insert(canTypeKeys, tostring(v):sub(1, 1))
					end
				elseif type(properties.refusePrint) == "string" then
					for char in properties.refusePrint:gmatch(".") do
						table.insert(canTypeKeys, char)
					end
				end
				for _, v in pairs(canTypeKeys) do if but == v then canType = false end end
			elseif properties.grantPrint then
				canType = false
				local canTypeKeys = {}
				if type(properties.grantPrint) == "table" then
					for _, v in pairs(properties.grantPrint) do
						table.insert(canTypeKeys, tostring(v):sub(1, 1))
					end
				elseif type(properties.grantPrint) == "string" then
					for char in properties.grantPrint:gmatch(".") do
						table.insert(canTypeKeys, char)
					end
				end
				for _, v in pairs(canTypeKeys) do if but == v then canType = true end end
			end

			if s and canType then
				line = line:sub(1, pos) .. but .. line:sub(pos + 1, -1)
				pos = pos + 1
				redraw()
			end
		elseif e == "key" then
			if but == keys.enter then break
			elseif but == keys.left then if pos > 0 then pos = pos - 1 redraw() end
			elseif but == keys.right then if pos < line:len() then pos = pos + 1 redraw() end
			elseif (but == keys.up or but == keys.down) and properties.history then
				redraw(" ")
				if but == keys.up then
					if historyPos == nil and #properties.history > 0 then 
						historyPos = #properties.history
					elseif historyPos > 1 then 
						historyPos = historyPos - 1
					end
				elseif but == keys.down then
					if historyPos == #properties.history then historyPos = nil
					elseif historyPos ~= nil then historyPos = historyPos + 1 end
				end

				if properties.history and historyPos then
					line = properties.history[historyPos]
					pos = line:len()
				else
					line = ""
					pos = 0
				end

				redraw()
				local a = sendLiveUpdates("history")
				if a then return a end
			elseif but == keys.backspace and pos > 0 then
				redraw(" ")
				line = line:sub(1, pos - 1) .. line:sub(pos + 1, -1)
				pos = pos - 1
				redraw()
				local a = sendLiveUpdates("delete")
				if a then return a end
			elseif but == keys.home then
				pos = 0
				redraw()
			elseif but == keys.delete and pos < line:len() then
				redraw(" ")
				line = line:sub(1, pos) .. line:sub(pos + 2, -1)
				redraw()
				local a = sendLiveUpdates("delete")
				if a then return a end
			elseif but == keys["end"] then
				pos = line:len()
				redraw()
			elseif properties.exitOnKey then 
				if but == properties.exitOnKey or (properties.exitOnKey == "control" and 
						(but == 29 or but == 157)) then 
					_term.setCursorBlink(false)
					return nil
				end
			end
		end
		local a = sendLiveUpdates(e, but, x, y, p4, p5)
		if a then return a end
	end

	_term.setCursorBlink(false)
	if line ~= nil then line = line:gsub("^%s*(.-)%s*$", "%1") end
	return line
end



--Better version of inputs--
function centerRead(wid, begt, buttonColor, buttonTextColor, buttonTextInputColor, cancelEnabled, cancelColor, cancelTextColor, char, startChar, _term)
	if _term == nil then
		_term = term
	end
	local w, h = _term.getSize()
	local function liveUpdate(line, e, but, x, y, p4, p5)
		if _term.isColor() and e == "mouse_click" and x >= w/2 - wid/2 and x <= w/2 - wid/2 + 10 
				and y >= 13 and y <= 15 then
			return true, ""
		end
	end

	if not buttonColor then
		buttonColor = colors.gray
	end
	if not buttonTextColor then
		buttonTextColor = colors.white
	end
	if not buttonTextInputColor then
		buttonTextInputColor = colors.white
	end
	if not cancelColor then
		cancelColor = colors.red
	end
	if not cancelTextColor then
		cancelTextColor = colors.white
	end		

	if not begt then 
		begt = "" 
	end

	if not startChar then
		startChar = "> "
	end

	_term.setTextColor(buttonTextColor)
	_term.setBackgroundColor(buttonColor)

	for i = 8, 10 do
		_term.setCursorPos(w/2 - wid/2, i)
		_term.write(string.rep(" ", wid))
	end

	if _term.isColor() and cancelEnabled then
		_term.setBackgroundColor(cancelColor)
		_term.setTextColor(cancelTextColor)
		for i = 13, 15 do
			_term.setCursorPos(w/2 - wid/2 + 1, i)
			_term.write(string.rep(" ", 10))
		end
		_term.setCursorPos(w/2 - wid/2 + 2, 14)
		_term.write("> Cancel")
	end

	_term.setBackgroundColor(buttonColor)
	_term.setTextColor(buttonTextColor)
	_term.setCursorPos(w/2 - wid/2 + 1, 9)
	_term.write(startChar .. begt)
	_term.setTextColor(buttonTextInputColor)
	return modRead({visibleLength = w/2 + wid/2, liveUpdates = liveUpdate}, char)
end

function getDate()

local worldDays = os.day()
local month = 1
local day = worldDays
local year = 1
local leap = 28

-- get Year
i = 1
daysInYear = 365
while day > daysInYear do
if 1 < 4 then
daysInYear = 365
i = i + 1
leap = 28
else
daysInYear = 366
i = 1
leap = 29
end
year = year + 1
day = day - daysInYear
end

-- get Month
-- January
if day > 31 then
day = day - 31
month = month + 1
end
-- February
if day > leap then
day = day - leap
month = month + 1
end
-- March
if day > 31 then
day = day - 31
month = month + 1
end
-- April
if day > 30 then
day = day - 30
month = month + 1
end
-- May
if day > 31 then
day = day - 31
month = month + 1
end
-- June
if day > 30 then
day = day - 30
month = month + 1
end
-- July
if day > 31 then
day = day - 31
month = month + 1
end
-- August
if day > 31 then
day = day - 31
month = month + 1
end
-- September
if day > 30 then
day = day - 30
month = month + 1
end
-- October
if day > 31 then
day = day - 31
month = month + 1
end
-- November
if day > 30 then
day = day - 30
month = month + 1
end
-- December
if day > 31 then
day = day - 31
month = 1
year = year + 1
end

return day,month,year
end

function find( sType, cable )
 _color = {"white",
           "orange",
           "magenta",
           "lightBlue",
           "yellow",
           "lime",
           "pink",
           "gray",
 --          "lightGray",
           "cyan",
           "purple",
           "blue",
           "brown",
           "green",
           "red",
           "black"} 
 
 for _, value in pairs(rs.getSides()) do
  	if peripheral.getType(value) == sType then
    	  return value
   end
   
   if cable then
     for _, _value in pairs(_color) do
       if peripheral.getType(value..":".._value) == sType then
        return value..":".._value         
       end
     end
   end
 end
end

function extraFormatTime( nTime, char, bTwentyFourHour )
	local sTOD = nil
	if not bTwentyFourHour then
		if nTime >= 12 then
			sTOD = "PM"
		else
			sTOD = "AM"
		end
		if nTime >= 13 then
			nTime = nTime - 12
		end
	end

	local nHour = math.floor(nTime)
	local nMinute = math.floor((nTime - nHour)*60)
	if sTOD then
		return string.format( "%d"..char.."%02d %s", nHour, nMinute, sTOD )
	else
		return string.format( "%d"..char.."%02d", nHour, nMinute )
	end
end

if not find("modem") then
	term.setBackgroundColor(colors.black)
	term.clear()
	term.setTextColor(colors.white)	
	term.setCursorPos(1, 1)

	error("This program requires wireless modem!")
end

pathToConfig = "System/Chat.settings"

local w, h = term.getSize()
local input = ""
local name = ""
local s_rednet = find("modem")
local serverID

repeat
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	term.clear()
	cPrint("Enter server ID:", 6)
	serverID = centerRead(51 - 13, "", colors.gray, colors.white, colors.lightGray, false, nil, nil)
until tonumber(serverID)

serverID = tonumber(serverID)

term.setBackgroundColor(colors.black)
term.clear()

term.setTextColor(colors.white)
cPrint("Enter your nickname in chat:", 6)
name = centerRead(51 - 13, "", colors.gray, colors.white, colors.lightGray, false, nil, nil)

rednet.open( s_rednet )
rednet.send( serverID, "#CONNECT#"..name )
local cInput = ""
local sBars = ""
local tChatHistory = {}
local cBlink = ""
local cBlinkT = 0

-- Visual Config
bgColor = colors.black
chatMsgColor = colors.lightGray
barsColor = colors.white
textInputColor = colors.lightGray

for i=1,w - 1 do
	sBars = sBars.."-"
end

day, month, year = getDate()
logPath = "Chat_"..tostring(year).."-"..tostring(month).."-"..tostring(day).."_"..extraFormatTime(os.time(), ".", true)..".log"

function InfoLog(msg)
    log_file = fs.open(logPath, "a")
    log_file.writeLine(msg)
    log_file.flush()
    log_file.close()
end

function draw()
	while true do
		sleep( 0 )
		cBlinkT = cBlinkT + 1
		if cBlinkT == 5 then
			if cBlink == "" then
				cBlink = "_"
			else
				cBlink = ""
			end
			cBlinkT = 0
		end
		term.setBackgroundColor(bgColor)
		term.setTextColor(chatMsgColor)

		term.clear()
		term.setCursorPos(1, 1)

		local calch = h - 4

		for i=table.getn( tChatHistory ) - calch,table.getn( tChatHistory ) do
			if tChatHistory[i] ~= nil then
				write( tChatHistory[i] )
			end
		end

		term.setTextColor(colors.white)
		term.setCursorPos( 1, h - 1 )

		write( "> ")

		term.setTextColor(textInputColor)
		io.write( cInput..cBlink )

		term.setTextColor(barsColor)
		term.setCursorPos( 1, h - 2 )
		write( sBars )
	end
end

function key()
	while true do
		local event, p1 = os.pullEvent()
		if event == "key" then
			if p1 == 41 then
				rednet.send( serverID, "#QUIT___#"..name )
				break
			elseif p1 == 14 then
				cInput = string.sub( cInput, 1, string.len( cInput ) - 1 )
			elseif string.lower(cInput) == "/exit" and p1 == 28 then
				rednet.send( serverID, "#QUIT___#"..name )
				break
			elseif string.lower(cInput) == "/quit" and p1 == 28 then
				rednet.send( serverID, "#QUIT___#"..name )
				break
			elseif p1 == 28 then
				rednet.send( serverID, "ch_"..cInput )
				cInput = ""
			end
		elseif event == "char" then
			cInput = cInput..p1
		elseif event == "terminate" then
            rednet.send( serverID, "#QUIT___#"..name )
            break
        end
	end
end

function receive()
	while true do
		local event, ID, MSG, DIS = os.pullEvent( "rednet_message" )
		if ID == serverID then
			tChatHistory[table.getn( tChatHistory ) + 1] = MSG
			InfoLog(string.sub(MSG, 1, -3))
		end
	end
end

parallel.waitForAny( draw, key, receive )

rednet.close(find("modem"))

term.setBackgroundColor(colors.black)
term.clear()

term.setTextColor(colors.white)
term.setCursorPos(1, 1)
