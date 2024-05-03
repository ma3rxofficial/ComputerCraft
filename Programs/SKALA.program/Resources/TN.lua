os.loadAPI("Resources/APIs/invmanager")


local Channels = {
 invmanager.wrap("back:white"), invmanager.wrap("back:red"), invmanager.wrap("back:blue"), invmanager.wrap("back:green"),
 invmanager.wrap("back:lime"), invmanager.wrap("back:yellow"), invmanager.wrap("back:gray"), invmanager.wrap("back:black"),
 invmanager.wrap("back:orange"), invmanager.wrap("back:pink"), invmanager.wrap("back:cyan"), invmanager.wrap("back:brown")}

local HC_Colors = {
colors.white, colors.orange, colors.magenta, colors.lightBlue,
colors.yellow, colors.lime, colors.pink, colors.gray,
colors.lightGray, colors.cyan, colors.purple, colors.blue}

local Channels_Count = #Channels

local HC_Pressure = {0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0}

local LZH_Slots = {10, 11, 12, 13, 14,
				   46, 47, 48, 49, 50 }
				   
local LZH_Slots_Size = #LZH_Slots
				   
local Selected_Slots = {}

local LZH_Chest_Size = Channels[1].size("up")

local Empty_Slots = {}

local Timer = 0

local Speed = 15

local Overall_Pressure = 0

local Pressure_Lamp = 0

local Unstable_HC_In = 0

local UHCIN = 0

local Moved_Successfully_From_Reactor = 0




for I = 1, 12 do

	for I = 1, #HC_Colors do


		rs.setBundledOutput("bottom", HC_Colors[I])

		sleep(0.1)
		
		rs.setBundledOutput("bottom", 0)
	
		
	

		

		
	end




end


	
	


for I = 1, Channels_Count do

	Selected_Slots[#Selected_Slots + 1] = 1


end

for I = 1, Channels_Count do
	
		for Selected_Slot = 1, LZH_Slots_Size do
	
			if(Channels[I].read("south", LZH_Slots[Selected_Slot]) ~= 0) then
				
				HC_Pressure[I] = HC_Pressure[I] + 1
				
				print("Channel " .. I .. " pressure is " .. HC_Pressure[I])
				
				rs.setBundledOutput("top", HC_Colors[I])

				sleep(0.1)
			
				rs.setBundledOutput("top", 0)
		
				sleep(0)
					
				
			end
				

		end
	
	end



while true do

	if rs.testBundledInput("front", colors.red) then
	
	
	
	rs.setOutput("top", true)
	
		for I = 1, Channels_Count do

			Moved_Successfully_From_Reactor = 0
		
			if(Channels[I].read("south", LZH_Slots[Selected_Slots[I]]) ~= 0) then
			
			Channels[I].move("south", "down", LZH_Slots[Selected_Slots[I]])
			 
			Moved_Successfully_From_Reactor = 1
			
			end
			

			
			for H = 1, LZH_Chest_Size do
			
			local Reading_Slot_Validity = Channels[I].read("up", H)
			
				if(Reading_Slot_Validity ~= 0) then
				
					if (Moved_Successfully_From_Reactor == 0) then

						HC_Pressure[I] = HC_Pressure[I] + 1
							
						rs.setBundledOutput("top", HC_Colors[I])

						sleep(0.1)
						
						rs.setBundledOutput("top", 0)
						
						print("Pressure in channel " .. I .. " was increased!")

						

					end
				
					Channels[I].move("up", "south", H, LZH_Slots[Selected_Slots[I]])
					

					break

				
				end
				
				if(Reading_Slot_Validity == 0 and H == LZH_Chest_Size and Moved_Successfully_From_Reactor == 1) then
				
					UHCIN = UHCIN + 1
				
					HC_Pressure[I] = HC_Pressure[I] - 1
								
					rs.setBundledOutput("bottom", HC_Colors[I])

					sleep(0.1)
							
					rs.setBundledOutput("bottom", 0)
				
					print("Pressure in channel " .. I .. " was decreased!")
				
				end
				
				
				
				
			
			   end

				
			
			
			if(Selected_Slots[I] <= LZH_Slots_Size) then
			
				Selected_Slots[I] = Selected_Slots[I] + 1

			
			end
			
			if(Selected_Slots[I] > LZH_Slots_Size) then
			
				Selected_Slots[I] = 1
			
			end
		
			rs.setOutput("top", false)
			
			
		
		end
		
		for Sum = 1, #HC_Pressure do
		
 
		
			Overall_Pressure = Overall_Pressure + HC_Pressure[Sum]
		
		end
		
	if Overall_Pressure >= 120 then
	
	
	Pressure_Lamp = colors.green
	
	
	elseif Overall_Pressure > 100 and Overall_Pressure < 120 then
	
	Pressure_Lamp = colors.brown
	
	elseif Overall_Pressure < 100 then
	
	Pressure_Lamp = colors.red
	
	end
	
	if UHCIN > 0 then
	
	Unstable_HC_In = colors.black
	
	elseif UHCIN == 0 then
	
	Unstable_HC_In = 0
	
	
	end
	
	rs.setBundledOutput("right", Pressure_Lamp + Unstable_HC_In)


	print(Overall_Pressure)
	Overall_Pressure = 0
	
	UHCIN = 0
	

	
	end
	



	sleep(0)

end
