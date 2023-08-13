return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.2',
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
    }
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
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
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
}
