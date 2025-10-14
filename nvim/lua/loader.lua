
local M = {}
function M.scan_dir(path)
  local namespace_table = {}
  local scan = vim.loop.fs_scandir(path)
  while scan do
    local name, ftype = vim.loop.fs_scandir_next(scan)
    if not name then
      break
    end
    local full_path = path..[[/]]..name
    if ftype == 'file' and name:match([[(.+)%.lua$]]) and name ~= 'init.lua' then
      local mod_name = full_path:match([[lua/(.+)%.lua$]]):gsub([[/]], [[.]])
      namespace_table[name:gsub([[%.lua$]], '')] = require(mod_name)
    elseif ftype == "directory" then
      namespace_table[name] = M.scan_dir(full_path)
    end
  end
  return namespace_table
end

return M
