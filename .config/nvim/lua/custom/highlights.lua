-- ~/.config/nvim/lua/custom/highlights.lua
-- One Dark + transparencia real (terminal manda el fondo)

local M = {}

M.override = {
  -- Base (TRANSPARENTE)
  Normal        = { fg = "#abb2bf", bg = "NONE" },
  NormalFloat   = { fg = "#abb2bf", bg = "NONE" },
  SignColumn    = { bg = "NONE" },
  EndOfBuffer   = { fg = "#3e4452" },

  -- Comentarios y literales
  Comment   = { fg = "#5c6370", italic = true },
  Constant  = { fg = "#d19a66" },
  String    = { fg = "#98c379" },
  Number    = { fg = "#d19a66" },
  Boolean   = { fg = "#56b6c2" },

  -- Keywords & Functions
  Keyword     = { fg = "#c678dd", italic = true },
  Function    = { fg = "#61afef" },
  Identifier  = { fg = "#e5c07b" },

  -- Diagnostics
  Error            = { fg = "#e06c75", bold = true },
  WarningMsg       = { fg = "#e5c07b" },
  DiagnosticError  = { fg = "#e06c75" },
  DiagnosticWarn   = { fg = "#e5c07b" },
  DiagnosticInfo   = { fg = "#61afef" },
  DiagnosticHint   = { fg = "#56b6c2" },

  -- Cursor & Selección (ligero contraste, NO fondo sólido)
  Cursor       = { fg = "#282c34", bg = "#abb2bf" },
  CursorLine   = { bg = "#2c323c" },
  Visual       = { bg = "#3e4452" },

  -- Números de línea
  LineNr        = { fg = "#4b5263", bg = "NONE" },
  CursorLineNr  = { fg = "#61afef", bg = "NONE" },

  -- Statusline (semi-transparente)
  StatusLine    = { fg = "#abb2bf", bg = "NONE", bold = true },
  StatusLineNC  = { fg = "#5c6370", bg = "NONE" },

  -- Tabs
  TabLine       = { fg = "#5c6370", bg = "NONE" },
  TabLineSel    = { fg = "#abb2bf", bg = "#3e4452", bold = true },

  -- Menús (aquí SÍ tiene sentido fondo)
  Pmenu         = { fg = "#abb2bf", bg = "#21252b" },
  PmenuSel      = { fg = "#282c34", bg = "#61afef", bold = true },
  PmenuSbar     = { bg = "#2c323c" },
  PmenuThumb    = { bg = "#61afef" },

  -- Splits
  VertSplit     = { fg = "#3e4452", bg = "NONE" },
}

return M

