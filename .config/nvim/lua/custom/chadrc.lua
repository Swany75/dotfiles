local M = {}

-- Configuració de plugins addicionals o modificats
M.plugins = {
  user = require "custom.plugins", -- els teus plugins personalitzats
  override = {}, -- aquí pots sobreescriure plugins que venen per defecte
}

-- Opcions d'usuari personalitzades
M.ui = {
  theme = "onedark_swany",   -- o el que prefereixis (nvchad té varis)
  transparent_mode = true, -- true si vols transparència
  statusline = {
    theme = "default",
  },
}

-- Mappings personalitzats (clau → acció)
M.mappings = require "custom.mappings"

-- Opcions addicionals, si vols pots posar-les aquí
M.options = {
  -- per exemple
  relativenumber = true,
  wrap = false,
}

return M
