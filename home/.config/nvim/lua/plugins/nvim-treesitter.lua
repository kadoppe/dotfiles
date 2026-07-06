return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  -- main branch does not support lazy-loading
  lazy = false,
  -- Requires the tree-sitter CLI to compile parsers (not needed on master):
  --   brew install tree-sitter-cli
  config = function()
    -- Install parsers (async; no-op if already installed)
    require("nvim-treesitter").install({
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
      "scss",
      "solidity",
      "vue",
    })

    -- On main, highlighting is native Neovim (vim.treesitter.start), not a module.
    -- Enable it on FileType; pcall no-ops for filetypes without an installed parser.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
