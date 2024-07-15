return {
  "nvim-neotest/neotest",
  event = "VimEnter",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-python",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  config = function()
    local neotest = require("neotest")
    neotest.setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
        }),
      },
      output = {
        enabled = true,
        open_on_run = false
      },
    })
    vim.keymap.set('n', '<leader>tr', function()
      neotest.run.run({
        env = {
          FLASK_ENV = "test"
        }
      })
    end, {
      desc = "Run the neaest test"
    })
    vim.keymap.set('n', '<leader>td', function()
      neotest.run.run({
        strategy = "dap",
        env = {
          FLASK_ENV = "test"
        }
      })
    end, {
      desc = "Run the neaest test with debug"
    })
    vim.keymap.set('n', '<leader>to', function() 
      neotest.output.open({
        short = true,
        enter = true,
      })
    end, {
      desc = "Test output"
    })
  end
}
