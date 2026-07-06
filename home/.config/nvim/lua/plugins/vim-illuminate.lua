return {
  'RRethy/vim-illuminate',
  event = { "BufReadPre", "BufNewFile" },
  -- nvim-treesitter master branch's `locals` module is incompatible with
  -- Neovim 0.12 (get_scopes returns tables instead of TSNodes), so the
  -- treesitter provider crashes. Use lsp/regex only.
  opts = {
    providers = { 'lsp', 'regex' },
  },
  config = function(_, opts)
    require('illuminate').configure(opts)
  end,
}
