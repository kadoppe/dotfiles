return {
  "nvim-neo-tree/neo-tree.nvim",
   branch = "v3.x",
   keys = {
      { "<leader>tt", "<cmd>Neotree focus toggle<cr>", desc = "NeoTree" },
      { "<leader>tf", "<cmd>Neotree focus<cr>", desc = "NeoTree" },
   },
   dependencies = {
     "nvim-lua/plenary.nvim",
     "nvim-tree/nvim-web-devicons",
     "MunifTanjim/nui.nvim",
   },
   config = function()
     require("neo-tree").setup({
       filesystem = {
         filtered_items = {
           hide_dotfiles = false,
           hide_gitignored = false
         },
         follow_current_file = {
           enabled = true,
           leave_dirs_open = false,
         },
         use_libuv_file_watcher = true,
       }
     })

     --vim.keymap.set("n", "<leader>tt", "<cmd>NeoTreeFocusToggle<CR>", { silent = true, noremap = true })
     --vim.keymap.set("n", "<leader>tf", "<cmd>NeoTreeFocus<CR>", { silent = true, noremap = true })
   end
}
