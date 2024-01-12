local memoPath = vim.fn.expand('~/work/memo/docs/mkmemo')

local function createMemoFile(title)
  if IsEmpty(title) then
    title = vim.fn.input('memo title ? : ')
    if IsEmpty(title) then
      return
    end
  end
  os.execute("mkdir -p "..memoPath)
  local header = Implode({
    title
    , [[==========]]
  }, '\n')
  local filePath = Implode({
    memoPath
    , os.yyyymmddhhmmss()..'.md'
  }, '/')
  local file = io.open(filePath, "w")
  if file then
    file:write(header)
    file:close()
  end
  FileOpen(filePath)
end

local function createSelects(dir)
  local selects = {}
  local files = CommandResultAsTable('ls -t '..dir)
  Foreach(function (file)
    local filePath = dir..'/'..file
    local fileHandle, err = io.open(filePath, 'r')
    if fileHandle then
      local firstLine = fileHandle:read()
      fileHandle:close()
      table.insert(selects, {
        firstLine
        , function () FileOpen(filePath) end
      })
    else
      Dd('createSelects not file open. error code: '..err)
    end
  end, files)
  return selects
end

vim.keymap.set('n', 'mn', function ()
  createMemoFile()
end)

vim.keymap.set('n', 'ml', function ()
  OpenDduSelect(createSelects(memoPath))
end)
