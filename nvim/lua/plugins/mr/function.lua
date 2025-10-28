
return {
  openCount = 1
  , excludedFiletypes = { 'csv', 'json' }
  , excludedExtensions = { 'log' }
  , open_mrw_file = function()
    local list = vim.fn['mr#mrw#list']()
    local transformList = _G.TKC.utils.table.transform(function(_, filePath)
      local isExcludedFiletype = _G.TKC.utils.table.find(
        _G.TKC.plugins.mr.excludedFiletypes
        , vim.filetype.match({filename = filePath})
      )
      local isExcludedExtension = _G.TKC.utils.file.has_extension(
        filePath
        , _G.TKC.plugins.mr.excludedExtensions
      )
      if not isExcludedFiletype and not isExcludedExtension then
        return filePath
      end
    end, list)
    if #transformList == 0 then
      return
    end
    local safeOpenCount = math.min(
      _G.TKC.plugins.mr.openCount
      , #transformList
    )
    local slicedList = {}
    table.move(transformList, 1, safeOpenCount, 1, slicedList)
    local result = {}
    for i = #slicedList, 1, -1 do
      result[#result + 1] = slicedList[i]
    end
    for key, filePath in ipairs(result) do
      if key == 1 then
        vim.cmd('e '..filePath)
      else
        vim.cmd('tabe '..filePath)
      end
    end
  end
}
