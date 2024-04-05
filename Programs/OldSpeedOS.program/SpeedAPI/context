function menu(...)
        --еякх вхякн юпслемрнб < 3 х рхо рперэецн юпцслемрю ме TABLE, рн бшдюрэ ньхайс он хяонкэгнбюмхч API
        if #arg < 3 or type(arg[3]) ~= "table" then error("Usage: menu(number x,number y,table Element1,table Element2, table Element3...) \nReturns: string Action \n<Element> structure: {string Name[, boolean isElementHidden][,number colorOfText]}") end
       
        --онксвемхе пюглепю лнмхрнпю
        local xSize, ySize = term.getSize()
 
        --опнярне нрнапюфемхе рейярю б сйюгюммшу йннпдхмюрюу я сйюгюммшл жбернл
        local function text(x,y,text1,color)
                term.setTextColor(color)
                term.setCursorPos(x,y)
                term.write(text1)
        end
 
        --янгдюмхе назейрнб б оюлърх (б мюьел яксвюе ймнонй, нрбевючыху гю бшанп щкелемрю лемч)
        local Objects = {}
        local function newObj(name,isHidden,xStart,xEnd,y)
                Objects[name]={}
                Objects[name]["isHidden"] = isHidden
                Objects[name]["xStart"] = xStart
                Objects[name]["xEnd"] = xEnd
                Objects[name]["y"] = y
        end
       
        --нопедекемхе яюлнцн дкхммнцн он йнк-бс яхлбнкнб щкелемрю лемч
        local theLongestElement = #arg[3][1]
        for i=3,#arg do
                if arg[i] ~= "-" and theLongestElement < #arg[i][1] then
                        theLongestElement = #arg[i][1]
                end
        end
 
        --нопедекемхе пюглепю лемч
        local xSizeOfMenu = theLongestElement + 4
        local ySizeOfMenu = #arg-2
 
        local xStartToDisplay = nil
        local yStartToDisplay = nil
 
        --пхянбюмхе йбюдпюрю я гюкхбйни
        local function square(x1,y1,width,height,color)
                local string = string.rep(" ",width)
                term.setBackgroundColor(color)
                for y=y1,(y1+height-1) do
                        term.setCursorPos(x1,y)
                        term.write(string)
                end
        end
 
        --нрпхянбйю пюгдекхрекъ б лемч
        local function drawSeparator(x,y,size)
                term.setTextColor(colors.lightGray)
                term.setCursorPos(x,y)
                term.write(string.rep("-",size))
        end
       
        --тсмйжхъ нрпхянбйх бяецн лемч
        local function drawMenu(xMenu,yMenu)
 
                --йнппейжхъ йннпдхмюрш лемч, врна гю йпюъ щйпюмю ме гюкегюкн
                if yMenu+ySizeOfMenu - 1  >= ySize then yMenu = yMenu - (yMenu+ySizeOfMenu - 1 - ySize) - 1 end
                if xMenu+xSizeOfMenu - 1  >= xSize then xMenu = xMenu - (xMenu+xSizeOfMenu - 1 - xSize) - 1 end
 
                --нопедекемхе рнвей ярюпрю нрнапюфемхъ рейярю б лемч
                xStartToDisplay = xMenu + 2
                yStartToDisplay = yMenu
 
                --нрпхянбйю ремх лемч
                square(xMenu+1,yMenu+1,xSizeOfMenu,ySizeOfMenu,colors.gray)
 
                --нрпхянбйю аекни ондкнфйх лемч
                square(xMenu,yMenu,xSizeOfMenu,ySizeOfMenu,colors.white)
 
                --жхйк оепеанпю бяеу щкелемрнб лемч, пюяялюрпхбюел дюммше н йюфднл
                for i=3,#arg do
                        --еякх бшапюммшу щкелемр ме ъбкъеряъ пюгдекхрекел, рн
                        if arg[i] ~= "-" then
                                --гюдюмхе ярюмдюпрмнцн жберю рейярю дкъ щкелемрю лемч
                                local contextColor = colors.black
                                --еякх юпцслемр_2 (яйпшрши/ме яйпшрши) х юпслемр_3 (жбер рейярю щкелемрю) дкъ пюяялюрпхбюелнцн щкелемрю ме сйюгюмш, рн
                                if arg[i][2] == nil and arg[i][3] == nil then
                                        contextColor = colors.black
                                --еякх юпцслемр 2 = FALSE х юпцслемр 3 ме сйюгюм, рн
                                elseif arg[i][2] == false and arg[i][3] == nil then
                                        contextColor = colors.black
                                --еякх юпцслемр 2 = FALSE х юпцслемр 3 сйюгюм, рн
                                elseif arg[i][2] == false and arg[i][3] ~= nil then
                                        contextColor = arg[i][3]
                                --еякх юпцслемр 2 = TRUE, рн щкелемр яйпшр
                                elseif arg[i][2] == true then
                                        contextColor = colors.lightGray
                                end
 
                                --нрнапюфемхе рейярю щкелемрю б яюлнл лемч
                                text(xStartToDisplay,yStartToDisplay+i-3,arg[i][1],contextColor)
                                --янгдюмхе назейрю щкелемрю б оюлърх, врнаш онрнл хлерэ й мелс днярсо
                                newObj(arg[i][1],arg[i][2],xMenu,xMenu+xSizeOfMenu-1,yStartToDisplay+i-3)
 
                        --ю еякх бяе-рюйх ъбкъеряъ, рн
                        else
                                drawSeparator(xMenu,yStartToDisplay+i-3,xSizeOfMenu)
                        end
                end
        end
       
        --ярюпр опнцпюллш, пхясел лемч
        drawMenu(arg[1],arg[2])
 
        --нрякефхбюмхе йкхйю лшьх
        local event,side,xClick,yClick = os.pullEvent()
        if event == "monitor_touch" then side = 1 end
        if event == "mouse_click" or event == "monitor_touch" then
                --оепеанп бяеу щкелемрнб люяяхбю назейрнб б оюпе ян гмювемхел щкелемрю (йкчв = гмювемхе, KEY = VAL)
                for key,val in pairs(Objects) do
                        --еякх лш йкхймскх мю назейр, х щрнр назейр ме ъбкъеряъ яйпшршл, рн
                        if xClick >= Objects[key]["xStart"] and xClick <= Objects[key]["xEnd"] and yClick == Objects[key]["y"] and Objects[key]["isHidden"] == false or xClick >= Objects[key]["xStart"] and xClick <= Objects[key]["xEnd"] and yClick == Objects[key]["y"] and Objects[key]["isHidden"] == nil then
                                --мюпхянбюрэ цнксане бшдекемхе щкелемрю лемч
                                for i=Objects[key]["xStart"],Objects[key]["xEnd"] do
                                        paintutils.drawPixel(i,Objects[key]["y"],colors.blue)
                                end
                                --нрнапюгхрэ рнр фе рейяр, рнкэйн аекшл жбернл
                                text(xStartToDisplay,Objects[key]["y"],key,colors.white)
                                --фдюрэ мейнрнпне бпелъ
                                sleep(0.3)
                                --бепмсрэ гмювемхе KEY (рн еярэ гмювемхе бшапюммнцн щкелемрю лемч) х гюбеьхрэ опнцпюллс лемч
                                return key
                        end
                        --ю еякх мхйюйни щкелемр лемч ме ашк бшапюм, рн тсмйжхъ бепмер NIL
                end
        end
end