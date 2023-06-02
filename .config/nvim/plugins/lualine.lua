local function projectDirName()
  local path = vim.fn.split(vim.fn.getcwd(), '/')
  return path[#path]
end

local function fileFullName()
  local path = vim.bo.filetype
  if IsEmpty(vim.bo.buftype) then
    path = vim.fn.expand('%:p')
    path = path:gsub(vim.fn.getcwd()..'/', '')
    if IsEmpty(path) then
      path = '[No Name]'
    end
  end
  local modified = vim.bo.modified and ' *' or ''
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
    , lualine_z = { projectDirName }
  }
  , winbar = {}
  , inactive_winbar = {}
  , extensions = {}
}


