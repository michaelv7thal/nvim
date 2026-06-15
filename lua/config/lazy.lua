-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit...", "WarningMsg" },
		}, true, {})
		vim.fn.getchar()
		vim.cmd("quit")
	end
end
vim.opt.rtp:prepend(lazypath)

-- Leader keys are set in init.lua before this module is required.

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Import plugins from the "plugins" directory
		{ import = "plugins" },
	},
})
