return {
  'mfussenegger/nvim-dap',
  event = "VimEnter",
  dependencies = {
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require('dap')
    require("dap-python").setup("uv")

    vim.keymap.set('n', '<leader>db', function()
      dap.toggle_breakpoint()
    end, {
      desc = "Dap: Toggle breakpoint"
    })
    vim.keymap.set('n', '<leader>dc', function()
      dap.continue()
    end, {
      desc = "Dap: Continue"
    })
    vim.keymap.set('n', '<leader>dso', function()
      dap.step_over()
    end, {
      desc = "Dap: Step Over"
    })
    vim.keymap.set('n', '<leader>dsi', function()
      dap.step_into()
    end, {
      desc = "Dap: Step Into"
    })
    vim.keymap.set('n', '<leader>dr', function()
      dap.repl.open()
    end, {
      desc = "Dap: REPL open"
    })
  end
}
