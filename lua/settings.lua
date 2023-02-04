-- opts
--vim.opt.updatetime = 250 -- Apparently obsolete now due to bugfix in neovim
vim.opt.smartcase = true
vim.opt.autoread = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 1
vim.opt.autowrite = true
vim.opt.modelines = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.smarttab = true
vim.opt.backspace = "indent,eol,start"
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.hidden = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo"
vim.opt.undolevels = 1000
vim.opt.history = 100
vim.opt.viminfo = "'100,f1"
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.opt.foldenable = false
vim.opt.updatetime = 100
vim.opt.cmdheight = 0
vim.opt.timeoutlen = 300

-- global
vim.g.mapleader = ","

-- wo
vim.wo.signcolumn = "yes"
