return {
  "keaising/im-select.nvim",
  config = function()
    require("im_select").setup({
      default_im_select  = "com.apple.keylayout.ABC",
      set_default_events = {"VimEnter", "InsertEnter", "InsertLeave"},
      set_previous_events = {},
    })
  end,
}
