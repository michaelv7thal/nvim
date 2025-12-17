return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile", "InsertEnter" },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
}
