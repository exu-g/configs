return {
  -- { "akinsho/bufferline.nvim", enabled = false },
  {
    "folke/snacks.nvim",
    keys = {
      -- Disable explorer keys
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
      -- Disable zen keys
      { "<leader>uz", false },
    },
    opts = {
      -- Disable explorer
      explorer = { enabled = false },
      -- Disable scroll animation
      scroll = { enabled = false },
      -- Disable zen
      zen = { enabled = false },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      -- Disable redundant virtual_text at the end of lines (using virtual_lines instead)
      diagnostics = {
        virtual_text = false,
      },
    },
  },
}
