local side

for _, siduha in pairs(rs.getSides()) do
  if peripheral.getType(siduha) == "modem" then
    side = siduha
  end
end

if side == nil then
  error("You need wireless modem!")
end

umail = {}

function split(str, pat)
  local t = { }
  local fpat = "(.-)"..pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(t,cap)
    end
    last_end = e+1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

function writeToFile()
  local file = io.open("archive", "w")
  if file then
    for i=1,#umail do
      file:write("!SP!"..umail[i].ID.."!SP!"..
          umail[i].from.."!SP!"..umail[i].time..
          "!SP!"..umail[i].msg)
    end
    file:close()
  end
end

function readFromFile()
  if(fs.exists("archive")) then
    local file = io.open("archive", "r")
    local fullstr = ""
    local fline = file:read()
    while fline do
      fullstr=fullstr..fline
      fline = file:read()
    end
    file:close()
    local t = split(fullstr, "!SP!")

    for i=1,#t,4 do
      table.insert(umail, {
        ID = tonumber(t[i]),
        from = t[i+1],
        time = tonumber(t[i+2]),
        msg = t[i+3]
      })
    end
    print("Added "..#umail.." messages.")
  end
end

function dispatchRequest(sender)
  resp="$RESPONSE"
  count=0
  mail=""
  idx=1
  while idx<table.getn(umail)+1 do
    if umail[idx].ID==sender then
      count=count+1
      mail=mail.."!SP!"..umail[idx].from
               .."!SP!"..umail[idx].time
               .."!SP!"..umail[idx].msg.." "
      table.remove(umail, idx)
      idx=idx-1
    end
    idx=idx+1
  end
  resp=resp..mail
  print("Sending Response:\n"..resp)
  rednet.send(sender, resp)
  writeToFile()
end

function addMail(msg, sender)
  print("Starting mail storage...")
  msg = string.gsub(msg, "$EMAIL", "")
  print("Header removed")
  print(msg)
  msgcpt = split(msg, "!SP!")
  print("String split")
  table.insert(umail, {
    ID = tonumber(msgcpt[1]),
    from = msgcpt[2],
    time = tonumber(msgcpt[3]),
    msg = msgcpt[4]
  })
  print("Message received- to "..msgcpt[1]..", from "
      ..msgcpt[2]..", at "..msgcpt[3])  
  rednet.send(sender, "$ACK")
  writeToFile()
  print("File archived")
end

local tArgs = { ... }
if #tArgs==0 then side = "bottom"
else side = tArgs[1] end

print("MAIL SERVER OPERATING SYSTEM")
print("Written and developed by NitrogenFingers")
print(string.rep("-", 50))
print("Opening server on "..os.getComputerID().."...")
print("Checking stored emails...")
readFromFile()

rednet.open(side)
print("Waiting for requests.")
while true do
  print("Message Count: "..table.getn(umail))
  local sender,msg = rednet.receive()
  print("Message received from "..sender..":"..msg)
  if string.find(msg, "$REQUEST") then
    print("Request format recognized- processing")
    dispatchRequest(sender)
  elseif string.find(msg, "$EMAIL") then
    print("Email format recognized- storing")
    addMail(msg, sender)
  else
    print("Format unrecognized- discarding")
  end
end
