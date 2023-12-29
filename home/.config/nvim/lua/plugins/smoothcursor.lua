return { 'gen740/SmoothCursor.nvim',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('smoothcursor').setup()
  end
}
