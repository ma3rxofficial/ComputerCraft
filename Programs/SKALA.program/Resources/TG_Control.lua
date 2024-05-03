SpeedOS.LoadAPI("SpeedAPI/sensor")

local Sensor_Data1 = 0

local Sensor_Data2 = 0

local Smoothed_RPM = 0

local Currently_Readable_Turbine = 1

local Measurement_Cycle = 1

local Colors_TG = { 
	sensor.wrap("bottom:white"),
	sensor.wrap("bottom:orange"),
	sensor.wrap("bottom:magenta"),
	sensor.wrap("bottom:lightBlue")
	}
	
 local Monitor = peripheral.wrap("bottom:brown")
 Monitor.setTextScale(3,3)
 
 local Monitor_CSHU = peripheral.wrap("bottom:red")
 Monitor_CSHU.setTextScale(3,3)
 
local RPM = { }
	
RPM[1] = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
	}
	
RPM[2] = {
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
	}

Turbine_Average_RPM = 0
	
while true do



	for I = 1, #Colors_TG do

		local bCalculate_Avg = Measurement_Cycle == 2 and 1 or 0
		



		RPM[Measurement_Cycle][Currently_Readable_Turbine] = Colors_TG[I].getTargetDetails("0,0,1")["EnergyEmitted"]
	--	print(RPM[1][Currently_Readable_Turbine])


		Turbine_Average_RPM = Turbine_Average_RPM + ( RPM[2][Currently_Readable_Turbine] - RPM[1][Currently_Readable_Turbine] ) * bCalculate_Avg

		Currently_Readable_Turbine = Currently_Readable_Turbine + 1
		

		RPM[Measurement_Cycle][Currently_Readable_Turbine] = Colors_TG[I].getTargetDetails("0,0,-1")["EnergyEmitted"]
		--print(RPM[2][Currently_Readable_Turbine])

		Turbine_Average_RPM = Turbine_Average_RPM + ( RPM[2][Currently_Readable_Turbine] - RPM[1][Currently_Readable_Turbine] ) * bCalculate_Avg

		Currently_Readable_Turbine = Currently_Readable_Turbine + 1
  
  
		
		
		if( I == #Colors_TG ) then Turbine_Average_RPM = Turbine_Average_RPM / #Colors_TG end





	end
	
  

	if( Measurement_Cycle == 1) then

		Measurement_Cycle = 2

	elseif( Measurement_Cycle > 1) then

  Smoothed_RPM = Smoothed_RPM + (Turbine_Average_RPM - Smoothed_RPM) / 15

		Measurement_Cycle = 1
  Monitor.clear()
  Monitor.setCursorPos(2,2)
  Monitor.write(tostring(math.ceil(Smoothed_RPM * 10)))
  
  Monitor_CSHU.clear()
  Monitor_CSHU.setCursorPos(2,2)
  Monitor_CSHU.write(tostring(math.ceil(Smoothed_RPM * 10)))
  
  if math.ceil(Smoothed_RPM * 10) < 11 then
   rs.setOutput("front", true)
   
  else
   rs.setOutput("front", false)
   
  end
  
	end


	Turbine_Average_RPM = 0

	Currently_Readable_Turbine = 1

	sleep(0)

end
