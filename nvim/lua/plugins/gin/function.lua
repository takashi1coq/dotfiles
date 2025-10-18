
return {
  my_gin_diff = function (preCommit, postCommit, path)
    if preCommit == nil or postCommit == nil or path == nil then
      _G.TKC.utils.message.error('plugins.ddu.my_gin_diff some arg is nil', {
        preCommit = preCommit or ''
        , postCommit = postCommit or ''
        , path = path or ''
      })
      return
    end
    vim.cmd('GinEdit ++opener=tabnew '..preCommit..' '..path..'|diffthis')
    vim.cmd('GinEdit ++opener=vsplit '..postCommit..' '..path..'|diffthis')
  end
  , log_current_path = ''
  , log_commit = ''
}
