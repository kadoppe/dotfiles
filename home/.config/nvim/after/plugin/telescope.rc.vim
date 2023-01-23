lua <<EOF
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.load_extension('frecency')

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
nnoremap <leader><leader> <cmd>Telescope frecency workspace=CWD<cr>
