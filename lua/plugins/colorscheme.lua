
return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = flase,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme rose-pine]])
		end,
	},
}
