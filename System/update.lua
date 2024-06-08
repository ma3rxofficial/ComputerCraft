

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
