lua <<EOF
require'hop'.setup {}
EOF

nmap <Leader><Leader> [hop]
xmap <Leader><Leader> [hop]
nnoremap <silent> [hop]w :HopWord<CR>
nnoremap <silent> [hop]l :HopLine<CR>
nnoremap <silent> [hop]f :HopChar1<CR>
