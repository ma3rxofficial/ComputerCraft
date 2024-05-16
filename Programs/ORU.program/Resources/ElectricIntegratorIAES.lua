cableSide = "back"

z_t = colors.white
z_y = colors.orange
z_u = colors.magenta

while true do

	print("=============================================")
	print("ELECTRIC I N T E G R A T O R     PROGRAM IAES   ")
	print("=============================================")
	print("[T]-INPUT 50 KEY")
	print("[Y]-INPUT 50 KEY")
	print("[U]-KEY ENGINE1")
	print("=============================================")

	local event, param1 = os.pullEvent("key") 
	if param1 == keys.t then
		print("50")
		rs.setBundledOutput(cableSide, z_t)
		sleep(0.3)
		rs.setBundledOutput(cableSide, 0)
		print("OK")
		sleep(0.3)
		term.clear()
		term.setCursorPos(1,1)
	end

	if param1 == keys.y then
		print("50")
		rs.setBundledOutput(cableSide, z_y)
		sleep(0.3)
		rs.setBundledOutput(cableSide, 0)
		print("OK")
		sleep(0.3)
		term.clear()
		term.setCursorPos(1,1)
	end

	if param1 == keys.u then
		print("k eng1")
		rs.setBundledOutput(cableSide, z_u)
		sleep(0.3)
		rs.setBundledOutput(cableSide,0)
		print("OK")
		sleep(0.3)
		term.clear()
		term.setCursorPos(1,1)
	end
end
