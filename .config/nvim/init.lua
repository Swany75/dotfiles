-- Ruta cache base46
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Bootstrap lazy i plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- Configuració de lazy (venint de NVChad)
local lazy_config = require "configs.lazy"

-- Carregar plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  -- Plugins personalitzats (carregats des de lua/custom/plugins.lua)
  { import = "custom.plugins" },

}, lazy_config)

-- Carregar tema NVChad
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- Opcions generals i autocmds (venen de NVChad configs)
require "options"
require "autocmds"

-- Vim 

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]

-- Carregar mappings personalitzats (des de lua/custom/mappings.lua)
vim.schedule(function()
  require "custom.mappings"
end)
