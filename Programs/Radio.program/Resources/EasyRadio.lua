--[[
      Not used! Just a test.
--]]

rednet.open("top")

while true do
  term.setTextColor(colors.lightGray)
  io.write("> ")
  term.setTextColor(colors.white)
  msg = io.read()

  rednet.broadcast(msg)
  print("Broadcasted "..msg.."!")
end
