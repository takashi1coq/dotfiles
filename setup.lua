local home = os.getenv('HOME') or os.getenv('USERPROFILE')
local dotfilesPath = vim.fn.expand(home..[[/dotfiles]])

for _, item in ipairs({
  {
      target = vim.fn.expand(dotfilesPath..[[/nvim/init.lua]])
      , link = vim.fn.expand(vim.fn.stdpath('config')..[[/init.lua]])
      , ftype = 0
  }
  , {
      target = vim.fn.expand(dotfilesPath..[[/nvim/lua]])
      , link = vim.fn.expand(vim.fn.stdpath('config')..[[/lua]])
      , ftype = { dir = true }
  }
  , {
      target = vim.fn.expand(dotfilesPath..[[/nvim/dein_lua.toml]])
      , link = vim.fn.stdpath('config')..[[/dein_lua.toml]]
      , ftype = 0
  }
  , {
      target = vim.fn.expand(dotfilesPath..[[/.gitconfig]])
      , link = home..[[/.gitconfig]]
      , ftype = 0
  }
  , {
      target = vim.fn.expand(dotfilesPath..[[/.gitignore_global]])
      , link = home..[[/.gitignore_global]]
      , ftype = 0
  }
  , {
      target = vim.fn.expand(dotfilesPath..[[/.vimrc]])
      , link = home..[[/.vimrc]]
      , ftype = 0
  }
}) do
    local ta, l, ty = item.target, item.link, item.ftype

    vim.fn.mkdir(vim.fn.fnamemodify(l, ':h'), 'p')

    if vim.loop.fs_stat(l) then
        vim.loop.fs_unlink(l)
    end

    local ok, err = vim.loop.fs_symlink(ta, l, ty)
    if not ok then
        print('Symlink error: '..err)
    else
        print('Linked '..l..[[ -> ]]..ta)
    end
end

for _, item in ipairs({
  {
    ftype = 'file'
    , path = vim.fn.expand(dotfilesPath..[[/nvim/lua/local.lua]])
  }
  , {
    ftype = 'directory'
    , path = vim.fn.expand(home..[[/work/src]])
  }
  , {
    ftype = 'directory'
    , path = vim.fn.expand(home..[[/work/playground]])
  }
}) do
  local stat = vim.loop.fs_stat(item.path)
  if item.ftype == 'directory' then
    if not stat then
      vim.fn.mkdir(item.path, 'p')
    end
  elseif item.ftype == 'file' then
    local parent = vim.fn.fnamemodify(item.path, ":h")
    if vim.loop.fs_stat(parent) == nil then
      vim.fn.mkdir(parent, 'p')
    end
    if not stat then
      local fd = assert(io.open(item.path, 'w'))
      fd:close()
    end
  end
end

local gitconfig_local = vim.fn.expand(home..[[/.gitconfig.local]])
local function get_git_config(key)
  return vim.fn.system({'git', 'config', '--file', gitconfig_local, key}):gsub("%s+$", "")
end
local function set_git_config(key, value)
  vim.fn.system({'git', 'config', '--file', gitconfig_local, key, value})
end
local current_name = get_git_config('user.name')
local current_email = get_git_config('user.email')
if current_name == '' then
  io.write("Git user.name を入力してください: ")
  local name = io.read()
  set_git_config('user.name', name)
end
if current_email == '' then
  io.write("Git user.email を入力してください: ")
  local email = io.read()
  set_git_config('user.email', email)
end

