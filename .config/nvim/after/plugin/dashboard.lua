
-- ~/.config/nvim/lua/custom/dashboard.lua
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local ascii = require("ascii")

-- ===== Header =====
dashboard.section.header.val = ascii.art.sharp or { "Welcome to NeoVim" }
vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#00afff", bold = true })
dashboard.section.header.opts.hl = "DashboardHeader"

-- ===== Crear highlights =====
vim.api.nvim_set_hl(0, "DashboardButton", { fg = "#deffa0" })        -- blau per text + icona
vim.api.nvim_set_hl(0, "DashboardShortcut", { fg = "#E6DB74", bold = true }) -- groc + negreta per shortcut

-- ===== Funció per crear botons =====
local function button(shortcut, icon, desc, cmd)
    local text = icon .. "  " .. desc        -- icona + text junts, color blau
    local b = dashboard.button(shortcut, text, cmd)
    b.opts.hl = "DashboardButton"
    b.opts.hl_shortcut = "DashboardShortcut"
    return b
end

-- ===== Botons =====
dashboard.section.buttons.val = {
    button("ff", "", "Find File", ":Telescope find_files<CR>"),
    button("fo", "", "Recent Files", ":Telescope oldfiles<CR>"),
    button("fw", "", "Find Word", ":Telescope live_grep<CR>"),
    button("bm", "", "Bookmarks", ":Telescope marks<CR>"),
    button("th", "", "Themes", ":Telescope themes<CR>"),
    button("es", "", "Settings", ":e $MYVIMRC<CR>"),
    button("q",  "", "Quit", ":qa<CR>"),
}

-- ===== Configurar Alpha =====
alpha.setup(dashboard.opts)

