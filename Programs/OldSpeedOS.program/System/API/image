function draw(startX,startY,image)
        local Colors = {
                ["0"] = 1,
                ["1"] = 2,
                ["2"] = 4,
                ["3"] = 8,
                ["4"] = 16,
                ["5"] = 32,
                ["6"] = 64,
                ["7"] = 128,
                ["8"] = 256,
                ["9"] = 512,
                ["a"] = 1024,
                ["b"] = 2048,
                ["c"] = 4096,
                ["d"] = 8192,
                ["e"] = 16384,
                ["f"] = 32768
        }
        local Pixels = {}
 
        local function convert(mode,color)
                if mode == "from cc" then
                        for key,value in pairs(Colors) do
                                if color == value then
                                        return key
                                end
                        end
                else
                        if color == "#" then
                                return "0"
                        else
                                return Colors[color]
                        end
                end
        end
 
        local function load(path)
                local file = fs.open(path,"r")
                local lineCounter = 1
                while true do
                        local line = file.readLine()
                        Pixels[lineCounter]={}
                        if line ~= nil then
                                for i=1,#line,3 do
                                        Pixels[lineCounter][(i+2)/3]={}
                                        Pixels[lineCounter][(i+2)/3]["symbol"] = string.sub(line,i,i)
                                        Pixels[lineCounter][(i+2)/3]["textColor"] = convert("to cc",string.sub(line,i+1,i+1))
                                        Pixels[lineCounter][(i+2)/3]["backColor"] = convert("to cc",string.sub(line,i+2,i+2))
                                end
                                lineCounter = lineCounter + 1
                        else
                                break
                        end
                end
                file.close()
        end
 
        load(image)
 
        for y=1,#Pixels do
                for x=1,#Pixels[y] do
                        if Pixels[y][x]["symbol"] ~= "#" then
                                term.setTextColor(Pixels[y][x]["textColor"])
                                term.setBackgroundColor(Pixels[y][x]["backColor"])
                                term.setCursorPos(startX+x-1,startY+y-1)
                                term.write(Pixels[y][x]["symbol"])
                        end
                end
        end
 
end