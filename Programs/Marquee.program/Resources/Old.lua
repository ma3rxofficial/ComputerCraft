SpeedOS.LoadAPI("SpeedAPI/peripheral")

io = SpeedOS.IO

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)

local monitor
local sides = {"left", "right", "top", "bottom", "back", "front"}
local str = "Hello, world! "
local pos = 1
local speedStep = 0.5
local speed = 2
local maxSpeed = 10
local running = false
local keys = {
    backspace=14,
    enter=28,
    f1=59,
    f3=61,
    leftArrow=203,
    rightArrow=205,
}
local locked = false
local password = ""
local correct_password = ""

local banner = {
" ___ ___                                          ",
"|   Y   |.---.-..----..-----..--.--..-----..-----.",
"|.      ||  _  ||   _||  _  ||  |  ||  -__||  -__|",
"|. \\_/  ||___._||__|  |__   ||_____||_____||_____|",
"|:  |   |                |__|                     ",
"|::.|:. |   v1.1                 by Ma3rX         ",
"'--- ---'   "
}

function setup()
    -- prevent user from terminating
    os.pullEvent = os.pullEventRaw

    -- attempt to load the string from disk
    local file = io.open("Programs/Marquee.program/Resources/Pizdapka/marquee-text", "r")
    if file then
        str = file:read("*l") or str
        speed = tonumber(file:read("*l")) or speed
        correct_password = file:read("*l") or correct_password
        if string.len(correct_password) > 0 then
            -- the password was set at some point, lock automatically
            locked = true
        end
        file:close()
    end

    if not peripheral.find("monitor", true) then
        term.setBackgroundColor(colors.red)
        print("No monitor attached")
        error()
        term.setBackgroundColor(colors.black)
    else
        monitor = peripheral.wrap(peripheral.find("monitor", true))
        monitor.setTextScale(5)
        running = true
        return
    end
end

function draw()
    -- draw the string offset by pos
    -- increment pos
    -- when pos > str len, pos = 1
    monitor.clear()
    monitor.setCursorPos(1,1)

    if string.len(str) == 0 then 
        return
    end

    -- pad the str to fit the screen
    local _str = str
    local len, height = monitor.getSize()
    while string.len(_str) < len do
        _str = _str .. _str
    end

    local output = string.sub(_str, pos) .. string.sub(_str, 0, pos-1)
    monitor.write(output)
end

function update()
    if speed == 0 then pos = 1 return end
    pos = pos + 1
    if pos > string.len(str) then
        pos = 1
    end
end

function marquee()
    while running do
        draw()
        if speed > 0 then
            update()
            sleep(1/speed)
        else
            sleep(0.5)
        end
    end
end

function drawGUI()
    --always draw the banner
    term.clear()
    for i,v in ipairs(banner) do
        term.setCursorPos(1,i)
        term.write(v)
    end

    if locked then
        drawLockedGUI()
    else
        drawUnlockedGUI()
    end
end

function drawLockedGUI()
    local line = #banner + 2
    term.setCursorPos(1,line)
    if string.len(correct_password) == 0 then
        term.write("  Set password: ")
    else
        term.write("  Password: ")
    end
    term.write(string.rep('*', string.len(password)))
end

function drawUnlockedGUI()
    local line = #banner + 2

    -- lock
    term.setCursorPos(1,line)
    term.write("  To lock terminal, press F1")

    -- exit
    line = line + 1
    term.setCursorPos(1,line)
    term.write("  To quit, press F3")

    -- speed gui
    line = line + 2
    term.setCursorPos(1,line)
    term.write(
        "  Speed: <" .. 
        string.rep('-', speed/speedStep) ..
        'X' .. 
        string.rep('-', (maxSpeed - speed)/speedStep) .. 
        "> " .. 
        string.format("%.1f", speed) .. 
        " steps/sec"
    )

    -- text
    line = line + 2
    term.setCursorPos(1,line)
    term.write(
        "  Text: " .. 
        str
    )
    term.setCursorBlink(true)
end

function save()
    local file = io.open("Programs/Marquee.program/Resources/Pizdapka/marquee-text", "w")
    if file then
        file:write(str)
        file:write("\n")
        file:write(speed)
        file:write("\n")
        file:write(password)
        file:close()
    end
end

function gui()
    drawGUI()
    while running do
        local evt, p1, p2, p3 = os.pullEvent()
        if evt == "char" then
            if locked then
                -- read the password
                password = password .. p1
            else
                str = str .. p1
                save()
            end
        elseif evt == "key" then
            if p1 == keys["backspace"] and not locked then
                str = string.sub(str, 1, string.len(str)-1)
                save()
            elseif p1 == keys["leftArrow"] and not locked then
                speed = math.max(speed-speedStep, 0)
                save()
            elseif p1 == keys["rightArrow"] and not locked then
                speed = math.min(speed+speedStep, maxSpeed)
                save()
            elseif p1 == keys["f1"] and not locked then
                locked = true
            elseif p1 == keys["f3"] and not locked then
                term.clear()
                term.setCursorPos(1,1)
                return true
            elseif p1 == keys["enter"] and locked then
                if string.len(correct_password) == 0 then
                    correct_password = password
                    save()
                else
                    if password == correct_password then
                        locked = false
                    end
                end
                password = ""
            end
        end
        drawGUI()
    end
end


setup()
parallel.waitForAny(marquee, gui)
