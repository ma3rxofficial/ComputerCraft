availableSides  = rs.getSides()

function proverka() 
  for _, side in pairs(availableSides) do
    if peripheral.getType(side) == "modem" then
      return true
    end
  end

  return false
end

if not proverka() then
  term.clear()
  term.setCursorPos(1, 1)
  error("You need wireless modem!")
end

rednet.open("right")

r_i = 0

term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1, 1)
term.setTextColor(colors.white)

print("Your ID: "..os.getComputerID())
io.write("Please enter Computer ID: ")
comp_id = io.read()

if not tonumber(comp_id) then
  term.clear()
  term.setCursorPos(1, 1)
  print("You must enter a number!")
  error()
end

term.clear()
term.setCursorPos(1, 1)

print("Welcome to Turtle Receiver!")
print("Your ID: "..os.getComputerID())

while true do
  event, id, msg, dist = os.pullEvent()
  
  if event == "rednet_message" and id == tonumber(comp_id) then
    print(msg)
    r_i = r_i + 1


    if string.upper(msg) == "W" then
      if turtle.getFuelLevel() == 0 then
        rednet.send(id, "No fuel!")
      else
        turtle.forward()
        rednet.send(id, "Turtle moved forward!")
      end
    elseif string.upper(msg) == "S" then
      if turtle.getFuelLevel() == 0 then
        rednet.send(id, "No fuel!")
      else
        turtle.back()
        rednet.send(id, "Turtle moved backward!")
      end
    elseif string.upper(msg) == "A" then
      turtle.turnLeft()
      rednet.send(id, "Turtle turned left!")
    elseif string.upper(msg) == "D" then
      turtle.turnRight()
      rednet.send(id, "Turtle turned right!")
    elseif string.upper(msg) == "UP" then
      if turtle.getFuelLevel() == 0 then
        rednet.send(id, "No fuel!")
      else
        turtle.up()
        rednet.send(id, "Turtle moved up!")
      end
    elseif string.upper(msg) == "DOWN" then
       if turtle.getFuelLevel() == 0 then
        rednet.send(id, "No fuel!")
      else
        turtle.down()
        rednet.send(id, "Turned moved down!")
      end
    elseif string.upper(msg) == "REFUEL" then
      turtle.refuel()
      rednet.send(id, "Turtle refueled! Fuel level: "..turtle.getFuelLevel())
    elseif string.upper(msg) == "FUEL" then
      rednet.send(id, tostring(turtle.getFuelLevel()))
    elseif string.upper(msg) == "ATTACK" then
      turtle.attack()
      turtle.attackUp()
      turtle.attackDown()
      rednet.send(id, "Turtle attacked!")
    elseif string.upper(msg) == "DIG" then
      turtle.dig()
      rednet.send(id, "Turtle digged!")
    elseif string.upper(msg) == "DIGU"  or string.upper(msg) == "DIG U" then
      turtle.digUp()
      rednet.send(id, "Tutle digged block in up!")
    elseif string.upper(msg) == "DIGD"  or string.upper(msg) == "DIG D"then
      turtle.digDown()
      rednet.send(id, "Turtle digged block in down!")
    elseif string.upper(msg) == "USE" then
      turtle.place()
      rednet.send(id, "Turtle used item!")
    elseif string.upper(msg) == "USEU" or string.upper(msg) == "USE U" then
      turtle.placeUp()
      rednet.send(id, "Turtle used item in up!")
    elseif string.upper(msg) == "USED" or string.upper(msg) == "USE D" then
      turtle.placeDown()
      rednet.send(id, "Turtle used item in down!")
    elseif string.upper(msg) == "RS" then
      if r_i % 2 == 0 then

        for _, side in pairs(rs.getSides()) do
            rs.setOutput(side, true)
        end
      
        rednet.send(id, "Turtle send redstone signal!")
        sleep(1)
      else
        for _, side in pairs(rs.getSides()) do
            rs.setOutput(side, false)
        end
      
        rednet.send(id, "Turtle not sending redstone signal anymore!")
      end
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
    elseif string.upper(msg) == "HELP" then
      rednet.send(id, " ")
    elseif string.upper(msg) == ""EXIT" or string.upper(msg) == "QUIT" then
      break
    end
  end  
end

print("Turtle stopped.")
