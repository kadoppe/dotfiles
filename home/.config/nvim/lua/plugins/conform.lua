return {
  'stevearc/conform.nvim',
  event = "VeryLazy",
  config = function()
    require("conform").setup({
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        python = {
          "ruff_fix",
          "ruff_format",
          "ruff_organize_imports",
        },
      },
    })
  end
}
