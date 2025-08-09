return {
  "shaunsingh/nord.nvim",
  event = "VimEnter",
  config = function()
    vim.g.nord_disable_background = true
    require('nord').set()
  end
}
