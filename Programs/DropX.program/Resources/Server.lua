-- You need a wireless modem.


function pizdec(fn)
    for _, eblan in pairs(fs.list("/")) do
        if eblan == fn then
            return true
        end
    end
    return false
end

local path = "/data/~"
for _, s in pairs(rs.getSides()) do
    if peripheral.isPresent(s) and peripheral.getType(s) == "modem" then
        rednet.open(s)
    end
end
isDebug = ...
function split(str, pattern)
  local tbl = {}
  local fpat = "(.-)"..pattern
  local le = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(tbl,cap)
    end
    le = e+1
    s, e, cap = str:find(fpat, le)
  end
  if le <= #str then
    cap = str:sub(le)
    table.insert(tbl, cap)
  end
  return tbl
end
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.setCursorPos(1,1)
term.clear()
print("DropX Server\n")
if not isDebug then
    if shell.openTab then
        shell.openTab("shell")
        print("You can still use the computer!\n")
    end
else
    printError("Debug Mode Enabled!")
end
while true do
    local sender,msg=rednet.receive()
    local sMsg = split(msg,"~!DSX!~")
    if isDebug then
        print(msg)
        --print(sMsg)
    end
    if not fs.exists(path..sender) or not fs.isDir(path..sender) then
        fs.makeDir(path..sender)
        print("Created folder for: "..sender)
    end
    if sMsg[1] == "@put" and sMsg[2] and sMsg[3] then
        file=fs.open(path..sender.."/"..sMsg[2],"w")
        if file then
            file.write(sMsg[3])
            file.close()
            rednet.send(sender,"Saved "..sMsg[2].." to server.")
            print(sender..": saved file: "..sMsg[2])
        else
            printError("Cannot open: "..path..sender)
            rednet.send(sender,"An error occored on the server. Try again later, or contact the owner.")
        end
    elseif sMsg[1] == "@get" and sMsg[2] then
        file = fs.open(path..sMsg[2].."/"..sMsg[3],"r")
        if file then
        rednet.send(sender,file.readAll())
        file.close()
        print(sender..": got file: "..sMsg[3])
        else
        printError("Cannot open: "..path..sender)
        rednet.send(sender,"An error occored on the server. Try again later, or contact the owner.")
        end
    elseif sMsg[1] == "@list" then
        if sMsg[2] then
            if not fs.exists(path..sMsg[2]) or not fs.isDir(path..sMsg[2]) then
                fs.makeDir(path..sMsg[2])
            end
            rednet.send(sender,textutils.serialize(fs.list(path..sMsg[2])))
            print(sender..": retreived files from: "..sMsg[2])
        else
            rednet.send(sender,textutils.serialize(fs.list(path..sender)))
            print(sender..": retreived their files.")
        end
    elseif sMsg[1] == "@delete" then
        if isDebug then print(path..sender.."/"..sMsg[2]) end
        if sMsg[2]:find("../") then rednet.send(sender,"Can't do that!") end
        if fs.exists(path..sender.."/"..sMsg[2]) then
            fs.delete(path..sender.."/"..sMsg[2])
            rednet.send(sender,"Deleted "..sMsg[2])
            print(sender..": deleted "..sMsg[2])
        end
    else
        print(sender..": "..textutils.serialize(sMsg))
    end
end
