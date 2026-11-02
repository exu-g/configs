-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

require("vim._core.ui2").enable({
  msg = {
    targets = "cmd",
    dialog = { height = 0.5 },
    msg = { height = 0.5 },
    pager = { height = 0.999 },
  },
})

-- Set GUI font, see https://neovim.io/doc/user/options/#'guifont'
vim.opt.guifont = "Maple Mono NL NF:h11"

-- Enable virtual lines for lsp errors
vim.diagnostic.config({ virtual_lines = true })
