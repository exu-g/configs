return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required

      -- Only one of these is needed.
      "sindrets/diffview.nvim", -- optional
      -- "esmuellert/codediff.nvim", -- optional

      -- Only one of these is needed.
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "nvim-mini/mini.pick",           -- optional
      "folke/snacks.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
    opts = {
      -- Change the default way of opening neogit
      -- kind = "floating",
      -- Floating window style
      floating = {
        -- relative = "editor",
        width = 0.98,
        height = 0.98,
        -- style = "minimal",
        border = "rounded", -- rounded, none
      },
      mappings = {
        popup = {
          -- unset original keys
          -- Push
          ["P"] = false,
          -- Reset
          ["X"] = false,
          -- Pull
          ["p"] = false,
          -- Revert
          ["v"] = false,
          -- set new keys
          -- Push
          ["p"] = "PushPopup",
          -- Reset
          ["O"] = "ResetPopup",
          -- Pull
          ["F"] = "PullPopup",
          -- Revert
          ["_"] = "RevertPopup",
        },
      },
    },
  },
}
