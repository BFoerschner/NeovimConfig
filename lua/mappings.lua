-- vim.keymap.set("n", "<C-S-l>", ":vsplit<CR><C-w>l:Telescope find_files<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-S-j>", ":split<CR><C-w>j:Telescope find_files<CR>", { noremap = true, silent = true })
-------------------
-- control mappings
-------------------

-- clear search highlights
vim.keymap.set("n", "<C-C>", ":noh<CR>", { silent = true, nowait = true })
-- grep root directory with ripgrep
vim.keymap.set("n", "<C-g>", ":lua require'telescope.builtin'.live_grep{}<CR>", { silent = true, nowait = true })
-- find files like the old ctrl-p plugin
vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { silent = true, nowait = true })
-- open project-selector
vim.keymap.set(
	"n",
	"<C-b>",
	":lua require'telescope'.extensions.project.project{display_type = 'full'}<CR>",
	{ noremap = true, silent = true }
)
-- toggle filetree
vim.keymap.set("n", "<C-f>", ":Neotree toggle<CR>", { noremap = true, silent = true })
-- move between splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
-- open lazygit in Floaterm
vim.keymap.set(
	"n",
	"<C-q>",
	":FloatermNew --autoclose=2 --width=0.9 --height=0.9 --wintype=float --name=floaterm1 lazygit<CR>",
	{ noremap = true, silent = true }
)
-- open tasks
vim.keymap.set("n", "<C-t>", ":OverseerRun<CR>", { noremap = true, silent = true })

------------------
-- leader mappings
------------------

-- switch buffer to previous file
vim.keymap.set("n", "<leader><leader>", ":bprevious<CR>", { noremap = true, silent = true })
-- open Quickfix window
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
-- open Quickfix window for this buffer
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
-- open split on the right, move cursor to the right split and open filepicker
vim.keymap.set("n", "<leader>vs", ":vsplit<CR><C-w>l:Telescope find_files<CR>", { noremap = true, silent = true })
-- open split on the bottom, move cursor to the bottom split and open filepicker
vim.keymap.set("n", "<leader>hs", ":split<CR><C-w>j:Telescope find_files<CR>", { noremap = true, silent = true })
-- open Floating Terminal
vim.keymap.set(
	"n",
	"<leader>t",
	":FloatermNew --autoclose=2 --width=0.9 --height=0.9 --wintype=float<CR>",
	{ noremap = true, silent = true }
)
-- rename symbol with lsp
vim.keymap.set("n", "<leader>rn", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

----------------
-- misc mappings
----------------
vim.keymap.set("n", " ", "za", { noremap = true, silent = true })
