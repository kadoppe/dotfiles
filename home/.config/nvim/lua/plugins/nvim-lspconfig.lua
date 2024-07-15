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
            "powershell_es",
            "tailwindcss",
            "terraformls",
            "volar",
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

    local vue_typescript_plugin = require('mason-registry')
      .get_package('vue-language-server')
      :get_install_path()
      .. '/node_modules/@vue/language-server'
      .. '/node_modules/@vue/typescript-plugin'

    lspconfig.tsserver.setup {
      on_attach = on_attach,
      root_dir = lspconfig.util.root_pattern("package.json"),
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_typescript_plugin,
            languages = {'javascript', 'typescript', 'vue'}
          }
        }
      },
      single_file_support = false,
      capabilities = capabilities,
      filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
      }
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

    local autocmd = vim.api.nvim_create_autocmd
    autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = {only = {"source.organizeImports"}}
        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
        -- machine and codebase, you may want longer. Add an additional
        -- argument after params if you find that you have to write the file
        -- twice for changes to be saved.
        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
          for _, r in pairs(res.result or {}) do
            if r.edit then
              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
              vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
          end
        end
        vim.lsp.buf.format({async = false})
      end
    })

    lspconfig.pylsp.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            -- format
            autopep8 = {enabled = true},
            pycodestyle = {enabled = false},
            -- type check
            pylsp_mypy = {enabled = true},
            -- lint
            pyflakes = {enabled = false},
            mccabe = {enabled = false},
          }
        }
      }
    }

    lspconfig.vimls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
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
  end
}
