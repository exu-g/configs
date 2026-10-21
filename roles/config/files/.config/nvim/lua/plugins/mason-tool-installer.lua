return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      -- a list of all tools you want to ensure are installed upon start
      ensure_installed = {
        "ansible-language-server",
        "ansible-lint",
        "ast-grep",
        "basedpyright",
        "bash-debug-adapter",
        "bash-language-server",
        "clangd",
        "debugpy",
        "djlint",
        "docker-compose-language-service",
        "docker-compose-linter",
        "dockerfile-language-server",
        "dockerfmt",
        "fish-lsp",
        "hadolint",
        "java-debug-adapter",
        "jdtls",
        "jinja-lsp",
        "json-lsp",
        "lua-language-server",
        "markdown-toc",
        "markdownlint-cli2",
        "marksman",
        "powershell-editor-services",
        "prettier",
        "pyright",
        "ruff",
        "shellcheck",
        "shfmt",
        "sqlfluff",
        "sqlfmt",
        "sqlls",
        "stylua",
        "taplo",
        "tinymist",
        "tree-sitter-cli",
        "typstyle",
        "yaml-language-server",
        "yamllint",
      },

      -- if set to true this will check each tool for updates. If updates
      -- are available the tool will be updated. This setting does not
      -- affect :MasonToolsUpdate or :MasonToolsInstall.
      -- Default: false
      auto_update = true,

      -- automatically install / update on startup. If set to false nothing
      -- will happen on startup. You can use :MasonToolsInstall or
      -- :MasonToolsUpdate to install tools and check for updates.
      -- Default: true
      run_on_start = true,

      -- Only attempt to install if 'debounce_hours' number of hours has
      -- elapsed since the last time Neovim was started. This stores a
      -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
      -- This is only relevant when you are using 'run_on_start'. It has no
      -- effect when running manually via ':MasonToolsInstall' etc....
      -- Default: nil
      debounce_hours = 5, -- at least 5 hours between attempts to install/update
    },
  },
}
