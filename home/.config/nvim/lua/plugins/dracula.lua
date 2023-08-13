return {
  "dracula/vim",
  name = "dracula",
  lazy = false,
  config = function()
    vim.cmd([[colorscheme dracula]])
  end
}
