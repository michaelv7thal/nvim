return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
        "lewis6991/async.nvim",
    },
    lazy = false,
    config = function()
        -- refactoring.nvim no longer ships a Telescope extension; the picker is
        -- now require("refactoring").select_refactor() (see keymaps.lua).
        require("refactoring").setup({
            show_success_message = true,
        })
    end,
}
