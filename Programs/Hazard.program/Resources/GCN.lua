term.clear()
term.setCursorPos(1,1)

while true do 

print("Main Circulation Pumps - North I")
print("")
print("==================================")
print("Select operation - ")
print("1.On\Off Pump-I")
print("2.On\Off Pump-II")
print("3.On\Off Pump-III")
print("4.On\Off Pump-IV")
print("5.On\Off North System")
print("")
print("==================================")

local event, param1 = os.pullEvent("char")
if param1 == "1" then
print("Pump-I Operation")
rs.setBundledOutput("bottom", 1)
sleep(1)
rs.setBundledOutput("bottom", 0)
sleep(0,4)
term.clear()
term.setCursorPos(1,1)
end
if param1 == "2" then
print("Pump-II Operation ")
rs.setBundledOutput("bottom", 2)
sleep(0,7)
rs.setBundledOutput("bottom", 0)
sleep(0,4)
term.clear()
term.setCursorPos(1,1)
end
if param1 == "3" then
print("Pump-III Operation ")
rs.setBundledOutput("bottom", 4)
sleep(0,7)
rs.setBundledOutput("bottom", 0)
sleep(0,4)
term.clear()
term.setCursorPos(1,1)
end
if param1 == "4" then
print("Pump-IV Operation ")
rs.setBundledOutput("bottom", 8)
sleep(0,7)
rs.setBundledOutput("bottom", 0)
sleep(0,4)
term.clear()
term.setCursorPos(1,1)
end
if param1 == "5" then
print("Pumps North Operation ")
rs.setBundledOutput("bottom", 16)
sleep(0,7)
rs.setBundledOutput("bottom", 0)
sleep(0,7)
term.clear()
term.setCursorPos(1,1)
end
end

term.clear()
term.setCursorPos(1,1)

while true do 

print("Main Circulation Pumps - North I")
print("")
print("==================================")
print("Select operation - ")
print("1.On\Off Pump-I")
print("2.On\Off Pump-II")
print("3.On\Off Pump-III")
print("4.On\Off Pump-IV")
print("5.On\Off North System")
print("")
print("==================================")

local event, param1 = os.pullEvent("char")
if param1 == "1" then
print("Pump-I Operation")
rs.setBundledOutput("bottom", 1)
sleep(1)
rs.setBundledOutput("bottom", 0)
sleep(0,4)
term.clear()
term.setCursorPos(1,1)
end
if param1 == "2" then
print("Pump-II Operation ")
rs.setBundledOutput("bottom", 2)
sleep(0,7)
rs.setBundledOutput("bottom", 0)
sleep(0,4)
term.clear()
term.setCursorPos(1,1)
end
if param1 == "3" then
print("Pump-III Operation ")
rs.setBundledOutput("bottom", 4)
sleep(0,7)
rs.setBundledOutput("bottom", 0)
sleep(0,4)
term.clear()
term.setCursorPos(1,1)
end
if param1 == "4" then
print("Pump-IV Operation ")
rs.setBundledOutput("bottom", 8)
sleep(0,7)
rs.setBundledOutput("bottom", 0)
sleep(0,4)
term.clear()
term.setCursorPos(1,1)
end
if param1 == "5" then
print("Pumps North Operation ")
rs.setBundledOutput("bottom", 16)
sleep(0,7)
rs.setBundledOutput("bottom", 0)
sleep(0,7)
term.clear()
term.setCursorPos(1,1)
end
end
