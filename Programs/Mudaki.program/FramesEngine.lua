kadr_quantity = 4
kadr = 1

while true do
  event, key = os.pullEvent()
  
  if event == "key" and key == keys.right then
    if kadr < kadr_quantity then
      kadr = kadr + 1
    else
      kadr = 1
    end
  elseif event == "key" and key == keys.left then
    if kadr == 1 then
      kadr = kadr_quantity
    else
      kadr = kadr - 1
    end
  end
  
  if event == "mouse_click" then
    if kadr < kadr_quantity then
      kadr = kadr + 1
    else
      kadr = 1
    end
  end
  
  print("FRAME "..tostring(kadr))
end
