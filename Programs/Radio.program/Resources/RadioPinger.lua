--[[ 
      Used on radio #352
--]]


rednet.open("top")
string = "Ping!"
while true do
  rednet.broadcast(tostring(string))
  print("Broadcasted to RedNet: "..string)
  sleep(1)
end

rednet.close("top")
