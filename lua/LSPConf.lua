-- -- https://github.com/VonHeikemen/lsp-zero.nvim#you-might-not-need-lsp-zero
-- require("mason").setup()
--
-- -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
-- require("mason-lspconfig").setup({
-- 	ensure_installed = {
-- 		-- Replace these with whatever servers you want to install
-- 		-- "rust_analyzer",
-- 		"sumneko_lua",
-- 		-- "tsserver",
-- 		-- "pyright",
-- 		-- "tailwindcss",
-- 		-- "html",
-- 		-- "marksman",
-- 		-- "lemminx",
-- 		-- "svelte",
-- 		-- -- "gopls",
-- 		"dockerls",
-- 	},
-- 	-- automatic_installation = true
-- })
--
-- local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
-- local lsp_attach = function(_, bufnr)
-- 	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
--
-- 	-- Mappings.
-- 	-- See `:help vim.lsp.*` for documentation on any of the below functions
-- 	local bufopts = { noremap = true, silent = true, buffer = bufnr }
-- 	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
-- 	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
-- 	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
-- 	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
-- 	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
-- 	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
-- 	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
-- 	vim.keymap.set("n", "<leader>wl", function()
-- 		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 	end, bufopts)
-- 	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
-- 	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
-- 	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
-- 	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
-- 	vim.keymap.set("n", "<leader>f", function()
-- 		vim.lsp.buf.format({ async = true })
-- 	end, bufopts)
-- end
--
-- local lspconfig = require("lspconfig")
-- require("mason-lspconfig").setup_handlers({
-- 	function(server_name)
-- 		lspconfig[server_name].setup({
-- 			on_attach = lsp_attach,
-- 			capabilities = lsp_capabilities,
-- 		})
-- 	end,
-- })
--
-- require("lspconfig").sumneko_lua.setup({
-- 	settings = {
-- 		Lua = {
-- 			diagnostics = {
-- 				-- Get the language server to recognize the `vim` global
-- 				globals = { "vim" },
-- 			},
-- 		},
-- 	},
-- })
--
-- require("lspconfig").gopls.setup({
-- 	settings = {
-- 		gopls = {
-- 			experimentalPostfixCompletions = true,
-- 			analyses = {
-- 				unusedparams = true,
-- 				shadow = true,
-- 			},
-- 			staticcheck = true,
-- 		},
-- 	},
-- 	init_options = {
-- 		usePlaceholders = true,
-- 	},
-- })
