------------FlappyBird v1.0----------
----------------Game-----------------
--------------by Creator-------------

--Variables--
--term.redirect(term.native())
local w,h = term.getSize()
local dead = false
local defaultConfing = {
	birdColor = colors.yellow,
	bgColor = colors.lightBlue,
	grassColor = colors.green,
	scoreColor = colors.red,
	obstacleColor = colors.blue
}
local obstacles = {}
local currObstacle = 0
local totalLenght = 0
local howFar = 0

--PhysicsVars--
local position = math.floor(h/2)
local G = 30
local maxSpeed = 20
local speed = maxSpeed
local position = 1
local totalTime = 0
local diff = 0.05
local xPos = math.floor(w/6)

--Functions--
local GUI = {}
local Physics = {}
local Events = {}

--GUI related functions--

function GUI.DrawBird()
	term.setCursorPos(xPos,h-position)
	term.setBackgroundColor(defaultConfing.birdColor)
	term.write("@")
end

function GUI.DrawBackground()
	term.setBackgroundColor(defaultConfing.bgColor)
	term.clear()
	term.setCursorPos(1,1)
	term.setTextColor(defaultConfing.scoreColor)
	term.write("You have passed "..tostring(currObstacle).." obstacles!")
	paintutils.drawLine(1,h,w,h,defaultConfing.grassColor)
end

function GUI.DrawObstacles()
	for i,v in pairs(obstacles) do
		local totalFar = v[1] + howFar
		if 0 < totalFar and totalFar <= w then
			paintutils.drawLine(totalFar,1,totalFar,v[3],defaultConfing.obstacleColor)
			paintutils.drawLine(totalFar,v[2]+v[3]-1,totalFar,h-1,defaultConfing.obstacleColor)
			if totalFar == xPos then
				currObstacle = currObstacle + 1
				if (1 <= h - position and h - position <= v[3]) or (v[2]+v[3]-1 <= h - position and h - position <= h-1) then
					dead = true
				end
			end
		end
		
	end
end

--Physics related functions--

function Physics.BirdMove()
	position = position + speed*diff - 0.5*G*math.pow( diff, 2 )
	speed = speed - G*diff
end

function Physics.KeepInBoundaries()
	if position <= 0 then
		dead = true	
	elseif position > h-2 then
		speed = 0
		position = h-2
	end
end

function Physics.GenerateObstacles(howMany)
	for i=1,howMany do
		totalLenght = totalLenght + math.random(35,70)
		local opening = math.random(5,15)
		local whereOpen = math.random(1,h-opening)
		obstacles[#obstacles + 1] = {totalLenght,opening,whereOpen}
	end
end

function Events.main()
	local timer = os.startTimer(.2)
	local event, p2 = os.pullEvent()
	if event == "key" and p2 == keys.space then
--		os.stopTimer(timer)
		speed = maxSpeed
	end
end

--Code--

--[[f = fs.open("FlappyBirdConfig/configs","r")
configurationBuffer = f.readAll()
f.close()]]--

Physics.GenerateObstacles(100)

while true do
	if dead == true then
		error("you died")
	end
	Events.main()
	GUI.DrawBackground()
	GUI.DrawBird()
	GUI.DrawObstacles()
	Physics.BirdMove()
	Physics.KeepInBoundaries()
	--Physics.DetectColision()
	howFar = howFar - 1
end

