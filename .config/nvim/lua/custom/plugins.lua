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
 
  -- Ascii Art
  {
    "MaximilianLloyd/ascii.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
  },

  -- Alpha dashboard
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- opcional, para iconos
  },

  -- Transparent Background
  {
    "tribela/vim-transparent",
    config = function()
      vim.cmd("colorscheme onedark_swany")

      vim.g.transparent_enabled = true

      vim.cmd [[
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalFloat guibg=NONE ctermbg=NONE
        hi SignColumn guibg=NONE
        hi VertSplit guibg=NONE
        hi StatusLine guibg=NONE
        hi LineNr guibg=NONE
      ]]
    end,
  },
}
