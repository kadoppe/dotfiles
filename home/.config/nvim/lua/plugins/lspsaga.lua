return {
  "glepnir/lspsaga.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter" }
  },
  config = function()
    require("lspsaga").setup({
      lightbulb = {
        enable = false
      },
      outline = {
        layout = 'float'
      }
    })

    local keymap = vim.keymap.set

    -- Async lsp finder
    keymap("n", "gh", "<cmd>Lspsaga finder<CR>")

    -- Code action
    keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

    -- Hover doc
    keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

    -- Jump and show diagnostics
    keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>")

    -- jump diagnostic
    keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

    -- or jump to error
    --
    keymap("n", "[E", function()
      require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end)
    keymap("n", "]E", function()
      require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
    end)

    -- -- Preview definition
    -- keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

    -- Rename
    keymap("n", "gr", "<cmd>Lspsaga rename<CR>")

    -- Call hierarchy
    keymap("n", "<leader>ch", "<cmd>Lspsaga incoming_calls ++float<CR>")
    keymap("n", "<leader>cl", "<cmd>Lspsaga outgoing_calls ++float<CR>")

    -- outline
    keymap("n", "<leader>go", "<cmd>Lspsaga outline<CR>")
  end,
}
