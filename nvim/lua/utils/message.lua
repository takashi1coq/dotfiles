
return {
  error = function (...)
    vim.notify(_G.TKC.utils.os.inspect_and_join(...), vim.log.levels.ERROR)
  end
  , warning = function (...)
    vim.notify(_G.TKC.utils.os.inspect_and_join(...), vim.log.levels.WARN)
  end
}
