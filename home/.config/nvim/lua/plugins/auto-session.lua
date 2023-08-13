return {
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup {
      log_level = 'error',
      auto_session_suppress_dirs = { '~/' },
      auto_session_create_enabled = false,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      psession_lens = {
        previewer = false,
      },
      pre_save_cmds = { "Neotree close" },
    }
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
  lazy = false
}
