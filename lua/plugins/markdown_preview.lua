return {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        config = function()
            -- Use wslview to open URLs in Zen Browser via Windows
            vim.g.mkdp_browserfunc = function(url)
                vim.fn.system({ "wslview", url })
            end

            vim.g.mkdp_auto_start = 1
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_refresh_slow = 0
            vim.g.mkdp_command_for_global = 0
        end,
  }
