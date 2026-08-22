local path = vim.fn.tempname()
vim.fn.writefile({ "original" }, path)
vim.cmd.edit(vim.fn.fnameescape(path))

local bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "modified" })
vim.fn.delete(path)
vim.api.nvim_exec_autocmds("FocusGained", {})

assert(
  not vim.api.nvim_buf_is_valid(bufnr),
  "a modified buffer should be forcibly closed when its file was deleted externally"
)

print("PASS: externally deleted buffer was closed")

local new_path = vim.fn.tempname()
vim.cmd.edit(vim.fn.fnameescape(new_path))

local new_bufnr = vim.api.nvim_get_current_buf()
vim.api.nvim_exec_autocmds("FocusGained", {})

assert(
  vim.api.nvim_buf_is_valid(new_bufnr) and vim.api.nvim_buf_get_name(new_bufnr) ~= "",
  "a new buffer whose file has never existed should remain open"
)

print("PASS: new file buffer remained open")
