return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },


  -- Auto close and rename HTML tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile", "InsertEnter" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
