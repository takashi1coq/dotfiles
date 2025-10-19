
return {
  error = function (...)
    vim.notify(_G.TKC.utils.string.inspect_and_join(...), vim.log.levels.ERROR)
  end
  , warning = function (...)
    vim.notify(_G.TKC.utils.string.inspect_and_join(...), vim.log.levels.WARN)
  end
  , info = function (...)
    vim.notify(_G.TKC.utils.string.inspect_and_join(...), vim.log.levels.INFO)
  end
}
