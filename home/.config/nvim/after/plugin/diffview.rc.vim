lua << EOF
require('diffview').setup({})
EOF

nmap <leader>gdo :DiffviewOpen<CR>
nmap <leader>gdc :DiffviewClose<CR>
nmap <leader>gdr :DiffviewRefresh<CR>
nmap <leader>gdh :DiffviewFileHistory<CR>
