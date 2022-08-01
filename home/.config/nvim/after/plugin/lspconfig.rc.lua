local navic = require('nvim-navic')

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

  navic.attach(client, bufnr)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local lspconfig = require("lspconfig")

lspconfig.tsserver.setup{
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  capabilities = capabilities
}

lspconfig.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.vimls.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.sumneko_lua.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}
      }
    }
  }
}

