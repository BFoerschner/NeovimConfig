-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.api.nvim_set_keymap

map("n", ",,", ":buffer #<CR>", { noremap = true, silent = true })

map("n", "<M-S-l>", ":vsplit<CR>", { noremap = true, silent = true })
map("n", "<M-S-h>", ":vsplit<CR><C-W>h", { noremap = true, silent = true })
map("n", "<M-S-j>", ":split<CR>", { noremap = true, silent = true })
map("n", "<M-S-k>", ":split<CR><C-W>k", { noremap = true, silent = true })

map("n", ",vs", ":vsplit<CR><C-W>h", { noremap = true, silent = true })
map("n", ",hs", ":split<CR><C-W>k", { noremap = true, silent = true })

map("n", "<Leader>cc", "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
map("n", "<Leader>co", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })

map("n", "<C-F>", "<cmd>Neotree toggle<cr>", { noremap = true, silent = true })
