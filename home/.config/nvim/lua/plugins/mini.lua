return {
  'echasnovski/mini.nvim',
  version = '*',
  event = { "BufReadPre", "BufNewFile" },
  config = function ()
    require('mini.cursorword').setup()
  end
}
