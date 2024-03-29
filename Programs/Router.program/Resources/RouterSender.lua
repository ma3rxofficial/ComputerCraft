local blacklisted = {}

function find( sType, cable )
 _color = {"white",
           "orange",
           "magenta",
           "lightBlue",
           "yellow",
           "lime",
           "pink",
           "gray",
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

function blacklist(id)
  for _, value in pairs(blacklisted) do
    if value == id then
      return false
    end
  end

  return true
end

rednet.open(find("modem"))
modem = peripheral.wrap(find("LAN NIC"))

while true do
  event, id, msg, dist = os.pullEvent()
  if event == "rednet_message" and blacklist(id) then
    modem.send("<"..tostring(id).."> "..msg)
    print("<"..tostring(id).."> "..msg)
  end
end
