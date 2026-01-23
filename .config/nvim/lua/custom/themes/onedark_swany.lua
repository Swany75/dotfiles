-- ~/.config/nvim/lua/custom/themes/onedark_swany.lua
local M = {}

M.colors = {
  bg        = "#1a1b26",
  fg        = "#a9b1d6",
  black     = "#414868",
  red       = "#f7768e",
  green     = "#73daca",
  yellow    = "#e0af68",
  blue      = "#7aa2f7",
  magenta   = "#bb9af7",
  cyan      = "#7dcfff",
  white     = "#c0caf5",
}

M.highlights = {
  Normal    = { fg = M.colors.fg, bg = "NONE" },
  NormalNC  = { fg = M.colors.fg, bg = "NONE" },
  Comment   = { fg = M.colors.black, italic = true },
  Keyword   = { fg = M.colors.blue, italic = true },
  String    = { fg = M.colors.green },
  Number    = { fg = M.colors.yellow },
  Boolean   = { fg = M.colors.red },
  Function  = { fg = M.colors.cyan },
  Identifier = { fg = M.colors.white },
}

return M
