-- ~/.config/nvim/lua/custom/highlights.lua
-- Tokyo Night - Kitty Edition per NVChad

local M = {}

M.override = {
  -- Base
  Normal = { fg = "#a9b1d6", bg = "#1a1b26" },
  NormalFloat = { fg = "#a9b1d6", bg = "#1a1b26" },

  -- Comentaris i literals
  Comment = { fg = "#414868", italic = true },
  Constant = { fg = "#bb9af7" },
  String = { fg = "#73daca" },
  Number = { fg = "#e0af68" },
  Boolean = { fg = "#f7768e" },

  -- Keywords & Functions
  Keyword = { fg = "#7aa2f7", italic = true },
  Function = { fg = "#7dcfff" },
  Identifier = { fg = "#c0caf5" },

  -- Diagnostics
  Error = { fg = "#f7768e", bold = true },
  WarningMsg = { fg = "#e0af68" },
  DiagnosticError = { fg = "#f7768e" },
  DiagnosticWarn = { fg = "#e0af68" },
  DiagnosticInfo = { fg = "#7aa2f7" },
  DiagnosticHint = { fg = "#73daca" },

  -- Cursor & Selection
  Cursor = { fg = "#1a1b26", bg = "#c0caf5" },
  CursorLine = { bg = "#28344a" },
  Visual = { bg = "#28344a" },

  -- Line numbers
  LineNr = { fg = "#414868" },
  CursorLineNr = { fg = "#7aa2f7" },
  SignColumn = { bg = "#1a1b26" },

  -- Statusline & Tabline
  StatusLine = { fg = "#c0caf5", bg = "#414868" },
  StatusLineNC = { fg = "#414868", bg = "#1a1b26" },
  TabLine = { fg = "#414868", bg = "#1a1b26" },
  TabLineSel = { fg = "#1a1b26", bg = "#7aa2f7" },
}

return M
