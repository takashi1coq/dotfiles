vim.g['memolist_path'] = '~/work/memo/docs/mkmemo'
vim.g['memolist_memo_date'] = '%Y-%m-%d'

vim.keymap.set('n', 'ml', function () vim.fn['ddu#start']({
  ui = 'ff'
  , sources = {{ name = 'file_rec' }}
  , uiParams = { ff = { startFilter = true } }
  , sourceOptions = {
    file_rec = {
      path = vim.fn.expand(vim.g['memolist_path'])
    }
  }
}) end)
vim.keymap.set('n', 'mn', function () vim.cmd([[MemoNew]]) end)

-- local memoPath = vim.fn.expand('~/work/memo/docs/testmemo')
-- local function createMemoFile(title)
--   if IsEmpty(title) then
--     title = vim.fn.input('memo title ? : ')
--     if IsEmpty(title) then
--       return
--     end
--   end
--   os.execute("mkdir -p "..memoPath)
--   local filePath = Implode({
--     memoPath
--     , os.yyyymmddhhmmss()..'.md'
--   }, '/')
--   local file = io.open(filePath, "w")
--   if file then
--     file:write(title)
--     file:close()
--   end
--   FileOpen(filePath)
-- end
--
-- vim.keymap.set('n', 'mn', function ()
--   createMemoFile()
-- end)
