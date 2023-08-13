return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  event = { "BufReadPre " .. vim.fn.expand "~" .. "/Obsidian/kadoppe/**.md" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    dir = "~/Obsidian/kadoppe/",
    notes_subdir = "notes",
    daily_notes = {
      folder = "Daily Notes",
    },
    disable_frontmatter = true,
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    vim.keymap.set("n", "gf", function()
      if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
      else
        return "gf"
      end
    end, { noremap = false, expr = true })

    vim.keymap.set("n", "<leader>fo", "<cmd>ObsidianQuickSwitch<CR>", { silent = true, noremap = true })
  end,
}
