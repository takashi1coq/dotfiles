
return {
  has_extension = function (filePath, extensionsTable)
    for _, extension in ipairs(extensionsTable) do
      local fileEnd = filePath:sub(-#extension)
      if extension == fileEnd then
        return true
      end
    end
    return false
  end
  , current_file_name = function ()
    return vim.fn.expand('%:t')
  end
  , current_file_path = function ()
    return vim.fn.expand('%:p')
  end
  , current_directory_path = function ()
    return vim.fn.expand('%:p:h')
  end
  , current_relative_path = function ()
    return vim.fn.fnamemodify(_G.TKC.utils.file.current_file_path(), ":.")
  end
  , current_file_stem = function ()
    local currentFileName = _G.TKC.utils.file.current_file_name()
    return _G.TKC.utils.table.string_to_table(currentFileName, [[.]])[1]
  end
  , project_name = function ()
    return vim.fs.basename(vim.fn.getcwd())
  end
  , get_file_info_in_path = function (path, result)
    result = result or {}
    path = vim.fn.expand(path)
    local fs = vim.loop.fs_scandir(path)
    if not fs then return result end
    while true do
      local name, ftype = vim.loop.fs_scandir_next(fs)
      if not name then break end
      local fullPath = vim.fn.expand(path..'/'..name)
      if ftype == 'file' then
        local stat = vim.loop.fs_stat(fullPath)
        table.insert(result, {
          path = fullPath
          , size = stat.size
          , mtime = stat.mtime.sec
        })
      elseif ftype == 'directory' then
        _G.TKC.utils.file.get_file_info_in_path(fullPath, result)
      end
    end
    if _G.TKC.utils.table.is_empty(result) then
      _G.TKC.utils.message.error('utils.file.get_file_in_path: no file in the dir')
    end
    return result
  end
  , read_json_file_to_table = function (path)
    path = vim.fn.expand(path)
    local fileToString = _G.TKC.utils.table.table_to_string(vim.fn.readfile(path), [[\n]])
    return vim.fn.json_decode(fileToString)
  end
  , read_csv_file_to_table = function (path)
    path = vim.fn.expand(path)
    local fileToTable = vim.fn.readfile(path)
    if #fileToTable == 0 then return {} end
    local result = {}
    local headers = {}
    for header in string.gmatch(fileToTable[1], [[([^,]+)]]) do
      table.insert(headers, header)
    end
    for i = 2, #fileToTable do
      local row = {}
      for value in string.gmatch(fileToTable[i], [[([^,]+)]]) do
        row[headers[i - 1]] = value
      end
      table.insert(result, row)
    end
    return result
  end
  , write_table_to_tsv = function (data, prefix)
    local headers = {}
    for key, _ in pairs(data[1]) do
      table.insert(headers, key)
    end
    local result = {}
    table.insert(result, _G.TKC.utils.table.table_to_string(headers, [[\t]]))
    for _, item in ipairs(data) do
      local row = {}
      for _, header in ipairs(headers) do
        table.insert(row, tostring(item[header] or ''))
      end
      table.insert(result, _G.TKC.utils.table.table_to_stirng(row, [[\t]]))
    end
    local filename = prefix..'_'.._G.TKC.utils.datetime.yyyymmddhhmmss..'.tsv'
    local output = vim.fn.expand('~/work/playground/'..filename)
    vim.fn.writefile(result, output)
  end
  , create = function (path)
    path = vim.fn.expand(path)
    -- a : append
    -- 438 : readable, writable
    local fd = vim.loop.fs_open(path, 'a', 438)
    if fd then
      vim.loop.fs_close(fd)
    else
      _G.TKC.utils.message.error('utils.file.create : failed to create file')
    end
  end
  , chenge_slash_for_windows = function (path)
    return path:gsub("/", "\\")
  end
  , chenge_slash_for_unix = function (path)
    return path:gsub("\\", "/")
  end
}
