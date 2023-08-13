return {
  "kevinhwang91/nvim-hlslens",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { 
    'petertriho/nvim-scrollbar',
  },
  config = function()
    require("scrollbar.handlers.search").setup({
    })
  end,
}
