require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {}
  },
  indent = {
    enable = false,
    disable = {}
  },
  ensure_installed = {
    "bash",
    "fish",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml"
  }
}
