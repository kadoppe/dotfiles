local saga = require 'lspsaga'

saga.init_lsp_saga()

-- Async lsp finder
vim.keymap.set("n", "gh", require("lspsaga.finder").lsp_finder, { silent = true, noremap = true })

-- Code action
local action = require("lspsaga.codeaction")

vim.keymap.set("n", "<leader>ca", action.code_action, { silent = true, noremap = true })
vim.keymap.set("v", "<leader>ca", function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
  codeaction.range_code_action()
end, { silent = true, noremap =true })

-- Hover doc
vim.keymap.set("n", "K", require("lspsaga.hover").render_hover_doc, { silent = true })

local action = require("lspsaga.action")
vim.keymap.set("n", "<C-f>", function()
  action.smart_scroll_with_saga(1)
end, { silent = true })
vim.keymap.set("n", "<C-b>", function()
  action.smart_scroll_with_saga(-1)
end, { silent = true })

-- Signature help
vim.keymap.set("n", "gs", require("lspsaga.signaturehelp").signature_help, { silent = true, noremap = true})

