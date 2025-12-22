require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- General keybindings
-- jk or kj to go to normal mode from insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Alt + hjkl to resize splits
map("n", "<M-h>", "<C-w><", { desc = "Resize split left" })
map("n", "<M-j>", "<C-w>-", { desc = "Resize split down" })
map("n", "<M-k>", "<C-w>+", { desc = "Resize split up" })
map("n", "<M-l>", "<C-w>>", { desc = "Resize split right" })

-- Control + hjkl to navigate splits
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Control + s to save
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<ESC><cmd>w<CR>", { desc = "Save file and exit insert mode" })

-- Control + q to save and quit
map("n", "<C-q>", "<cmd>wq<CR>", { desc = "Save and quit" })

-- Tab and Shift+Tab for buffer navigation
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Control + b to close buffer
map("n", "<C-b>", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- Visual mode keybindings
-- Shift + < or > to indent/unindent
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Shift + j or k to move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Plugin keybindings
-- Space + f for fuzzy search (Telescope)
map("n", "<leader>f", "<cmd>Telescope find_files<CR>", { desc = "Find files" })

-- Space + / for commenting (Comment.nvim)
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

map("v", "<leader>/", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment" })

-- Space + n for NerdTree (nvim-tree)
map("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- Space + p for Prettier formatting
map("n", "<leader>p", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format document" })

-- Shift + K for documentation (LSP hover)
map("n", "K", vim.lsp.buf.hover, { desc = "Show documentation" })
