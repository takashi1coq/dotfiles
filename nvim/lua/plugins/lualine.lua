
local function tab_name ()
  local tabName = vim.bo.buftype
  if _G.TKC.utils.string.is_empty(tabName) then
    tabName = _G.TKC.utils.file.current_relative_path()
    tabName = tabName:gsub('%%', '')
    if _G.TKC.utils.string.is_empty(tabName) then
      tabName = '[No Name]'
    end
  end
  local modified = vim.bo.modified and '[+]' or ''
  return tabName..[[ ]]..modified
end

local function branch()
  return vim.fn['gin#component#branch#ascii']()
end

local function project_name()
  return _G.TKC.utils.file.project_name()
end

require('lualine').setup {
  options = {
    icons_enabled = false
    , component_separators = { left = '', right = ''}
    , section_separators = { left = '', right = ''}
    , disabled_filetypes = {
      statusline = {'gin-my-patch'}
    }
  }
  , sections = {
    lualine_a = { 'mode' }
    , lualine_b = { branch }
    , lualine_c = {}
    , lualine_x = { 'encoding', 'fileformat', 'filetype' }
    , lualine_y = { 'progress' }
    , lualine_z = { 'location' }
  }
  , tabline = {
    lualine_a = { 'tabs' }
    , lualine_b = { tab_name }
    , lualine_c = {}
    , lualine_x = {}
    , lualine_y = {}
    , lualine_z = { project_name }
  }
  , winbar = {}
  , inactive_winbar = {}
  , extensions = {}
}

