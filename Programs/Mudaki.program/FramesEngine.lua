kadr_quantity = 4 -- сколько всего кадров
kadr = 1 -- с какого кадра начнем воспрозведение
 
while true do
  event, key = os.pullEvent()
  
  if event == "key" and key == keys.right or event == "mouse_click" and key == 1 or event == "mouse_drag" and key == 1 or event == "mouse_scroll" and key == -1 then -- следующий кадр
    if kadr < kadr_quantity then
      kadr = kadr + 1
    else
      kadr = 1
    end
  elseif event == "key" and key == keys.left or event == "mouse_click" and key == 2 or event == "mouse_drag" and key == 2 or event == "mouse_scroll" and key == 1 then -- предыдущий кадр
    if kadr == 1 then
      kadr = kadr_quantity
    else
      kadr = kadr - 1
    end
  end
  
  print("FRAME #"..tostring(kadr)) -- печатаем какой щас кадр
end
