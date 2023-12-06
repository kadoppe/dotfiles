return {
  "mhartington/formatter.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('formatter').setup({
      filetype = {
        javascript = {
          require("formatter.filetypes.javascript").eslint_d,
          require("formatter.filetypes.javascript").prettierd
        },
        typescript = {
          require("formatter.filetypes.typescript").eslint_d,
          require("formatter.filetypes.typescript").prettierd
        },
        typescriptreact = {
          require("formatter.filetypes.typescriptreact").eslint_d,
          require("formatter.filetypes.typescriptreact").prettierd
        },
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace
        }
      }
    })

    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd
    augroup("__formatter__", { clear = true })
    autocmd("BufWritePost", {
      group = "__formatter__",
      command = ":FormatWrite",
    })
  end
}

