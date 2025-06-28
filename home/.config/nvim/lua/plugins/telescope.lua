return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  cmd = {
    "Telescope",
  },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    "nvim-telescope/telescope-frecency.nvim",
    'stevearc/aerial.nvim',
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    require("telescope").load_extension("aerial")
    require("telescope").load_extension "frecency"

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
          hidden = true,
          file_ignore_patterns = { "^.git/" }
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
        aerial = {
          show_nesting = {
            ["_"] = false, -- This key will be the default
            json = true, -- You can set the option for specific filetypes
            yaml = true,
          },
        },
      }
    }

    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>fr", "<cmd>Telescope frecency workspace=CWD<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>fG", "<cmd>Telescope grep_string<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>fc", "<cmd>Telescope command_history<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>fa", "<cmd>Telescope aerial<CR>", { silent = true, noremap = true })
  end
}
