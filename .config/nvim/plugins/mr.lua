vim.api.nvim_create_user_command(
  'OpenMrwFile'
  , function (opts)
    local files = vim.fn['mr#mrw#list']()
    local count = tonumber(opts.args)
    for i in ipairs(files) do
      if i <= count then
        if vim.fn.getftype(files[i]) then
          vim.cmd('tabe '..files[i])
        end
      end
    end
    vim.cmd('tabfirst | bd')
  end
  , { nargs = '+' }
)
vim.g['mr#threshold'] = 10
