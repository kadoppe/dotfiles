return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      build = ":MasonUpdate",
      dependencies = { 'williamboman/mason.nvim' },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "lua_ls",
            "gopls",
            "tsserver",
            "vimls",
            "astro",
            "pyright",
            "powershell_es",
            "tailwindcss",
            "terraformls",
            "solargraph",
            "solidity_ls_nomicfoundation",
          },
          automatically_installation = true
        })
      end
    },
    "SmiteshP/nvim-navic",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local navic = require('nvim-navic')

    local on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local lspconfig = require("lspconfig")

    lspconfig.tsserver.setup {
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern("package.json"),
      single_file_support = false,
      capabilities = capabilities
    }

    if vim.fn.executable("deno") then
      lspconfig.denols.setup {
        on_attach = on_attach,
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        init_options = {
          enable = true,
          lint = true,
          unstable = true,
          suggest = {
            imports = {
              hosts = {
                ["https://deno.land"] = true,
                ["https://cdn.nest.land"] = true,
                ["https://crux.land"] = true,
              },
            },
          },
        },
        capabilities = capabilities,
      }
    end

    lspconfig.gopls.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    lspconfig.vimls.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    }

    lspconfig.pyright.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    lspconfig.powershell_es.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    lspconfig.astro.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    lspconfig.tailwindcss.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    lspconfig.terraformls.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    lspconfig.solargraph.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }

    lspconfig.solidity_ls_nomicfoundation.setup {
      on_attach = on_attach,
      capabilities = capabilities
    }
  end
}
