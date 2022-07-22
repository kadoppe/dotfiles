lua << EOF
local neogit = require('neogit')
neogit.setup {
  integrations = {
    diffview = true
  }
}
EOF

nmap <leader>go :Neogit kind=vsplit<CR>
nmap <leader>gc :Neogit commit kind=vsplit<CR>
