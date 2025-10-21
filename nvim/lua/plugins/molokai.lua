
vim.cmd.colorscheme('molokai')

local highlight = {
  Comment = {ctermfg = 101}
  , CursorLine = {ctermbg = 236}
  , Search = {ctermbg = 55, ctermfg = 226}
  , Visual = {ctermbg = 239}
  , TabLine = {ctermfg = 15}
  , TabLineSel = {ctermbg = 255,ctermfg = 0}
  , TabLineFill = {cterm = 'bold', ctermbg = 240, ctermfg = 49}
  , StatusLine = {ctermbg = 226}
}

for group, values in pairs(highlight) do
  local cterm = values.cterm and values.cterm or "NONE"
  local ctermbg = values.ctermbg and values.ctermbg or "NONE"
  local ctermfg = values.ctermfg and values.ctermfg or "NONE"
  vim.cmd(
    'highlight '
    ..group
    ..' cterm='..cterm
    ..' ctermbg='..ctermbg
    ..' ctermfg='..ctermfg
  )
end
