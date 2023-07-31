return {
  {
    "patstockwell/vim-monokai-tasty",
    config = function()
      vim.cmd("let g:vim_monokai_tasty_italic = 1")
      vim.cmd("let g:vim_monokai_tasty_machine_tint = 1")
      vim.cmd("let g:vim_monokai_tasty_highlight_active_window = 1")
      vim.cmd("let g:airline_theme='monokai_tasty'")
      vim.cmd("let g:lightline = { 'colorscheme': 'monokai_tasty' } ")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vim-monokai-tasty",
    },
  },
}
