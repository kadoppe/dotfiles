require("lazy").setup({
  {
    "dracula/vim",
    name = "dracula",
    lazy = false,
    config = function()
      vim.cmd([[colorscheme dracula]])
    end
  },
  {"xiyaowong/transparent.nvim"},
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false
          }
        }
      })

      vim.keymap.set("n", "<leader>tt", "<cmd>NeoTreeFocusToggle<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>tf", "<cmd>NeoTreeFocus<CR>", { silent = true, noremap = true })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = false,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {{
            'filename',
            file_status = true,
            path = 0
          }},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {{
            'filename',
            file_status = true,
            path = 1
          }},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      }
    end
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require("scrollbar").setup()
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup()
    end
  },
  {
    'RRethy/vim-illuminate'
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim'
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup {
        defaults = {
          mappings = {
            n = {
              ["q"] = actions.close
            }
          }
        },
        pickers = {
          find_files = {
            no_ignore = false,
            hidden = true
          },
        },
        extensions = {
          frecency = {
            default_workspace = 'CWD',
          },
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
          }
        }
      }

      vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>fG", "<cmd>Telescope grep_string<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>fc", "<cmd>Telescope command_history<CR>", { silent = true, noremap = true })
    end
  },
  {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = {"kkharji/sqlite.lua"},
    config = function()
      require"telescope".load_extension("frecency")
      vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope frecency workspace=CWD<CR>", { silent = true, noremap = true })
    end
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    config = function()
      require"telescope".load_extension("fzf")
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'onsails/lspkind.nvim'
    },
    config = function()
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'path' },
          { name = 'nvim_lua' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text'
          })
        }
      })

      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' },
        })
      })
    end
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    build = ":MasonUpdate",
    dependencies = {'williamboman/mason.nvim'},
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "gopls", "tsserver", "vimls", "astro", "pyright"}
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "SmiteshP/nvim-navic",
      "hrsh7th/cmp-nvim-lsp",
      "lukas-reineke/lsp-format.nvim"
    },
    config = function()
      require("lsp-format").setup {}

      local navic = require('nvim-navic')

      local on_attach = function(client, bufnr)
        require("lsp-format").on_attach(client)

        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

        navic.attach(client, bufnr)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.tsserver.setup{
        on_attach = on_attach,
        root_dir = lspconfig.util.root_pattern("package.json"),
        single_file_support = false,
        capabilities = capabilities
      }

      if vim.fn.executable("deno") then
        lspconfig.denols.setup{
          on_attach = on_attach,
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
          init_options = {
            enable=true,
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

      lspconfig.gopls.setup{
        on_attach = on_attach,
        capabilities = capabilities
      }

      lspconfig.vimls.setup{
        on_attach = on_attach,
        capabilities = capabilities
      }

      lspconfig.lua_ls.setup{
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

      lspconfig.pyright.setup{
        on_attach = on_attach,
        capabilities = capabilities
      }
    end
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      {"nvim-tree/nvim-web-devicons"},
      {"nvim-treesitter/nvim-treesitter"}
    },
    config = function()
      require("lspsaga").setup({})

      local keymap = vim.keymap.set

      -- Async lsp finder
      keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

      -- Code action
      keymap({"n", "v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

      -- Hover doc
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

      -- Jump and show diagnostics
      keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>")

      -- jump diagnostic
      keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

      -- or jump to error
      --
      keymap("n", "[E", function()
        require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end)
      keymap("n", "]E", function()
        require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      end)

      -- Preview definition
      keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

      -- Rename
      keymap("n", "gr", "<cmd>Lspsaga rename<CR>")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local null_ls = require("null-ls")
  require("null-ls").setup({
    -- you can reuse a shared lspconfig on_attach callback here
})

      null_ls.setup({
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.autoflake,
          null_ls.builtins.diagnostics.flake8,
        },
      })
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>", { silent = true, noremap = true })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = {}
        },
        indent = {
          enable = false,
          disable = {}
        },
        ensure_installed = {
          "astro",
          "bash",
          "fish",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "proto",
          "python",
          "terraform",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        }
      }
    end
  },
  -- {
  --   'dense-analysis/ale',
  --   config = function()
  --     vim.g.ale_fixers = {
  --       javascript = {'eslint'},
  --       typescript = {'eslint'},
  --       typescriptreact = {'eslint'},
  --     }
  --     vim.g.ale_fix_on_save = 1
  --     vim.g.ale_javascript_prettier_use_local_config = 1
  --   end
  -- },
  {
    'mattn/vim-goimports'
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
  {
    'haringsrob/nvim_context_vt',
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        show_current_context = true,
      }
    end
  },
  {
    'github/copilot.vim'
  },
  {
    'tyru/open-browser-github.vim',
    dependencies = {'tyru/open-browser.vim'},
  },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
      })
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = { "BufReadPre " .. vim.fn.expand "~" .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/kadoppe/**.md" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/kadoppe",
      notes_subdir = "notes",
      daily_notes = {
        folder = "Daily Notes",
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })

      vim.keymap.set("n", "<leader>fo", "<cmd>ObsidianQuickSwitch<CR>", { silent = true, noremap = true })
    end,
  },
  {
    'rmagatti/auto-session',
    dependencies = {'nvim-telescope/telescope.nvim'},
    config = function()
      require('auto-session').setup {
        log_level = 'error',
        auto_session_suppress_dirs = {'~/'},
        auto_session_create_enabled = false,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        psession_lens = {
          previewer = false,
        },
        pre_save_cmds = {"NeoTreeClose"},
      }
      vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    end
  }
})
