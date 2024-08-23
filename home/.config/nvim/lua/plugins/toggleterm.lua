return {
  'akinsho/toggleterm.nvim',
  version = "*",
  event = "VeryLazy",

  config = function()
    require("toggleterm").setup{
      direction = "float"
    }

    vim.keymap.set("n", "<leader>tm", "<cmd>ToggleTerm<CR>", { silent = true, noremap = true })
  end
}
