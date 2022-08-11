lua <<EOF
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.load_extension('frecency')
telescope.load_extension("file_browser")
local fb_actions = telescope.extensions.file_browser.actions

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
      theme = "ivy",
      no_ignore = false,
      hidden = true
    },
    live_grep = {
      theme = "ivy",
    },
    grep_string = {
      theme = "ivy",
    },
    buffers = {
      theme = "ivy",
    },
    help_tags = {
      theme = "ivy",
    },
    diagnostics = {
      theme = "ivy",
    },
    command_history = {
      theme = "ivy",
    },
  },
  extensions = {
    frecency = {
      theme = "ivy",
      default_workspace = 'CWD'
    },
    file_browser = {
      theme = "ivy",
      hijack_netrw = true,
      hidden = true,
      respect_gitignore = false,
      groupted = true,
      previewer = false,
      initial_mode = "normal",
      mappings = {
        ["n"] = {
          ["h"] = fb_actions.goto_parent_dir,
        },
      },
    }
  }
}
EOF

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fG <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>
nnoremap <leader>fc <cmd>Telescope command_history<cr>
nnoremap <leader><leader> <cmd>Telescope frecency<cr>
nnoremap <leader>ft <cmd>Telescope file_browser<cr>
