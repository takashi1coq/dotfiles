local function fileFullName()
  local path = vim.bo.filetype
  if string.isEmpty(vim.bo.buftype) then
    path = string.replace(vim.fn.expand('%:p'), vim.fn.getcwd()..'/', '')
    path = path:gsub('%%', '')
    if string.isEmpty(path) then
      path = '[No Name]'
    end
  end
  local modified = vim.bo.modified and ' [+]' or ''
  return path..modified
end

local function branch()
  return vim.fn['gin#component#branch#ascii']()
end

require('lualine').setup {
  options = {
    icons_enabled = false
    , component_separators = { left = '', right = ''}
    , section_separators = { left = '', right = ''}
    , disabled_filetypes = {
      -- TODO bad way to make buffer..
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
    , lualine_b = { fileFullName }
    , lualine_c = {}
    , lualine_x = {}
    , lualine_y = {}
    , lualine_z = { vim.fn.getProjectDirName }
  }
  , winbar = {}
  , inactive_winbar = {}
  , extensions = {}
}


