return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "VeryLazy",
  config = function()
    require('nvim-treesitter.configs').setup {
      highlight = {
        enable = true,
        disable = {}
      },
      indent = {
        enable = false,
        disable = {}
      },
      ensure_installed = {
        "astro",
        "bash",
        "fish",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "proto",
        "python",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "prisma",
      }
    }
  end
}
