return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        -- Set config file for markdownlint-cli2
        -- see https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-15525364
        ["markdownlint-cli2"] = {
          prepend_args = {
            "--config",
            vim.fn.stdpath("config") .. "/linters/markdownlint-cli2.yaml",
            "--",
          },
        },
      },
    },
  },
}
