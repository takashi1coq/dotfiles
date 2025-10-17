
return {
  error = function (message)
    vim.notify(message, vim.log.levels.ERROR)
  end
  , warning = function (message)
    vim.notify(message, vim.log.levels.WARN)
  end
}
