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
            "ts_ls",
            "vimls",
            "astro",
            "pyright",
            "ruff",
            "tailwindcss",
            "terraformls",
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

    lspconfig.ts_ls.setup {
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

    -- if vim.fn.executable("deno") then
    --   lspconfig.denols.setup {
    --     on_attach = on_attach,
    --     root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
    --     init_options = {
    --       enable = true,
    --       lint = true,
    --       unstable = true,
    --       suggest = {
    --         imports = {
    --           hosts = {
    --             ["https://deno.land"] = true,
    --             ["https://cdn.nest.land"] = true,
    --             ["https://crux.land"] = true,
    --           },
    --         },
    --       },
    --     },
    --     capabilities = capabilities,
    --   }
    -- end

    -- lspconfig.gopls.setup {
    --   on_attach = on_attach,
    --   capabilities = capabilities
    -- }

    -- local autocmd = vim.api.nvim_create_autocmd
    -- autocmd("BufWritePre", {
    --   pattern = "*.go",
    --   callback = function()
    --     local params = vim.lsp.util.make_range_params()
    --     params.context = {only = {"source.organizeImports"}}
    --     -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    --     -- machine and codebase, you may want longer. Add an additional
    --     -- argument after params if you find that you have to write the file
    --     -- twice for changes to be saved.
    --     -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    --     local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    --     for cid, res in pairs(result or {}) do
    --       for _, r in pairs(res.result or {}) do
    --         if r.edit then
    --           local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
    --           vim.lsp.util.apply_workspace_edit(r.edit, enc)
    --         end
    --       end
    --     end
    --     vim.lsp.buf.format({async = false})
    --   end
    -- })

    vim.lsp.enable('pyright')
    vim.lsp.config('pyright', {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            -- ignore = { '*' },
          },
        },
      },
    })

    vim.lsp.enable('ruff')
    vim.lsp.config('ruff', {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { 'uv', 'run', 'ruff', 'server' },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end
        if client.name == 'ruff' then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end
      end,
      desc = 'LSP: Disable hover capability from Ruff',
    })



    vim.lsp.enable('vimls')
    vim.lsp.config('vimls', {
      on_attach = on_attach,
      capabilities = capabilities,
    })

    vim.lsp.enable('lua_ls')
    vim.lsp.config('lua_ls', {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          },
        }
      }
    })

    vim.lsp.enable('tailwindcss')
    vim.lsp.config('tailwindcss', {
      on_attach = on_attach,
      capabilities = capabilities,
    })

    vim.lsp.enable('terraformls')
    vim.lsp.config('terraformls', {
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- lspconfig.solargraph.setup {
    --   on_attach = on_attach,
    --   capabilities = capabilities
    -- }
  end
}
