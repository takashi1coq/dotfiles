
return {
  my = function (name, cmd, path, openCmd)
    name = name..'_Terminal'
    openCmd = openCmd or '0tabnew'
    local bufferNumbers = vim.api.nvim_list_bufs()
    local targetBufferNumbers = {}
    for _, number in ipairs(bufferNumbers) do
      local bufferName = vim.api.nvim_buf_get_name(number)
      if string.match(bufferName, name) then
        table.insert(targetBufferNumbers, number)
      end
    end
    if not _G.TKC.utils.table.is_empty(targetBufferNumbers) then
      if _G.TKC.utils.string.is_empty(vim.fn.input('already exists. ? : ')) then
        for _, number in ipairs(targetBufferNumbers) do
          vim.cmd(openCmd)
          vim.cmd(number..'b')
        end
        return
      end
    end
    vim.cmd(openCmd)
    vim.fn.jobstart({vim.o.shell}, {
      cwd = path
      , term = true
      , on_exit = function ()
      end
      , on_stdout = function (id, data, event)
      end
    })
    local bufferNumber = vim.api.nvim_get_current_buf()
    local bufferName = string.format([[%s %s %s]], name, openCmd, bufferNumber)
    vim.api.nvim_buf_set_name(bufferNumber, bufferName)
    vim.api.nvim_put({cmd}, 'c', false, true)
  end
}
