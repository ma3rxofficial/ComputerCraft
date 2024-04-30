local server_id = 639
local command = "DICE%START"

function modem()

   for _, side in pairs(rs.getSides()) do
      if peripheral.getType(side) == "modem" then
         rednet.open(side)

         return true
      end

      return false
   end
end

if not modem() then
   error("You need wireless modem!")
end

while true do
   term.clear()
   term.setCursorPos(1,1)
   term.write("Press Enter to roll the dice")
   io.read()
	rednet.send(server_id, command)
   sleep(0.7)
end
