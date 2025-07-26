return {
  'mfussenegger/nvim-dap',
  event = "VimEnter",
  dependencies = {
    'rcarriga/nvim-dap-ui',
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require('dap')
    local ui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")

    dap_virtual_text.setup()

    require("dap-python").setup("uv")
    require('dap').configurations.python = {
      {
        name    = 'Attach FastAPI',
        type    = 'python',
        request = 'attach',
        connect = { host = '127.0.0.1', port = 5678 },
      },
    }

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

    ui.setup()
    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end
  end
}
