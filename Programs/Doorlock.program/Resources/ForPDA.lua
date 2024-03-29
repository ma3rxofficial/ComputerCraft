local side = nil

for _, value in pairs(rs.getSides()) do
	if peripheral.getType(value) == "modem" then
		side = value
	end
end

if not side then
	print("You need wireless modem to work with Door Lock!")

else
	rednet.broadcast("DOORLOCK%OPEN")

end