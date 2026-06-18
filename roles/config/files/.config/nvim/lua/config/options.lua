-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set GUI font to monospace with size 11
vim.opt.guifont = "Monospace:h11"

-- Enable virtual lines for lsp errors
vim.diagnostic.config({ virtual_lines = true })
