return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
    enabled = true,
    config = function()
      require("easy-dotnet").setup()
    end
  }
}
