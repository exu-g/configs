-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Treesitter: Jinja overlay highlighting for ansible (yaml.ansible)
do
  vim.treesitter.language.register("yaml", "yaml.ansible")

  local group = vim.api.nvim_create_augroup("ansible-jinja", { clear = true })

  local function add_jinja_matches()
    vim.fn.clearmatches()
    local hl = {
      ["{{[^}]*}}"] = "Special", -- {{ var }}
      ["{%[^%]*%}"] = "Statement", -- {% if ... %}
      ["{#[^#]*#}"] = "Comment", -- {# comment #}
    }
    for pat, hl_group in pairs(hl) do
      vim.fn.matchadd(hl_group, pat)
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "yaml.ansible",
    callback = function(args)
      vim.treesitter.start(args.buf, "yaml")
      -- matchadd is window-local: only apply if this buffer is actually shown
      if vim.api.nvim_win_get_buf(0) == args.buf then
        add_jinja_matches()
      end
    end,
  })

  -- re-apply when the buffer enters a new window (splits, previews)
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    pattern = "*",
    callback = function(args)
      if vim.bo[args.buf].filetype == "yaml.ansible" then
        add_jinja_matches()
      end
    end,
  })
end
