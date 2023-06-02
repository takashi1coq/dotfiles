require("mason").setup()
local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
local servers = {
  lua_ls = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
    }
  }
  , tsserver = {}
  , intelephense = {}
}
mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers)
})
mason_lspconfig.setup_handlers({ function(server_name)
  local opts = {}
  opts.settings = servers[server_name]
  opts.on_attach = function(_, bufnr)
    local bufopts = { silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  end
  lspconfig[server_name].setup(opts)
end })
