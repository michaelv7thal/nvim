return {
    {
        'https://codeberg.org/esensar/nvim-dev-container',
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
        },
        opts = {
            -- Configuration options
            attach_mounts = {
                -- Mount your nvim config into containers (readonly for safety)
                neovim_config = {
                    enabled = true,
                    options = { "readonly" }
                },
                -- Mount custom data like plugins (disabled to avoid conflicts)
                neovim_data = {
                    enabled = false,
                    options = {}
                },
                -- Always mount current working directory
                always_mount = true,
            },
            -- Auto-start devcontainer when opening project with devcontainer.json
            autocommands = {
                init = false,  -- Set to true to auto-start on VimEnter
                clean = true,  -- Clean up on VimLeavePre
                update = true, -- Auto-update containers
            },
            -- Log settings
            log_level = "info", -- "trace", "debug", "info", "warn", "error"

            -- FIX: Explicitly set container runtime instead of "auto"
            -- The plugin will use this command directly
            container_runtime = "docker", -- Change to "podman" if you use Podman

            -- Compose file support
            compose_command = "docker-compose", -- or "podman-compose"
        },
        config = function(_, opts)
            require("devcontainer").setup(opts)

            -- Keymaps for devcontainer commands
            local keymap = vim.keymap.set
            local prefix = "<leader>d" -- Dev container prefix

            -- Main operations
            keymap("n", prefix .. "c", "<cmd>DevcontainerStart<cr>",
                { desc = "DevContainer: Start" })

            keymap("n", prefix .. "s", "<cmd>DevcontainerStop<cr>",
                { desc = "DevContainer: Stop" })

            keymap("n", prefix .. "a", "<cmd>DevcontainerAttach<cr>",
                { desc = "DevContainer: Attach" })

            keymap("n", prefix .. "r", "<cmd>DevcontainerRemove<cr>",
                { desc = "DevContainer: Remove" })

            -- Information and logs
            keymap("n", prefix .. "i", "<cmd>DevcontainerInfo<cr>",
                { desc = "DevContainer: Info" })

            keymap("n", prefix .. "l", "<cmd>DevcontainerLogs<cr>",
                { desc = "DevContainer: Logs" })

            -- Advanced operations
            keymap("n", prefix .. "e", "<cmd>DevcontainerExec<cr>",
                { desc = "DevContainer: Execute command" })

            keymap("n", prefix .. "b", "<cmd>DevcontainerBuild<cr>",
                { desc = "DevContainer: Build" })

            -- Optional: Add a "which-key" style hint if you have which-key.nvim
            local has_which_key, which_key = pcall(require, "which-key")
            if has_which_key then
                which_key.register({
                    [prefix] = { name = "+devcontainer" }
                })
            end
        end,
    },
}
