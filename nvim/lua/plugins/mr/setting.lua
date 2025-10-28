
vim.g['mr#threshold'] = 50
vim.g['mr#mrw#predicates'] = {
  function (filename)
    return vim.regex([[COMMIT_EDITMSG]]):match_str(filename) == nil
  end
  , function (filename)
    local bufnr = vim.fn.bufnr(filename)
    return bufnr ~= -1 and vim.bo[bufnr].filetype ~= "markdown"
  end
}
-- set function
_G.TKC = _G.TKC or {}
_G.TKC.plugins = _G.TKC.plugins or {}
_G.TKC.plugins.mr = require('plugins.mr.function')
