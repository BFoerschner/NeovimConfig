local function get_setup(name)
  return string.format('require("setup/%s")', name)
end

require("packer").startup(function(use)
  use({
    "wbthomason/packer.nvim",
    "EdenEast/nightfox.nvim",
    "marko-cerovac/material.nvim",
    "godlygeek/tabular",
    "mg979/vim-visual-multi",
    "roobert/tailwindcss-colorizer-cmp.nvim",
    "farmergreg/vim-lastplace",
    "AndrewRadev/splitjoin.vim",
    {
      "williamboman/mason-lspconfig.nvim",
      requires = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "windwp/nvim-autopairs",
      },
      config = get_setup("mason"),
    },
    "onsails/diaglist.nvim",
    "simrat39/symbols-outline.nvim",
    "norcalli/nvim-colorizer.lua",
    "rafamadriz/friendly-snippets",
    "voldikss/vim-floaterm",
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup({
          opleader = { line = "<C-/>" },
          toggler = { line = "<C-/>" },
        })
      end,
    },
    {
      "onsails/lspkind.nvim", -- fancy icons
      config = function()
        require("lspkind").init()
      end,
    },
    {
      "lewis6991/impatient.nvim",
      config = function()
        require("impatient")
      end,
    },
    {
      "kwkarlwang/bufresize.nvim",
      config = function()
        require("bufresize").setup()
      end,
    },
    "windwp/nvim-autopairs",
    {
      "michaelb/sniprun",
      run = "bash ./install.sh",
    },
    "amarakon/nvim-cmp-fonts",
    {
      "folke/trouble.nvim",
      -- requires = "kyazdani42/nvim-web-devicons",
      requires = "nvim-tree/nvim-web-devicons",
      config = function()
        require("trouble").setup({})
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      run = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup()
        vim.cmd([[hi TreesitterContextBottom gui=underline guisp=Grey]])
        vim.cmd([[hi TreesitterContextLineNumber guisp=Red]])
      end,
      requires = {
        "nvim-treesitter/nvim-treesitter",
      },
    },
    {
      "smjonas/inc-rename.nvim",
      config = function()
        require("inc_rename").setup()
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.x",
      requires = {
        { "nvim-lua/plenary.nvim" },
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        },
        { "nvim-telescope/telescope-file-browser.nvim" },
        { "nvim-telescope/telescope-project.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
      config = function()
        require("telescope").setup({
          extensions = {
            project = {
              base_dirs = {
                "~/dev",
                "~/.config",
              },
              hidden_files = true, -- default: false
              theme = "dropdown",
              order_by = "asc",
              search_by = "title",
              sync_with_nvim_tree = true, -- default false
            },
          },
        })
        require("telescope").load_extension("file_browser")
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      run = "make install_jsregexp",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load({
          history = false,
        })

        function Leave_snippet()
          if ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
              and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
              and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end

        -- stop snippets when you leave to normal mode
        vim.api.nvim_command([[
          autocmd ModeChanged * lua Leave_snippet()
        ]])
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      requires = {
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-git" },
      },
      config = function()
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0
              and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        local icons = {
          Text = "",
          Method = "",
          Function = "",
          Constructor = "",
          Field = "ﰠ",
          Variable = "",
          Class = "ﴯ",
          Interface = "",
          Module = "",
          Property = "ﰠ",
          Unit = "塞",
          Value = "",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "",
          Struct = "פּ",
          Event = "",
          Operator = "",
          TypeParameter = "",
        }

        cmp.setup({
          enabled = function()
            -- disable completion in comments
            local context = require("cmp.config.context")
            -- keep command mode completion enabled when cursor is in a comment
            if vim.api.nvim_get_mode().mode == "c" then
              return true
            else
              return not context.in_treesitter_capture("comment")
                  and not context.in_syntax_group("Comment")
            end
          end,
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            end,
          },
          formatting = {
            format = lspkind.cmp_format({
              mode = "symbol_text",
              -- preset = 'codicons',
              maxwidth = 80,
              menu = { -- showing type in menu
                nvim_lsp = "[LSP]",
                path = "[Path]",
                buffer = "[Buffer]",
                luasnip = "[LuaSnip]",
              },
              before = function(entry, vim_item)
                if vim_item.kind == "Color" and entry.completion_item.documentation then
                  local _, _, r, g, b =
                  string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
                  if r then
                    local color = string.format("%02x", r)
                        .. string.format("%02x", g)
                        .. string.format("%02x", b)
                    -- local group = 'Tw_' .. color
                    local group = "Tw_" .. color
                    if vim.fn.hlID(group) < 1 then
                      vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
                      -- vim.api.nvim_set_hl(0, group, {fg = blackOrWhiteFg(r, g, b), bg = '#' .. color})
                    end
                    vim_item.kind = "⬤ Color"
                    vim_item.kind_hl_group = group
                    -- vim_item.abbr_hl_group = group
                    return vim_item
                  end
                end
                vim_item.kind = icons[vim_item.kind] and (icons[vim_item.kind] .. " " .. vim_item.kind)
                    or vim_item.kind
                -- vim_item.kind = icons[vim_item.kind] and icons[vim_item.kind] or vim_item.kind
                return vim_item
              end,
            }),
            fields = { "kind", "abbr", "menu" },
          },
          window = {
            completion = {
              -- border = 'rounded',
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
              col_offset = -3,
              -- side_padding = 0,
            },
            documentation = {
              border = "rounded",
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            },
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete()),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-n>"] = {
              c = function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end,
            },
            ["<C-p>"] = {
              c = function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end,
            },
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                else
                  if entry then
                    cmp.confirm()
                  else
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                  end
                end
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp", priority = 10 },
            { name = "nvim_lua", priority = 5 },
            { name = "luasnip", priority = 4 },
            { name = "buffer" },
            { name = "path" },
            { name = "rg" },
          }),
          experimental = { ghost_text = true },
        })

        -- Set configuration for specific filetype.
        -- Only enable `fonts` for `conf` and `config` file types
        require("cmp").setup.filetype({ "conf", "config" }, {
          sources = {
            { name = "fonts", option = { space_filter = "-" } },
          },
        })

        cmp.setup.filetype("gitcommit", {
          sources = cmp.config.sources({
            { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
            { name = "buffer" },
          }),
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = "path" },
            { name = "cmdline" },
          }),
        })

        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
    {
      "vinnymeller/swagger-preview.nvim",
      run = "npm install -g swagger-ui-watcher",
    },
    {
      "navarasu/onedark.nvim",
      config = function()
        require("onedark").setup({
          style = "darker",
        })
        vim.cmd("colorscheme onedark")
      end,
    },
    {
      "MunifTanjim/prettier.nvim",
      config = function()
        local prettier = require("prettier")

        prettier.setup({
          bin = "prettier", -- or `'prettierd'` (v0.22+)
          filetypes = {
            "css",
            "graphql",
            "html",
            "javascript",
            "javascriptreact",
            "json",
            "less",
            "markdown",
            "scss",
            "typescript",
            "typescriptreact",
            "yaml",
          },
        })
      end,
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        local null_ls = require("null-ls")

        local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
        local event = "BufWritePre" -- or "BufWritePost"
        local async = event == "BufWritePost"

        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.xmlformat,
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.beautysh,
            null_ls.builtins.formatting.crystal_format,
            null_ls.builtins.formatting.dart_format,
            null_ls.builtins.formatting.fixjson,
            null_ls.builtins.formatting.gofmt,
            null_ls.builtins.formatting.goimports,
            null_ls.builtins.formatting.goimports_reviser,
            null_ls.builtins.formatting.google_java_format,
            null_ls.builtins.formatting.reorder_python_imports,
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.markdownlint,
            null_ls.builtins.formatting.nginx_beautifier,
            null_ls.builtins.formatting.nimpretty,
            null_ls.builtins.formatting.rustfmt,
            null_ls.builtins.formatting.rustywind,
            null_ls.builtins.formatting.shellharden,
            null_ls.builtins.formatting.sqlfluff.with({
              extra_args = { "--dialect", "postgres" }, -- change to your dialect
            }),
            null_ls.builtins.formatting.taplo,
            null_ls.builtins.formatting.terrafmt,
            null_ls.builtins.formatting.terraform_fmt,
            null_ls.builtins.formatting.yamlfmt,
          },
          on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
              vim.keymap.set("n", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
              end, { buffer = bufnr, desc = "[lsp] format" })

              -- format on save
              vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
              vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = function()
                  vim.lsp.buf.format({ bufnr = bufnr, async = async })
                end,
                desc = "[lsp] format on save",
              })
            end

            if client.supports_method("textDocument/rangeFormatting") then
              vim.keymap.set("x", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
              end, { buffer = bufnr, desc = "[lsp] format" })
            end
          end,
        })
      end,
    },
    {
      "folke/noice.nvim",
      requires = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        "smjonas/inc-rename.nvim",
      },
      config = function()
        require("noice").setup({
          messages = {
            enabled = true, -- enables the Noice messages UI
            view_error = "mini",
            view_warn = "mini", -- view for warnings
          },
          routes = {
            { -- hide insert messages
              filter = {
                find = "INSERT",
              },
              opts = { skip = true },
            },
            { -- hide written messages
              filter = {
                event = "msg_show",
                kind = "",
                find = "written",
              },
              opts = { skip = true },
            },
            { -- Show @recording messages
              view = "notify",
              filter = { event = "msg_showmode" },
            },
          },
          hover = {
            enabled = true,
          },
          presets = {
            long_message_to_split = true, -- long messages will be sent to a split
            lsp_doc_border = true, -- add a border to hover docs and signature help
            inc_rename = true,
          },
          lsp = {
            signature = {
              enabled = false,
            },
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
          },
        })
      end,
    },
    {
      "kevinhwang91/nvim-ufo",
      requires = "kevinhwang91/promise-async",
      config = function()
        vim.o.foldcolumn = "0" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        require("ufo").setup({
          provider_selector = function()
            return { "treesitter", "indent" }
          end,
        })
      end,
    },
    {
      "iamcco/markdown-preview.nvim",
      run = "cd app && npm install",
      setup = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
      },
      config = function()
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

        vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

        require("neo-tree").setup({
          close_if_last_window = true,
          popup_border_style = "rounded",
          enable_git_status = true,
          enable_diagnostics = true,
          sources = {
            "filesystem", -- Neotree filesystem source
          },
          window = {
            mappings = {
              ["o"] = "open",
            },
          },
        })
      end,
    },
    {
      "ray-x/lsp_signature.nvim",
      config = function()
        require("lsp_signature").setup({
          noice = false,
          hint_enable = false,
          floating_window = true,
          fix_pos = true,
          hint_prefix = "λ ",
          hi_parameter = "LspSignatureActiveParameter",
        })
      end,
    },
    {
      "m-demare/hlargs.nvim",
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("hlargs").setup()
      end,
    },
    {
      "feline-nvim/feline.nvim",
      config = function()
        require("feline").setup()
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      -- tag = 'release', -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
      config = function()
        require("gitsigns").setup()
      end,
    },
    {
      "utilyre/barbecue.nvim",
      requires = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- optional dependency
      },
      after = "nvim-web-devicons", -- keep this if you're using NvChad
      config = function()
        require("barbecue").setup()
      end,
    },
    {
      "stevearc/overseer.nvim",
      config = function()
        require("overseer").setup()
      end,
    },
    {
      "stevearc/dressing.nvim",
      config = function()
        require("dressing").setup({})
      end,
    },
    {
      "catppuccin/nvim",
      as = "catppuccin",
    },
    {
      "petertriho/nvim-scrollbar",
      config = function()
        require("scrollbar").setup({
          show_in_active_only = true,
          hide_if_all_visible = true,
          handlers = {
            cursor = true,
            gitsigns = true,
          },
        })
      end,
    },
    {
      "chomosuke/term-edit.nvim",
      tag = "v1.*",
      config = function()
        require("term-edit").setup({
          prompt_end = "%$ ",
        })
      end,
    },
    {
      "akinsho/toggleterm.nvim",
      tag = "*",
      config = function()
        require("toggleterm").setup()
      end,
    },
  })
end)
