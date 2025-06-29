return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    
    -- リンターの設定（必要に応じて追加）
    lint.linters_by_ft = {
      -- markdown = {}, -- Markdownのリンターを無効化
    }
    
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end
}
