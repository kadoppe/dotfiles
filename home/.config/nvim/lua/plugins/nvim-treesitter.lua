return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "VeryLazy",
  config = function()
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.powershell = {
      install_info = {
        url = "https://github.com/jrsconfitto/tree-sitter-powershell",
        files = {"src/parser.c"}
      },
      filetype = "ps1",
      used_by = { "psm1", "psd1", "pssc", "psxml", "cdxml" }
    }

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
        "css",
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
        "powershell",
        "scss",
        "solidity",
        "vue",
      }
    }
  end
}
