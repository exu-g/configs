return {
  "nvim-mini/mini.files",
  config = function(_, opts)
    -- Default config
    require("mini.files").setup(opts)

    -- Default config
    local files_set_cwd = function()
      local cur_entry_path = MiniFiles.get_fs_entry().path
      local cur_directory = vim.fs.dirname(cur_entry_path)
      if cur_directory ~= nil then
        vim.fn.chdir(cur_directory)
      end
    end

    -- Default config
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id

        -- Set Enter key to chdir
        vim.keymap.set(
          "n",
          opts.mappings and opts.mappings.change_cwd or "<cr>",
          files_set_cwd,
          { buffer = args.data.buf_id, desc = "Set cwd" }
        )
      end,
    })
  end,
}
