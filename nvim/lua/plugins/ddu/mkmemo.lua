local memoPath = vim.fn.expand('~/work/memo/docs/mkmemo')

vim.keymap.set('n', 'mn', function ()
  local title = vim.fn.input('memo title ? : ')
  if _G.TKC.utils.string.is_empty(title) then
    return
  end
  local header = _G.TKC.utils.table.table_to_string({
    title
    , [[==========]]
  }, '\n')
  local filePath = vim.fn.expand(memoPath..'/'.._G.TKC.utils.datetime.yyyymmddhhmmss()..'.md')
  _G.TKC.plugins.ddu.custom_file_create(header, filePath)
end)

vim.keymap.set('n', 'ml', function ()
  _G.TKC.plugins.ddu.open_custom_directory(memoPath, true)
end)
