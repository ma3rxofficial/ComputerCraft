SpeedOS.LoadAPI("SpeedAPI/SpeedText")
SpeedOS.LoadAPI("SpeedAPI/peripheral")
SpeedOS.LoadAPI("SpeedAPI/windows")

if not peripheral.find("adventure map interface", true) then
	windows.clearScreen(colors.gray)
	term.setTextColor(colors.white)
	SpeedText.cPrint("MIDI-Radio")
	term.setTextColor(colors.lightGray)
	SpeedText.cPrint("Network unavailable!", 10)
	SpeedText.cPrint("Press key...", 11)

	SpeedText.waitForEvent({"mouse_click", "mouse_drag", "key"})
	SpeedOS.Close()
end

windows.clearScreen(colors.gray)
sleep(0.5)
term.setTextColor(colors.white)
SpeedText.cPrint("MIDI-Radio", 5)
sleep(1)
term.setTextColor(colors.lightGray)
SpeedText.cPrint("Instant ComputerCraft Radio", 6)
sleep(0.5)
SpeedText.cPrint("Press any key...", 9)
SpeedText.waitForEvent({"mouse_click", "mouse_drag", "key"})
windows.clearScreen(colors.gray)

local p = peripheral.wrap(peripheral.find("adventure map interface", true))
local userlist = {"Ma3rX"}
local msg

repeat 
	msg = SpeedText.centerRead(51 - 13, "", colors.lightGray, colors.white, colors.white, false, nil, nil, nil, "")
until tostring(msg)

for _, user in pairs(userlist) do
	if SpeedText.checkForelement(user, p.getPlayerUsernames()) then
		pl = p.getPlayerByName(user)

		pl.sendChat(msg)
	end
end
