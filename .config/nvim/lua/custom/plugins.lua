return {
  -- NERDTree
  {
    "preservim/nerdtree",
    cmd = "NERDTreeToggle",
  },

  -- Prettier
  {
    "prettier/vim-prettier",
    lazy = false,
    run = "yarn install --frozen-lockfile --production",
    ft = { "javascript", "typescript", "css", "json", "html" },
  },

  -- Comment.nvim
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
    keys = {
      { "<leader>/", mode = { "n", "v" } }
    },
  },

  -- Telescope (ja inclòs a NVChad, però reforcem integració)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
  },
}
