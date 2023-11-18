require('packer').startup(function(use)
    -- List of plugins
    use 'wbthomason/packer.nvim' -- Packer can manage itself
    use 'junegunn/seoul256.vim'
    use 'tpope/vim-fugitive'
    use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
    use 'junegunn/fzf.vim'
    use 'sainnhe/everforest'
    use { 'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true } }
    use 'airblade/vim-gitgutter'
    use 'preservim/tagbar'
    use 'folke/tokyonight.nvim'
    use 'morhetz/gruvbox'
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = { { 'nvim-lua/plenary.nvim' } } }
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'
    use 'sharkdp/fd'
    use({ 'rose-pine/neovim', as = 'rose-pine' })
    use 'windwp/nvim-autopairs'
    use 'rafamadriz/friendly-snippets' -- Set of preconfigured snippets
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
    use 'mbbill/undotree'
    use 'theprimeagen/harpoon'
    use 'nvimtools/none-ls.nvim'
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'neovim/nvim-lspconfig' }, -- LSP Config
            { 'hrsh7th/nvim-cmp' },      -- Completion
            { 'hrsh7th/cmp-nvim-lsp' },  -- LSP source for nvim-cmp
            { 'hrsh7th/cmp-buffer' },    -- Buffer completions
            { 'hrsh7th/cmp-path' },      -- Path completions
            { 'hrsh7th/cmp-cmdline' },   -- Cmdline completions

        }
    }
end)
