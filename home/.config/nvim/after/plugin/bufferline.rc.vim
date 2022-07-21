set termguicolors

nnoremap <silent>[b :BufferLineCycleNext<CR>
nnoremap <silent>]b :BufferLineCyclePrev<CR>

lua << EOF
require("bufferline").setup{
  options = {
    mode = "tabs",
    show_close_icon = false
  }
}
EOF

