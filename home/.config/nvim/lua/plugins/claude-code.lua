return {
  "nekowasabi/claudecode.vim",
  event = { "VeryLazy" },
  dependencies = { "vim-denops/denops.vim" },
  config = function()
    vim.g.claude_command = "claude"
    vim.g.claude_buffer_open_type = "vsplit"
    vim.g.claude_floatwin_height = 20
    vim.g.claude_floatwin_width = 100

    vim.api.nvim_set_keymap('n', '<leader>cr', ':ClaudeRun<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>cf', ':ClaudeRunFloating<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>cs', ':ClaudeRunSplit<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>ct', ':ClaudeRunToggle<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>ca', ':ClaudeAddCurrentFile<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>cc', ':ClaudeContinue<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>cv', ':ClaudeReview<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>ch', ':ClaudeHide<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<leader>cp', ':ClaudeVisualTextWithPrompt<CR>', { noremap = true, silent = true })
  end
}
