--[[
	Главный файл операционной системы. Именно тут происходят
	все действия и появляется возможность взаимодействия
	пользователя с ОС.
]]

-----------------------------------------------------------------------------------------------------------------------------------
-- Всякие нужные переменные

SpeedOSVersion = '...' -- версия ОС. для начала мы ее не определили

local x = 1 -- начальный пиксель по оси X, с которого рисуется весь экран
local y = 1 -- начальный пиксель по оси Y, с которого рисуется весь экран
local m = 4 

-- Далее остальные системные переменные, к которым комментарии излишни.

local needsDisplay = true
local drawing = false

local updateTimer = nil
local clockTimer = nil
local desktopRefreshTimer = nil

-----------------------------------------------------------------------------------------------------------------------------------
-- Основные таблицы с программами и их содержимым. Здесь задаются параметры последней открытой программы(пока это просто заготовка)

Current = {
	Clicks = {},
	Menu = nil,
	Programs = {},
	Window = nil,
	CursorPos = {1,1},
	CursorColour = colours.white,
	Program = nil,
	Input = nil,
	IconCache = {},
	CanDraw = true,
	AllowAnimate = true
}

Events = {
	
}

InterfaceElements = {
	
}

-----------------------------------------------------------------------------------------------------------------------------------
-- Функция, которая обращается к остальным АПИ и начинает рисовать рабочий стол

function ShowDesktop()
	Desktop.LoadSettings() -- подгрузка настроек расположения файлов
	Desktop.RefreshFiles() -- обновление файлов
	Desktop.SaveSettings() -- сохранение настроек
	
	RegisterElement(Overlay) -- регистрация остального говна для десктопа
	Overlay:Initialise() -- инициализация говна
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Начальная подгрузка остальных подпрограмм

function Initialise()
	-- Регистрация эвентов
	EventRegister('mouse_click', TryClick) -- клик мыши
	EventRegister('mouse_drag', TryClick) -- движение мыши с зажатой кнопкой
	EventRegister('monitor_touch', TryClick) -- тыканье по монитору
	EventRegister('key', HandleKey) -- кнопка
	EventRegister('char', HandleKey) -- тоже кнопка, но эта функция возвращает символ, на который пользователь тыкнул
	EventRegister('timer', Update) -- таймер задержки
	EventRegister('http_success', AutoUpdateRespose) -- успешный запрос в интернет
	EventRegister('http_failure', AutoUpdateFail) -- провальный запрос в интернет

	ShowDesktop() -- рисуем десктоп
	Draw() -- и его приблуды
	clockTimer = os.startTimer(0.8333333) -- задержка между обновлением часов(НЕ ИЗМЕНЯТЬ!)
	desktopRefreshTimer = os.startTimer(5) -- задержка между обновлениями рабочего стола
	local h = fs.open('System/.version', 'r') -- открываем файл с версией ОС
	SpeedOSVersion = h.readAll() -- записываем в нашу переменную версию ОС
	h.close() -- закрываем файл

	CheckAutoUpdate() -- проверяем авто обновления

	EventHandler() -- начинаем ждать действий пользователя с мышью, клавиатурой, монитором и т. д.
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Автообновления и удобное форматирование строк для этого

local checkAutoUpdateArg = nil -- временный аргумент для обновления

function CheckAutoUpdate(arg)
	checkAutoUpdateArg = arg -- дублируем аргумент в другую переменную
	if http then -- если включен HTTP
		http.request('https://api.github.com/repos/ma3rxofficial/ComputerCraft/releases#') -- отправляем запрос прямиком на мой гитхаб для проверки новых версий
	elseif arg then -- если уж не включен HTTP...
		ButtonDialogueWindow:Initialise("HTTP Not Enabled!", "Turn on the HTTP API to update.", 'Ok', nil, function(success)end):Show() -- то говорим, что для обновления он должен быть включен. а хули нет?
	end
end

-- Функция сплитирования строк
function split(str, sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        str:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields -- результат отдаем короч. что мне еще сказать?
end

-- Получаем адекватный вид версии в виде массива из чисел благодаря нашей функции split. К примеру версия 1.4.3, тогда эта функция вернет массив с числами 1, 4 и 3
function GetSematicVersion(tag)
	tag = tag:sub(2)
	return split(tag, '.')
end

--Возвращает true, если первая указанная версия новее второй указанной версии
function SematicVersionIsNewer(version, otherVersion)
	if version[1] > otherVersion[1] then
		return true
	elseif version[2] > otherVersion[2] then
		return true
	elseif version[3] > otherVersion[3] then
		return true
	end
	return false
end

-- Недописанная функция. По задумке выскакивает окошко о том, что обновление провалено нахуй!
function AutoUpdateFail(event, url, data)
	return false
end

-- Функция, которая отправляет запрос на репозиторий с ОС
function AutoUpdateRespose(event, url, data)
	if url ~= 'https://api.github.com/repos/ma3rxofficial/ComputerCraft/releases#' then -- шлем пользователя нахуй, если URL не нашего репозитория, защита от подделок
		return false
	end
	
	os.loadAPI('/System/JSON') -- подгружаем АПИ
	if not data then -- если результат мы от гитхаба не получили, то опять же - шлем пользователя нахуй
		return
	end
	
	local releases = JSON.decode(data.readAll()) -- получаем все релизы нашей ОС с гитхаба используя ранее загруженное АПИ JSON
	os.unloadAPI('JSON') -- разгружаем JSON, он нам больше не понадобится
	if not releases or not releases[1] or not releases[1].tag_name then -- если все плохо
		if checkAutoUpdateArg then -- не получилось подключиться к гитхабу
			ButtonDialogueWindow:Initialise("Update Check Failed", "Check your connection and try again.", 'Ok', nil, function(success)end):Show()
		end
		return
	end
	local latestReleaseTag = releases[1].tag_name

	if SpeedOSVersion == latestReleaseTag then -- если у пользователя последняя версия ОС(по версии с гитхаба)
		if checkAutoUpdateArg then
			ButtonDialogueWindow:Initialise("Up to date!", "SpeedOS is up to date!", 'Ok', nil, function(success)end):Show()
		end
		return
	elseif SematicVersionIsNewer(GetSematicVersion(latestReleaseTag), GetSematicVersion(SpeedOSVersion)) and Settings.GetValues('AutoUpdate')['AutoUpdate'] == true then -- в противном случае - запускаем отдельную прогу для обновления
		LaunchProgram('/System/Programs/Update.program/startup', {}, 'Update SpeedOS')
	end
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Функции для работы с программами. На этом этапе многозадачность системы проявляет себя 

function LaunchProgram(path, args, title) -- функция запуска программки
	Log.i("Starting program: "..title.." ("..path..")") -- логируем, какую программу и из какой папки мы запустили
	Animation.RectangleSize(Drawing.Screen.Width/2, Drawing.Screen.Height/2, 1, 1, Drawing.Screen.Width, Drawing.Screen.Height, colours.grey, 0.3, function() -- отображаем анимацию
		if Current.Menu then -- своеобрзаный костыль, для защиты от дублирования ОС в программе в самой ОС, а потом в этой ОС в программе запускаем опять ОС в программе и т.д. короче - ебучая рекурсия!
			Current.Menu:Close()
		end
			
		Program:Initialise(shell, path, title, args) -- инициализация самой программки
		Overlay.UpdateButtons() -- обновляем верхний тулбар
		Overlay:Draw() -- и перерисовываем его
		Current.Program.AppRedirect:Draw() -- рисуем переключение на приложение
	end)

	Log.i("Program "..title.." ("..path..") finished") -- пишем о том, что прога закрылась или завершилась принудительно, что из этого - мне похуй.

	-- Функция автовыгрузки АПИ. Может привести к крашам и визуальным багам, так что это сугубо бета-версия. Я предупредил.
	os.loadAPI("System/API/Settings") -- подгружаем АПИ. да, выглядет как говно, обращение к АПИ на середине кода, но мне не привыкать. а что было в SpeedOS 1.3?
	
	if Settings.GetValues('AutoAPIUnloading')['AutoAPIUnloading'] == true then -- собственно, если включена автовыгрузка АПИ

		for _, apishnik in pairs(fs.list("SpeedAPI")) do -- то мы их поочередно выгружаем
			os.unloadAPI("SpeedAPI/"..apishnik)

			-- Если API был в оперативной памяти, то тоже разгружаем
			if _G[apishnik] then
				_G[apishnik] = nil
			end

			Log.i("API "..apishnik.." unloaded (Auto API Unloading)") -- и логируем это в лог-файл
		end
	end

end

-- Функция для переключения на другую программу
function SwitchToProgram(newProgram, currentIndex, newIndex)
	if Current.Program then -- если у нас открыта другая программа
		local direction = 1 -- первоначальное направление, в которое будет производиться наша анимашка
		if newIndex < currentIndex then -- проверяем, какой номер у вкладки открытой и открывающейся программки
			direction = -1 -- но если номер открывающейся программы меньше индекса открытой программы, то направление изменяется в обратную сторону
		end
		Animation.SwipeProgram(Current.Program, newProgram, direction) -- ну и сама анимашка с полученным нами направлением
	else -- если же ситуация происходит абсолютно наоборот
		Animation.RectangleSize(Drawing.Screen.Width/2, Drawing.Screen.Height/2, 1, 1, Drawing.Screen.Width, Drawing.Screen.Height, colours.grey, 0.3, function() -- то просто рисуем открытие новой проги
			Current.Program = newProgram
			Overlay.UpdateButtons()
			Current.Program.AppRedirect:Draw()
			Draw()
		end)
	end
end

-- Функция обновления часов и рабочего стола
function Update(event, timer)
	if timer == updateTimer then -- обновление содержимого во вкладке с программой 
		if needsDisplay then -- если прям невтерпеж отображать, да и это уже сам пользователь указал
			Draw() -- то все же рисуем, похуй на вас!
		end
	elseif timer == clockTimer then -- если мы обновляем часики
		clockTimer = os.startTimer(0.8333333) -- то мы их обновляем, иди нахуй! (новая задержка)
		Draw() -- рисуем
	elseif timer == desktopRefreshTimer then -- обновление раб. стола
		Desktop:RefreshFiles() -- обновляем файлы
		desktopRefreshTimer = os.startTimer(3) -- и снова задержка до обновления
	elseif timer == Desktop.desktopDragOverTimer then -- если пользователь перемещает файлы, то рисуем их поверх задержки обновления файлов на десктопе
		Desktop.DragOverUpdate() -- это и делаем, михалыч!
	else -- если уж нет
		Animation.HandleTimer(timer) -- новая задержка анимашки
		for i, program in ipairs(Current.Programs) do -- и в каждой проге вызываем задержку, типо мульизадачность!
			for i2, _timer in ipairs(program.Timers) do
				if _timer == timer then
					program:QueueEvent('timer', timer) -- сам вызов
				end
			end
		end
	end
end

-- Отрисовка программы
function Draw()
	if not Current.CanDraw then -- если в проге указано, что ее не рисовать, то, соответственно, не рисуем и идем пить чай
		return
	end

	drawing = true -- ДАААА МЫ РИСУЕМ!!!!
	Current.Clicks = {}

	if Current.Program then -- если есть открытая программа(хоть одна)
		--Current.Program.AppRedirect:Draw() -- ничего. но как болванка - оставлю
	else -- в противном случае, если есть только раб. стол
		Desktop:Draw() -- рисуем десктоп
		term.setCursorBlink(false) -- и останавливаем мигание курсора(фикс бага с часами)
	end

	for i, elem in ipairs(InterfaceElements) do -- рисуем элементы интерфейса
		if elem.Draw then
			elem:Draw()
		end
	end

	if Current.Window then -- если у нас открыто окошко программы
		Current.Window:Draw() -- то мы ее отрисовываем
	end

	Drawing.DrawBuffer() -- и рисуем все из буффера!

	term.setCursorPos(Current.CursorPos[1], Current.CursorPos[2]) -- выставляем параметры курсора
	term.setTextColour(Current.CursorColour) -- и цвет текста

	drawing = false -- МЫ БОЛЬШЕ НЕ РИСУЕМ (((((((((((((
	needsDisplay = false -- и отображать ничего не надо, и плакали все наши программки

	if not Current.Program then -- если прога не открыта
		updateTimer = os.startTimer(0.05) -- то увеличиваем задержку. Предпологается, что пользователь AFK.
	end
end

MainDraw = Draw -- дублирование функции в переменную MainDraw

-----------------------------------------------------------------------------------------------------------------------------------
-- Работа с интерфейсом тулбара

-- Добавить элемент интерфейса
function RegisterElement(elem) 
	table.insert(InterfaceElements, elem)
end

-- Убрать элемент интерфейса
function UnregisterElement(elem)
	for i, e in ipairs(InterfaceElements) do
		if elem == e then
			InterfaceElements[i] = nil
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Крутые функции с мышью.

-- Регистрация кликов. Каждый клик заносится в массив
function RegisterClick(elem)
	table.insert(Current.Clicks, elem)
end

-- Проверяем эвенты пользователя на КЛИК
function CheckClick(object, x, y)
	local pos = GetAbsolutePosition(object)
	if pos.X <= x and pos.Y <= y and  pos.X + object.Width > x and pos.Y + object.Height > y then
		return true
	end
end

-- Функция "делания" клика
function DoClick(event, object, side, x, y)
	if object and CheckClick(object, x, y) then
		return object:Click(side, x - object.X + 1, y - object.Y + 1)
	end	
end

-- Проверка на возможность клика
function TryClick(event, side, x, y)
	if Current.Menu and DoClick(event, Current.Menu, side, x, y) then
		Draw()
		return
	elseif Current.Window then
		if DoClick(event, Current.Window, side, x, y) then
			Draw()
			return
		else
			Current.Window:Flash()
		end
	else
		if Current.Menu and not (x < 6 and y == 1) then
			Current.Menu:Close()
			NeedsDisplay()
		end
		if Current.Program and y >= 2 then
			Current.Program:Click(event, side, x, y-1)
		elseif y >= 2 then
			Desktop.Click(event, side, x, y)
		end

		for i, object in ipairs(Current.Clicks) do
			if DoClick(event, object, side, x, y) then
				Draw()
				return
			end		
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Клавиатура

-- Ждем тыкания на клавишу какую-то
function HandleKey(...)
	local args = {...}
	local event = args[1]
	local keychar = args[2]
	
	--REMOVE THIS AT RELEASE!
	if keychar == '\\' then
		--os.reboot()
	end

	if Current.Input then
		if event == 'char' then
			Current.Input:Char(keychar)
		elseif event == 'key' then
			Current.Input:Key(keychar)
		end
	elseif Current.Program then 
		Current.Program:QueueEvent(...)
	elseif Current.Window then
		if event == 'key' then
			if keychar == keys.enter then
				if Current.Window.OkButton then
					Current.Window.OkButton:Click(1,1,1)
					NeedsDisplay()
				end
			elseif keychar == keys.delete or keychar == keys.backspace then
				if Current.Window.CancelButton then
					Current.Window.CancelButton:Click(1,1,1)
					NeedsDisplay()
				end
			end
		end
	else
		if event == 'key' then
			if keychar == keys.enter then
				Desktop.OpenSelected()
			elseif keychar == keys.delete or keychar == keys.backspace then
				Desktop.DeleteSelected()
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Позиция объекта относительно всего уже отрисованного

function GetAbsolutePosition(obj)
	if not obj.Parent then
		return {X = obj.X, Y = obj.Y}
	else
		local pos = GetAbsolutePosition(obj.Parent)
		local x = pos.X + obj.X - 1
		local y = pos.Y + obj.Y - 1
		return {X = x, Y = y}
	end
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Сбросить переменную needsDisplay(в состояние "true")

function NeedsDisplay()
	needsDisplay = true
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Спящий режим(не автоматический!)

function Sleep()
	Drawing.Clear(colours.black)
	Drawing.DrawCharactersCenter(1, -1, nil, nil, 'Your computer is sleeping to reduce server load.', colours.cyan, colours.black)
	Drawing.DrawCharactersCenter(1, 1, nil, nil, 'Click anywhere to wake it up.', colours.lightGrey, colours.black)
	Drawing.DrawBuffer()
	os.pullEvent('mouse_click')

	Draw()
	updateTimer = os.startTimer(0.05)
	clockTimer = os.startTimer(0.8333333)
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Управление питанием компьютера

-- Выключить комп(если указать true в аргументах, то компьютер перезагружается)
function Shutdown(restart)
	local success = true -- программы не открыты, можноперезагружаться
	for i, program in ipairs(Current.Programs) do -- проверяем программы на возможность их завершения
		if not program:Close() then
			success = false -- если какую-то программу нельзя закрыть, то отключение может быть невозможно
		end
	end

	if success and not restart then -- просто отключаем компьютер
		Log.i("Shutting down...")
		windows.tv(0) -- и воспроизводим анимацию красивенькую
		os.shutdown()
	elseif success then -- перезагрузка
		Log.i("Rebooting...")
		windows.tv(0) -- анимация красивая
		os.reboot()
	else -- если нельзя что-то там закрыть
		Current.Program = nil
		Overlay.UpdateButtons()
		local shutdownLabel = 'shutdown'
		local shutdownLabelCaptital = 'Shutdown'
		if restart then
			shutdownLabel = 'restart'
			shutdownLabelCaptital = 'Restart'
		end

		ButtonDialogueWindow:Initialise("Programs Still Open", "Some programs stopped themselves from being closed, preventing "..shutdownLabel..". Save your work and close them or click 'Force "..shutdownLabelCaptital.."'.", 'Force '..shutdownLabelCaptital, 'Cancel', function(btnsuccess) -- ну говорим об этом, шо сказать :D
			if btsuccess and not restart then -- отключение
				Log.i("Shutting down...")
				windows.tv(0) -- и воспроизводим анимацию красивенькую
				os.shutdown()
			elseif btnsuccess then -- перезагрузка
				Log.i("Rebooting...")
				windows.tv(0) -- анимация красивая
				os.reboot()
			end
		end):Show()
	end
end

function Restart() -- простая функция для перезагрузки
	Shutdown(true)
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Хуйня с эвентами. Нечего больше сказать.

-- "Зарегистрировать эвент". По сути, эта функция добавляет в массив эвент и функцию, которая будет производиться, когда этот эвент произойдет
function EventRegister(event, func)
	if not Events[event] then -- если переменная массива пустая
		Events[event] = {} -- создаем ее
	end

	table.insert(Events[event], func) -- добавляем в массив эвент и функцию
end

-- Регистратор эвентов для всех программ в реальном времени
function ProgramEventHandle()
	for i, program in ipairs(Current.Programs) do -- перебираем все открытые программы
		for i, event in ipairs(program.EventQueue) do -- перебираем всю очередь эвентов одной программы
			program:Resume(unpack(event)) -- отдаем поочередно каждый эвент в программу
		end
		program.EventQueue = {} -- очищаем очередь эвентов
	end
end

-- Регистратор эвентов всего компьютера в реальном времени
function EventHandler()
	while true do -- бесконечный цикл
		ProgramEventHandle() -- запускаем регистратор эвентов программ
		local event = { coroutine.yield() } -- переменная эвента в виде массива
		local hasFound = false -- найден ли эвент

		if Events[event[1]] then -- перебираем эвенты
			for i, e in ipairs(Events[event[1]]) do -- перебираем эвенты вновь
				if e(event[1], event[2], event[3], event[4], event[5]) == false then -- если в массиве с эвентом есть переменные, но они пустые, или их нет
					hasFound = false -- это значит, что эвент - пустой массив, т.е. он не найден
				else -- в противном случае(информация об эвенте найдена)
					hasFound = true -- это значит, что ивент найден
				end
			end
		end

		if not hasFound and Current.Program then -- если никаких эвентов не было найдено и есть хоть одна открытая программа
			Current.Program:QueueEvent(unpack(event)) -- то пускаем ей новые эвенты
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------
