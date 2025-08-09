return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    ---@class snacks.lazygit.Config: snacks.terminal.Opts
    ---@field args? string[]
    ---@field theme? snacks.lazygit.Theme
    lazygit = {
    }
  },
  keys = {
    { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
  }
}
