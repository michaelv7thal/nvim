 return {
    "airblade/vim-rooter",
    config = function()
      -- Automatically set root based on Git or parent folder
      vim.g.rooter_manual_only = 0 -- Automatically change cwd
      vim.g.rooter_patterns = { '.git', 'Makefile', 'package.json' } -- Detect Git or project files
      vim.g.rooter_resolve_links = 1
    end,
  }
