
-- Распечатка того, что программка щас делает и отправляем запросы на GitHub

print('Downloading releases list...', 'Determining Latest Version') -- скачиваем список релизов
local releases = downloadJSON('https://api.github.com/repos/'..Settings.GitHubUsername..'/'..Settings.GitHubRepoName..'/releases') -- само скачивания(с помощью JSON)
local latestReleaseTag = releases[1].tag_name -- получаем последний релиз
print('Latest release: '..latestReleaseTag) -- печатаем последний релиз
print('Downloading refs...', 'Optaining Latest Version URL') -- пишем, что получаем URL последней версии
local refs = downloadJSON('https://api.github.com/repos/'..Settings.GitHubUsername..'/'..Settings.GitHubRepoName..'/git/refs') -- получили нахуй
local latestReleaseSha = '' -- SHA-код последней версии
for i, v in ipairs(refs) do -- перебираем устойчивую файловую систему поочереди
	if v.ref == 'refs/tags/'..latestReleaseTag then -- выбираем последний релиз
		latestReleaseSha = v.object.sha -- и наконец получаем SHA-код последней версии
	end
end

print('Downloading tree for SHA: '..latestReleaseSha, 'Downloading File Listing') -- печатаем, что скачиваем список файлов последнего релиза
local tree = downloadJSON('https://api.github.com/repos/'..Settings.GitHubUsername..'/'..Settings.GitHubRepoName..'/git/trees/'..latestReleaseSha..'?recursive=1').tree -- дерево файлов получено

-----------------------------------------------------------------------------------------------------------------------------------
-- Система ЧЕРНОГО списка файлов в версии

-- Массив черного списка
local blacklist = {
    '/.gitignore',
    '/README.md',
    '/TODO',
}

-- Простейшая функция блеклиста, аналогичная в программе Radio есть и подобных
function isBlacklisted(path) 
	for i, item in ipairs(blacklist) do -- перебираем элементы в массиве черного списка
		if item == path then -- если файл совпадает с каким-то элементом
			return true -- возвращаем что да, он в ЧЕРНОООООООООМММ списке
		end
	end
	return false -- ну если ничего не нашли, то файл, очевидно, не в списке
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Настройка кол-ва байтов

Settings.TotalFiles = 0 -- кол-во файлов
Settings.TotalBytes = 0 -- кол-во байтов(ДАЖЕ НЕ ДУМАЙТЕ ЕГО ПОСЧИТАТЬ)

for i, v in ipairs(tree) do -- перебираем все в дереве файлов
	if not isBlacklisted(Settings.InstallPath..v.path) and v.size then -- если файл не в черном списке и у него есть какой-то размер
		Settings.TotalBytes = Settings.TotalBytes + v.size -- добавляем его размер в байтах к общему кол-ву байтов
		Settings.TotalFiles = Settings.TotalFiles + 1 -- добавляем один файл в кол-во всех файлов
	end
end

Settings.DownloadedBytes = 0 -- кол-во скачанных байтов с гитхаба
Settings.DownloadedFiles = 0 -- кол-во уже полноценных файликов с гитхаба

-----------------------------------------------------------------------------------------------------------------------------------
-- Функции скачивания

function downloadBlob(v)
	if isBlacklisted(Settings.InstallPath..v.path) then -- если файл в блеклисте
		return -- то хуй вам, а не файл!
	end
	if v.type == 'tree' then -- если тип этого файла - это дерево(т. е. он папка)
		print('Making folder: '..'/.update/'..Settings.InstallPath..v.path, 'Making folder: '..'/.update/'..Settings.InstallPath..v.path) -- печатаем, шо создаем папку
		fs.makeDir('/.update/'..Settings.InstallPath..v.path) -- само создание папки
	else
		print('(' .. Settings.DownloadedBytes .. 'B/' .. Settings.TotalBytes .. 'B) Downloading file: '..Settings.InstallPath..v.path, Settings.InstallPath..v.path, 'Downloading files...') --  печатаем, что файл скачивается
		local f = http.get(('https://raw.github.com/'..Settings.GitHubUsername..'/'..Settings.GitHubRepoName..'/'..latestReleaseTag..Settings.InstallPath..v.path):gsub(' ','%%20')) -- отправляем запрос на гитхаб с путем до файла
		if not f then -- если не получилось отправить запрос или нет ответа
			error('Downloading failed, try again. '..('https://raw.github.com/'..Settings.GitHubUsername..'/'..Settings.GitHubRepoName..'/'..latestReleaseTag..Settings.InstallPath..v.path):gsub(' ','%%20')) -- печатаем, что все труба
		end
		local h = fs.open('/.update/'..Settings.InstallPath..v.path, 'w') -- открываем файл по пути
		h.write(f.readAll()) -- вставляем туда содержимое файла с гитхаба
		h.close() -- закрываем локальный файл на компьютере пользователя

		if v.size then -- если у файла есть размер
			Settings.DownloadedBytes = Settings.DownloadedBytes + v.size -- добавляем к кол-ву скачанных байт размер этого файла
		end

		Settings.DownloadedFiles = Settings.DownloadedFiles + 1 -- и также с кол-вом файлов
		Settings.UpdateFunction() -- обновляем
	end
	sleep(0) -- фикс "too long without yielding"
end

-- Массив загрузок
local downloads = {}

fs.makeDir('/.update/') -- создаем папку обновления

for i, v in ipairs(tree) do
	table.insert(downloads, function()downloadBlob(v)end) -- вставляем в массив файл из дерева файлов
	sleep(0) -- фикс "too long without yielding"
end

-----------------------------------------------------------------------------------------------------------------------------------
-- Все прочие подготовки к обновлению системы

Settings.UpdateFunction() -- обновляем
parallel.waitForAll(unpack(downloads)) -- разделяем массив загрузки на отдельные переменные(прям мини-мини)

-- Пишем версию из гитхаба в файлы .version и System/.version 
local h = fs.open('/.update/.version', 'w') 
h.write(latestReleaseTag)
h.close()

local h = fs.open('/.update/System/.version', 'w')
h.write(latestReleaseTag)
h.close()

-----------------------------------------------------------------------------------------------------------------------------------
