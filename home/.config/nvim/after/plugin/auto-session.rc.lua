local function close_neo_tree()
  require 'neo-tree.sources.manager'.close_all()
  vim.notify('closed all')
end

require('auto-session').setup {
  log_level = 'info',
  auto_session_suppress_dirs = {'~/'},
  auto_session_create_enabled = false,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  bypass_session_save_file_types = { "neo-tree" },
  pre_save_cmds = {
    'Neotree close'
  },
  post_restore_cmds = {
    'Neotree show filesystem reveal left'
  }
}
