while true do
   term.clear()
   term.setCursorPos(1,1)
   term.write("Press Enter to roll the dice")
   io.read()
      if true then
          rednet.open("back")
	  rednet.send(639, "DICE%START")    --ID of the first computer and command.
          sleep(0,7)
      end
end
