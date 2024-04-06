local mapW, mapH=16,32

w, h = term.getSize()

local map={
  "1111111111111111",
  "1   12         1",
  "1 111111111111 1",
  "1 1      1   1 1",
  "1 1 1111 1 1 1 1",
  "1 1   1  1 1   1",
  "1 111 111111 111",
  "1   1          1",
  "111 11111111 1 1",
  "1 1          1 1",
  "1 111111111111 1",
  "1   1 1    1   1",
  "1 111 1 1111 111",
  "1     1    1   1",
  "1 11111111 111 1",
  "1              1",
  "1111114  4111111",
  "1              1",
  "1              1",
  "1  3  2  2  3  1",
  "1              1",
  "1              1",
  "1  2  5  5  2  1",
  "1              1",
  "1              1",
  "1  2  5  5  2  1",
  "1              1",
  "1              1",
  "1  3  2  2  3  1",
  "1              1",
  "1              1",
  "1111111111111111",
}  

local colorSchemes = {
  {0,8}, --white+gray
  {3,11}, --blue
  {6,14}, --red
  {5,13}, --green
  {4,1}, --yellow/orange
}


local function cast(cx,cy,angle)
  --direction vector
  local vx,vy=math.cos(angle), math.sin(angle)
  local slope=vy/vx
  --next distance, x and y axis points
  local ndx, ndy
  --steps, distance and block
  local dsx, dsy, bsx, bsy
  if vx<0 then
    local x=(cx%1)
    bsx=-1
    ndx=math.sqrt(x*x*(1+slope*slope))
    dsx=math.sqrt((1+slope*slope))
  else
    local x=1-(cx%1)
    bsx=1
    ndx=math.sqrt(x*x*(1+slope*slope))
    dsx=math.sqrt((1+slope*slope))
  end

  if vy<0 then
    local y=(cy%1)
    bsy=-1
    ndy=math.sqrt(y*y*(1+1/(slope*slope)))
    dsy=math.sqrt((1+1/(slope*slope)))
  else
    local y=1-(cy%1)
    bsy=1
    ndy=math.sqrt(y*y*(1+1/(slope*slope)))
    dsy=math.sqrt((1+1/(slope*slope)))
  end

  local x,y=math.floor(cx),math.floor(cy)
  while x>0 and x<=mapW and y>0 and y<=mapH do
    local hitD
    local isX
    if ndx<ndy then
      --x crossing is next
      x=x+bsx
      isX=true
      hitD=ndx
      ndx=ndx+dsx
    else
      y=y+bsy
      isX=false
      hitD=ndy
      ndy=ndy+dsy
    end
    local wall=map[y]:sub(x,x)
    if wall~=" " then
      
      return colorSchemes[tonumber(wall)][isX and 1 or 2], hitD
    end
  end  
end

local px, py=8.5,24.5
local dir=0
local fx,fy
local speed=.1
local turnSpeed=2.5

local function turn(amt)
  dir=dir+amt
  fx,fy=math.cos(math.rad(dir)), math.sin(math.rad(dir))
end

turn(0)

--build table of angles and base distances per scanline
local screenDist=40
local scan={}

for x=1,w do
  local t={}
  scan[x]=t
  t.angle=math.atan2(x-(w / 2),screenDist)
  t.dist=((x-(w / 2))^2+screenDist^2)^.5/screenDist
end

local function redraw()
  term.setBackgroundColor(colors.gray)
  term.clear()
  --term.setBackgroundColor(colors.gray)
  --for y=10,19 do
  --  term.setCursorPos(1,y)
  --  term.clearLine()
  --end
  for x=1,w do
    local wall,dist=cast(px,py,math.rad(dir)+scan[x].angle)
    if wall then
      term.setBackgroundColor(2^wall)
      --calc wall height based on distance
      local height=scan[x].dist/dist
      height=math.floor(height*9)
      for y=(h/2)-height,(h/2)+height do
        term.setCursorPos(x,y)
        term.write(" ")
      end
    end
  end
end

local function clampCollision(x,y,radius)
  --am I *in* a block?
  local gx,gy=math.floor(x),math.floor(y)
  if map[gy]:sub(gx,gx)~=" " then
    --I am. Complete fail, do nothing.
    return x,y
  end
  
  --ok, check the neighbors.
  local right=math.floor(x+radius)>gx
  local left=math.floor(x-radius)<gx
  local front=math.floor(y-radius)<gy
  local back=math.floor(y+radius)>gy
  
  local pushed=false
  
  if right and map[gy]:sub(gx+1,gx+1)~=" " then
    --push left
    pushed=true
    x=gx+1-radius
  elseif left  and map[gy]:sub(gx-1,gx-1)~=" " then
    --push right
    pushed=true
    x=gx+radius
  end
  
  if front and map[gy-1]:sub(gx,gx)~=" " then
    --push back
    pushed=true
    y=gy+radius
  elseif back and map[gy+1]:sub(gx,gx)~=" " then
    --push forward
    pushed=true
    y=gy+1-radius
  end
 
  --if I wasn't pushed out on any side, I might be hitting a corner
  if not pushed then
    --square rad
    local r2=radius^2
    local pushx,pushy=0,0
    if left then
      if front and map[gy-1]:sub(gx-1,gx-1)~=" " then
        --check front-left
        local dist2=(gx-x)^2+(gy-y)^2
        if dist2<r2 then
          local pushd=(r2-dist2)/2^.5
          pushx,pushy=pushd,pushd
        end
      elseif back and map[gy+1]:sub(gx-1,gx-1)~=" " then
        local dist2=(gx-x)^2+(gy+1-y)^2
        if dist2<r2 then
          local pushd=(r2-dist2)/2^.5
          pushx,pushy=pushd,-pushd
        end
      end
    elseif right then
      if front and map[gy-1]:sub(gx+1,gx+1)~=" " then
        --check front-left
        local dist2=(gx+1-x)^2+(gy-y)^2
        if dist2<r2 then
          local pushd=(r2-dist2)/2^.5
          pushx,pushy=-pushd,pushd
        end
      elseif back and map[gy+1]:sub(gx+1,gx+1)~=" " then
        local dist2=(gx+1-x)^2+(gy+1-y)^2
        if dist2<r2 then
          local pushd=(r2-dist2)/2^.5
          pushx,pushy=-pushd,-pushd
        end
      end
    end
    x=x+pushx
    y=y+pushy
  end
  
  return x,y
end



print([[
Basic wolfenstein 3d-style rendering engine proof-of-concept
controls:
asdw - move
left/right - turn left/right
q - quit

Press any key to begin...]])

os.pullEvent("key")

frametime = 0.01
frametimer = os.startTimer(frametime)

local pmousex, pmousey
sensitivity = 2

while true do
  px,py=clampCollision(px,py,.25)
  local e={os.pullEvent()}
  if e[1]=="key" then
    if e[2]==keys.left then
      turn(-turnSpeed)
    elseif e[2]==keys.right then
      turn(turnSpeed)
    elseif e[2]==keys.up or e[2]==keys.w then
      px=px+fx*speed
      py=py+fy*speed
    elseif e[2]==keys.down or e[2]==keys.s then
      px=px-fx*speed
      py=py-fy*speed
    elseif e[2]==keys.a then
      px=px+fy*speed
      py=py-fx*speed
    elseif e[2]==keys.d then
      px=px-fy*speed
      py=py+fx*speed
    elseif e[2]==keys.q then
      break
    end
  elseif e[1]=="mouse_drag" then
    if pmousex and math.abs(pmousex - e[3]) < (w / 6) then
      turn((pmousex - e[3]) * sensitivity)
    end
	pmousex = e[3]
	pmousey = e[4]
  elseif e[1]=="timer" then
    if e[2]==frametimer then
      redraw()
      frametimer = os.startTimer(frametime)
    end
  end
end


term.setBackgroundColor(colors.black)
os.pullEvent()
term.scroll(1)
term.setCursorPos(1,19)
