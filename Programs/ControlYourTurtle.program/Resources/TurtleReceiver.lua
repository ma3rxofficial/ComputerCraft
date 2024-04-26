rednet.open("right")
term.clear()

term.setCursorPos(1, 1)
print("Your ID: "..os.getComputerID())
io.write("Please enter Computer ID: ")
comp_id = io.read()

term.clear()
term.setCursorPos(1, 1)
print("Welcome to Turtle Receiver!")
print("Your ID: "..os.getComputerID())
while true do
  event, id, msg, dist = os.pullEvent()
  if event == "rednet_message" and id == tonumber(comp_id) then
    print(msg)
    if msg == "W" then
       turtle.forward()
       rednet.send(id, "Turtle moved forward!")
    elseif msg == "S" then
      turtle.back()
      rednet.send(id, "Turtle moved backward!")
    elseif msg == "A" then
      turtle.turnLeft()
      rednet.send(id, "Turtle turned left!")
    elseif msg == "D" then
      turtle.turnRight()
      rednet.send(id, "Turtle turned right!")
    elseif msg == "UP" then
      turtle.up()
      rednet.send(id, "Turtle moved up!")
    elseif msg == "DOWN" then
      turtle.down()
      rednet.send(id, "Turned moved down!")
    elseif msg == "REFUEL" then
      turtle.refuel()
      rednet.send(id, "Turtle refueled! Fuel level: "..turtle.getFuelLevel())
    elseif msg == "FUEL" then
      rednet.send(id, tostring(turtle.getFuelLevel()))
    elseif msg == "ATTACK" then
      turtle.attack()
      turtle.attackUp()
      turtle.attackDown()
      rednet.send(id, "Turtle attacked!")
    elseif msg == "DIG" then
      turtle.dig()
      rednet.send(id, "Turtle digged!")
    elseif msg == "DIGU" then
      turtle.digUp()
      rednet.send(id, "Tutle digged block in up!")
    elseif msg == "DIGD" then
      turtle.digDown()
      rednet.send(id, "Turtle digged block in down!")
    elseif msg == "USE" then
      turtle.place()
      rednet.send(id, "Turtle used item!")
    elseif msg == "USEU" then
      turtle.placeUp()
      rednet.send(id, "Turtle used item in up!")
    elseif msg == "USED" then
      turtle.placeDown()
      rednet.send(id, "Turtle used item in down!")
    elseif msg == "RS" then
      rs.setOutput("front", true)
      rednet.send(id, "Turtle send redstone signal!")
      sleep(1)
      rs.setOutput("front", false)
      rednet.send(id, "Turtle not sending redstone signal anymore!")
    elseif msg == "1" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "2" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "3" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "4" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "5" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "6" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "7" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "8" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "9" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "10" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "11" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "12" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "13" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "14" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "15" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    elseif msg == "16" then
      turtle.select(tonumber(msg))
      rednet.send(id, "Turtle's slot is now "..tostring(msg))
    end
  end  
end

