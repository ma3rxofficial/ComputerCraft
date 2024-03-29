function generateMap()
    for y=1,sizeY,1 do
        for x=1,sizeX,1 do
            if map[y][x] == nil then
                map[y][x] = {}
                local variant = math.random(1,3)
                local type = math.random(1,90)
                local inventory = {}
                if type == math.random(1,90) then
                    type = "shop"
                else
                    type = math.random(1,90)
                    if type == math.random(1,60) then
                        type = "portal"
                    else
                        type = math.random(1,50)
                        if type == math.random(1,50) then
                            type = "lava"
                        else
                            type = math.random(1,300)
                            if type == math.random(1,300) then
                                type = "ushop"
                            else
                                type = math.random(1,250)
                                if type == math.random(1,250) then
                                    type = "oshop"
                                else
                                    type = "room"
                                end
                            end
                        end
                        type = math.random(1,300)
                        if type == math.random(1,300) then
                            type = "ushop"
                        else
                            type = math.random(1,250)
                            if type == math.random(1,250) then
                                type = "oshop"
                            else
                                type = "room"
                            end
                        end
                    end
                end
                local wC1,wC2 = math.random(1,rarity.water),math.random(1,rarity.water)
                local fC1,fC2 = math.random(1,rarity.food),math.random(1,rarity.food)
                local cC1,cC2 = math.random(1,rarity.coins),math.random(1,rarity.coins)
                if wC1 == wC2 then
                    table.insert(inventory,"water")
                end
                if fC1 == fC2 then
                    table.insert(inventory,"food")
                end
                if cC1 == cC2 then
                    table.insert(inventory,"coin")
                end
                local dark = false
                if type ~= "lava" or tonumber(difficulity) > 1 then
                    local t = math.random(1,3)
                    if t == math.random(1,2) then
                        dark = true
                    end
                end
                local form = {top = false, left = false, inventory = inventory, type = type, dark = dark}
                if variant == 1 then
                    form.top = true
                    map[y][x] = form
                elseif variant == 2 then
                    form.left = true
                    map[y][x] = form
                elseif variant == 3 then
                    form.left = true
                    form.top = true
                    map[y][x] = form
                end
            end
        end
    end
end