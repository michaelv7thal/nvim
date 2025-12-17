return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    config = function()
        require("refactoring").setup({
            show_success_message = true,
        })

        -- Load Telescope extension
        require("telescope").load_extension("refactoring")
    end,
}
