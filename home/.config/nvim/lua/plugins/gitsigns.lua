return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('gitsigns').setup()
    require("scrollbar.handlers.gitsigns").setup()
  end
}
