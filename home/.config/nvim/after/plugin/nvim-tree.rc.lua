-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup()

vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>tf", "<cmd>NvimTreeFocus<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>to", "<cmd>NvimTreeFindFile<CR>", { silent = true, noremap = true })
