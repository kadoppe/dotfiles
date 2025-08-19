vim.g.mapleader = ","

vim.keymap.set('n', '<C-j>', '<C-w>j', {noremap = true})
vim.keymap.set('n', '<C-k>', '<C-w>k', {noremap = true})
vim.keymap.set('n', '<C-h>', '<C-w>h', {noremap = true})
vim.keymap.set('n', '<C-l>', '<C-w>l', {noremap = true})

vim.api.nvim_set_keymap('n', 'q', '<Nop>', { noremap = true, silent = true })

vim.keymap.set('t', '<C-\\>', '<C-\\><C-N>', { noremap = true })
