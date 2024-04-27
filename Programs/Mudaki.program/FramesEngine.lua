kadr_quantity = 4 -- сколько всего кадров
kadr = 1 -- с какого кадра начнем воспрозведение
 
while true do
  event, key = os.pullEvent()
  
  if event == "key" and key == keys.right then -- следующий кадр
    if kadr < kadr_quantity then
      kadr = kadr + 1
    else
      kadr = 1
    end
  elseif event == "key" and key == keys.left then -- предыдущий кадр
    if kadr == 1 then
      kadr = kadr_quantity
    else
      kadr = kadr - 1
    end
  end
  
  if event == "mouse_click" then  -- следующий кадр но с мышки
    if kadr < kadr_quantity then
      kadr = kadr + 1
    else
      kadr = 1
    end
  end
  
  print("FRAME #"..tostring(kadr)) -- печатаем какой щас кадр
end
