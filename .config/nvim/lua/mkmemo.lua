local memoPath = vim.fn.expand('~/work/memo/docs/mkmemo')

local function createMemoFile(title)
  if string.isEmpty(title) then
    title = vim.fn.input('memo title ? : ')
    if string.isEmpty(title) then
      return
    end
  end
  os.execute("mkdir -p "..memoPath)
  local header = string.implode({
    title
    , [[==========]]
  }, '\n')
  local filePath = string.implode({
    memoPath
    , os.yyyymmddhhmmss()..'.md'
  }, '/')
  local file = io.open(filePath, "w")
  if file then
    file:write(header)
    file:close()
  end
  vim.fn.openFileInTab(filePath)
end

local function createSelects(dir)
  local selects = {}
  local files = table.commandResultAsTable('ls -t '..dir)
  table.myForeach(function (file)
    local filePath = dir..'/'..file
    local fileHandle, err = io.open(filePath, 'r')
    if fileHandle then
      local firstLine = fileHandle:read()
      fileHandle:close()
      table.insert(selects, {
        firstLine
        , function () vim.fn.openFileInTab(filePath) end
      })
    else
      os.dump('createSelects not file open. error code: '..err)
    end
  end, files)
  return selects
end

vim.keymap.set('n', 'mn', function ()
  createMemoFile()
end)

vim.keymap.set('n', 'ml', function ()
  vim.fn.openDduSelect(createSelects(memoPath))
end)
