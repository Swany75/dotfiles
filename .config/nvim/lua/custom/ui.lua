vim.g.transparent_enabled = true

local highlights = {
  Normal = { bg = "none", fg = "#a9b1d6" },        -- foreground de Kitty
  NormalFloat = { bg = "none", fg = "#a9b1d6" },
  VertSplit = { bg = "none", fg = "#414868" },
  StatusLine = { bg = "none", fg = "#c0caf5" },
}
for group, colors in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, colors)
end
