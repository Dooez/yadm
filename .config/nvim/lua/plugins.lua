return {
    {
        'NMAC427/guess-indent.nvim', config = true,
    },
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        opts = {}
    },
    {
        "williamboman/mason.nvim",
        opts = { pip = { upgrade_pip = true, }, }

    },
    {
        'nvim-treesitter/nvim-treesitter',
        depenencies = "OXY2DEV/markview.nvim",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'c', 'cpp', 'lua', 'doxygen', 'vim', 'vimdoc', 'markdown', 'markdown_inline',
                    'regex', 'bash',
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    -- additional_vim_regex_highlighting = false
                },
            })
        end
    },
    {
        "https://codeberg.org/grafcube/suedit.nvim",
        dependencies = "akinsho/toggleterm.nvim",
    },
    -- special buffers
    { -- tabs line
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        after = 'catppuccin',
        config = function()
            require('bufferline').setup({
                options = {
                    mode = 'tabs',
                    style_preset = require('bufferline').style_preset.minimal,
                    always_show_bufferline = false,
                },
                highlights = require("catppuccin.special.bufferline").get_theme()
            })
        end
    },
    { -- filesystem explorer
        'stevearc/oil.nvim',
        event = "VeryLazy",
        enabled = not vim.g.have_yazi,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            "<leader>e",
            mode = { "n", "v" },
            "<cmd>Oil<cr>",
            desc = "Open Oil at the current file.",
        },
        opts = {
            default_file_explorer = true,
            columns = {
                'icon',
            },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-l>"] = false,
            },
            keymap_help = {
                border = "square",
            },
            skip_confirm_on_simple_edits = true,
            lsp_file_methods = {
                autosave_changes = true,
            },
            experimental_watch_for_changes = true,
        },
        config = true,
    },
    {
        "mikavilpas/yazi.nvim",
        enabled = vim.g.have_yazi,
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        keys = {
            {
                "<leader>e",
                mode = { "n", "v" },
                "<cmd>Yazi<cr>",
                desc = "Open yazi at the current file",
            },
            {
                -- Open in the current working directory
                "<leader>cw",
                "<cmd>Yazi cwd<cr>",
                desc = "Open the file manager in nvim's working directory",
            },
            {
                "<c-up>",
                "<cmd>Yazi toggle<cr>",
                desc = "Resume the last yazi session",
            },
        },
        opts = {
            -- if you want to open yazi instead of netrw, see below for more info
            open_for_directories = true,
            yazi_floating_window_border = "single",
            keymaps = {
                show_help = "g?",
            },
        },
        init = function()
            vim.g.loaded_netrwPlugin = 1
        end,
    },
    {
        "sohanemon/flash.yazi",
        enabled = vim.g.have_yazi,
        lazy = true,
        build = function(plugin)
            require("yazi.plugin").build_plugin(plugin)
        end,
    },
    -- editing and navigtaion
    {
        'echasnovski/mini.ai',
        version = '*'
    },
    {
        'numToStr/Comment.nvim',
        config = true,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
        config = function()
            require 'nvim-autopairs'.setup({
                enable_check_bracket_line = false,
            })
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
    { -- docs generation
        "danymat/neogen",
        event = "VeryLazy",
        config = true,
    },
    { -- additional navigtaion engine
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = { "o" },           function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

    -- visual
    { -- context folds at the top of the buffer
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
            multiwindow = true,
            max_lines = 5,
            min_window_height = 30,
            multiline_threshold = 1,
        },
        config = true,
    },
    { -- folds
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        },
        opts = {},
    },
    'RRethy/vim-illuminate', -- highlight word under the cursor
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = '┆',
                tab_char = '┆',
            },
            scope = {
                char = '║',
                show_start = false,
                show_end = false,
            },
        }
    },
    {
        'echasnovski/mini.animate',
        version = false,
        enabled = not vim.g.perf_animate,
        config = function()
            local qdtiming = require('mini.animate').gen_timing.quadratic({
                duration = 150,
                unit = 'total',
            })
            require('mini.animate').setup({
                cursor = { timing = qdtiming },
                scroll = { timing = qdtiming },
                resize = { enable = false },
                open = { enable = false },
                close = { enable = false },
            })
        end,
    },
    {
        'gen740/SmoothCursor.nvim',
        enabled = vim.g.perf_animate,
        opts = {
            fancy = {
                enable = true,
                head = false,
                body = {
                    { cursor = "󰝥", texthl = "lineHl" },
                    { cursor = "󰝥", texthl = "lineHl" },
                    { cursor = "●", texthl = "lineHl" },
                    { cursor = "●", texthl = "lineHl" },
                    { cursor = "•", texthl = "lineHl" },
                    { cursor = ".", texthl = "lineHl" },
                    { cursor = ".", texthl = "lineHl" },
                },
                speed = 100,
            },
        },
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false, -- Recommended
        -- ft = "markdown" -- If you decide to lazy-load anyway

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            experimental = {
                check_rtp_message = false,
            },
        },
    },
    {
        "amitds1997/remote-nvim.nvim",
        version = "*",                       -- Pin to GitHub releases
        dependencies = {
            "nvim-lua/plenary.nvim",         -- For standard functions
            "MunifTanjim/nui.nvim",          -- To build the plugin UI
            "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
        },
        config = true,
    },
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
        keys = {
            {
                "<C-w>p",
                mode = { "n", "x", "o" },
                function()
                    local win = require('window-picker').pick_window({ hint = 'floating-big-letter' });
                    if win then
                        vim.api.nvim_set_current_win(win)
                    end
                end,
                desc = "[P]ick window"
            },
        },
        config = function()
            require 'window-picker'.setup()
        end,
    },
    {
        'brenoprata10/nvim-highlight-colors',
        config = true,
    },
    {
        "otavioschwanck/arrow.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            -- or if using mini.icons
            -- { "echasnovski/mini.icons" },
        },
        opts = {
            separate_by_branch = true,
            show_icons = true,
            leader_key = ';',        -- Recommended to be a single key
            buffer_leader_key = 'm', -- Per Buffer Mappings
            index_keys = "asdfg1234567890wertzxcbnmZXVBNM,hjklAFGHJKLwrtyuiopWRTYUIOP",
            mappings = {
                edit = 'E',
                toggle = 'T',
                delete_mode = 'D',
            }
        },
    },

}
