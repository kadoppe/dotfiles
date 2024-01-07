return  {
  "kiyoon/jupynium.nvim",
  build = "pip3 install --user .",
  lazy = false,
  -- build = "conda run --no-capture-output -n jupynium pip install .",
  -- enabled = vim.fn.isdirectory(vim.fn.expand "~/miniconda3/envs/jupynium"),
  dependencies = {
    { "rcarriga/nvim-notify" },
    { "stevearc/dressing.nvim" }
  },
  config = function()
    require("jupynium").setup({
      default_notebook_URL = "localhost:8888/nbclassic",
      auto_start_server = {
        enable = false,
        file_pattern = { "*.ju.*" },
      },
    })
  end
}
