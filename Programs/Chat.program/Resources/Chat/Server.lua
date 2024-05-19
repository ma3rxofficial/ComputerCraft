local enable_password = false
local password = ""
local servername = ""
local s_rednet = "back"
local wait = 0

function getRoot()
	local outC = ""
	outC = shell.getRunningProgram()
	outC = string.sub( outC, 1 , string.len( outC ) - 10 )
	return outC
end

if fs.exists( getRoot().."sconfig.cfg" ) then
	cr = fs.open( getRoot().."sconfig.cfg", "r" )
	for i=1,5 do
		local fd = cr.readLine()
		if i == 3 then
			local fdx = string.sub( fd, string.len( fd ), string.len( fd ) )
			if fdx == "0" then
				enable_password = false
			elseif fdx == "1" then
				enable_password = true
			else
				enable_password = "error"
			end
		elseif i == 4 then
			local fdx = string.sub( fd, 12 + 1, string.len( fd ) - 1 )
			password = fdx
		elseif i == 5 then
			local fdx = string.sub( fd, 14 + 1, string.len( fd ) - 1 )
			servername = fdx
		end
	end
	cr.close()
else
	
end

rednet.open( s_rednet )

local connectedClientsID = {}
local connectedClientsName = {}
local connectedClients = 0
local chatBin = ""
local tChatHistory = {}
local w, h = term.getSize()

function keyController()
	while true do
		sleep(0)
		local event, p1 = os.pullEvent( "key" )
		if p1 == 41 then
			break
		end
	end
end

function clientSendController()
	while true do
		sleep(0)
		if wait ~= 0 then
			wait = wait - 1
		end
		if wait == 0 then
			if chatBin ~= "" then
				tChatHistory[table.getn( tChatHistory ) + 1] = chatBin
				for i=1,table.getn( connectedClientsID ) do
					rednet.send( tonumber( connectedClientsID[i] ), chatBin )
				end
			end
			chatBin = ""
		end
	end
end

function clientGetController()
	while true do
		sleep(0)
		local event, ID, MSG, DISTANCE = os.pullEvent( "rednet_message" )
		local x = string.sub( MSG, 1, 3 )
		local msgx = string.sub( MSG, 4, string.len( MSG ) )
		local allow = false
		for i=1,table.getn( connectedClientsID ) do
			if ID == connectedClientsID[i] then
				allow = true
			end
		end
		if allow == true then
			if msgx ~= "" then
				if x == "ch_" then
					local name = ""
					for i=1,table.getn( connectedClientsID ) do
						if ID == connectedClientsID[i] then
							name = connectedClientsName[i]
						end
					end
					if name ~= "" then
						chatBin = chatBin.."<"..name.."> "..msgx.."\n"
					end
				end
			end
		end
	end
end

function screen()
	while true do
		sleep(0)
		term.clear()
		term.setCursorPos(1, 1)
		print( "Chat Server: "..os.getComputerID() )
		print( "Clients: " )
		for i=1,table.getn( connectedClientsID ) do
			if i ~= table.getn( connectedClientsID ) then
				write( connectedClientsName[i].."["..connectedClientsID[i].."]"..", " )
			else
				write( connectedClientsName[i].."["..connectedClientsID[i].."]" )
			end
		end
		write("\n")
		for i=table.getn( tChatHistory ) - h / 2 - 1, table.getn( tChatHistory ) do
			if tChatHistory[i] ~= nil then
				write( tChatHistory[i] )
			end
		end
	end
end

function cListen()
	while true do
		sleep(0)
		local event, ID, MSG, DISTANCE = os.pullEvent( "rednet_message" )
		local x = string.sub( MSG, 1, 9 )
		local msgx = string.sub( MSG, 10, string.len( MSG ) )
		local allow = true
		for i=1,table.getn( connectedClientsID ) do
			if ID == connectedClientsID[i] then
				allow = false
			end
		end
		for i=1,table.getn( connectedClientsName ) do
			if msgx == connectedClientsName[i] then
				allow = false
			end
		end
		if allow == true then
			if x == "#CONNECT#" then
				local connected = false
				for i=1,table.getn( connectedClientsID ) do
					if connectedClientsID[i] == "DIS" then
						connectedClientsID[i] = ID
						connectedClientsName[i] = msgx
						connected = true
						chatBin = chatBin..msgx.." Connected.\n"
						wait = 2
						break
					end
				end
				if connected == false then
					connectedClients = connectedClients + 1
					connectedClientsID[connectedClients] = ID
					connectedClientsName[connectedClients] = msgx
					chatBin = chatBin..msgx.." Connected.\n"
					wait = 2
				end
			end
		end
		if x == "#QUIT___#" then
			for i=1,table.getn( connectedClientsID ) do
				if ID == connectedClientsID[i] then
					connectedClientsID[i] = "DIS"
					connectedClientsName[i] = "DIS"
					chatBin = chatBin..msgx.." Disconnected.\n"
				end
			end
		end
	end
end

parallel.waitForAny( cListen, keyController, clientGetController, clientSendController, screen )
