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
}
