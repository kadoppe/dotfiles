return {
  "folke/trouble.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup()
    vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>", { silent = true, noremap = true })
  end
}
