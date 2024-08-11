return {
  "nvim-pack/nvim-spectre",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require('spectre').setup({
      replace_engine={
        ['sed']={
          cmd = "gsed",
          args = nil,
          options = {
            ['ignore-case'] = {
              value= "--ignore-case",
              icon="[I]",
              desc="ignore case"
            },
          }
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = {"ignore-case"}
        },
        replace={
          cmd = "sed"
        }
      },
    })
    vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
      desc = "Toggle Spectre"
    })
    vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = "Search current word"
    })
    vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
      desc = "Search current word"
    })
    vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = "Search on current file"
    })
  end
}
