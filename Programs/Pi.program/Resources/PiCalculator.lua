--[[
    The program calculates Pi 
    using the following formula: 4/1 - 4/3 + 4/5 - 4/7 +...
]]

logPath = "Pi.log"

function InfoLog(msg)
    log_file = fs.open(logPath, "a")
    log_file.writeLine(msg) 
    log_file.flush()
    log_file.close()
end

iL = 100000
b = 1
c = 0
i = 1
pi = 0

while true do
    pi = pi + 4/b
    b = b + 2
    pi = pi - 4/b
    b = b + 2
    c = c + 1

    message = "Iteration: "..tostring(i).." Sub-iteration: "..tostring(c).." Pi: "..tostring(pi)

    print(message)
    InfoLog(message)
    
    if c == iL then
        c = 0
        i = i + 1
    end

    sleep(0)
end
