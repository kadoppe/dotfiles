local saga = require 'lspsaga'

saga.init_lsp_saga()

-- Async lsp finder
vim.keymap.set("n", "gd", require("lspsaga.finder").lsp_finder, { silent = true, noremap = true })

-- Code action
local codeaction = require("lspsaga.codeaction")

vim.keymap.set("n", "<leader>ca", codeaction.code_action, { silent = true, noremap = true })
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
vim.keymap.set("n", "<C-k>", require("lspsaga.signaturehelp").signature_help, { silent = true, noremap = true})

-- Jump and show diagnostics
vim.keymap.set("n", "<leader>cd", require("lspsaga.diagnostic").show_line_diagnostics, { silent = true,noremap = true })
vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true,noremap= true })

-- jump diagnostic
vim.keymap.set("n", "[e", require("lspsaga.diagnostic").goto_prev, { silent = true, noremap =true })
vim.keymap.set("n", "]e", require("lspsaga.diagnostic").goto_next, { silent = true, noremap =true })
-- or jump to error
vim.keymap.set("n", "[E", function()
  require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true, noremap = true })
vim.keymap.set("n", "]E", function()
  require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true, noremap = true })

-- Preview definition
vim.keymap.set("n", "gp", require("lspsaga.definition").preview_definition, { silent = true, noremap = true })

-- Rename
vim.keymap.set("n", "gr", require("lspsaga.rename").lsp_rename, { silent = true,noremap = true })
