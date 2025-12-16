-- ╔═══════════════════════════════════════════════════════════╗
-- ║                Plugin Management (lazy.nvim)              ║
-- ╚═══════════════════════════════════════════════════════════╝

require("lazy").setup({
  -- Import all plugin configurations from the plugins directory
  { import = "plugins.ui" },
  { import = "plugins.treesitter" },
  { import = "plugins.lsp" },
  { import = "plugins.cmp" },
  { import = "plugins.telescope" },
  { import = "plugins.git" },
  { import = "plugins.dap" },
  { import = "plugins.formatting" },
  { import = "plugins.utils" },
}, {
  -- Lazy.nvim configuration
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
