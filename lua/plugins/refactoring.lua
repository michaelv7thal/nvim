return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
  },
  lazy = false,
  config = function()
    local refactoring = require("refactoring")

    refactoring.setup({
      -- Show messages on refactoring
      show_success_message = true,

      -- Print debugging info
      print_var_statements = {
        python = { 'print(f"{%s=}")' },
        lua = { 'print("%s: ", %s)' },
        javascript = { 'console.log("%s", %s)' },
        typescript = { 'console.log("%s", %s)' },
      },
    })

    -- Load refactoring Telescope extension
    require("telescope").load_extension("refactoring")
  end,
}
