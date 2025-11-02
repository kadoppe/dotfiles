return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "VimEnter",
  config = function()
    require("catppuccin").setup({
      auto_integrations = true,
    })
    require('lualine').setup {
      options = {
        theme = "catppuccin"
      }
    }
    require("lspsaga").setup {
      ui = {
        kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
      },
    }
    vim.cmd.colorscheme "catppuccin-frappe"
  end
}
