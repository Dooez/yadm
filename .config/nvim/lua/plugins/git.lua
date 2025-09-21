return {
    {
        'tpope/vim-fugitive', -- git commands,
        config = function()
            require("which-key").add({
                {
                    '<leader>gc',
                    '<cmd>Git commit<cr>',
                    desc = '[G]it [C]ommit'
                },
                {
                    '<leader>gp',
                    '<cmd>Git push<cr>',
                    desc = '[G]it [P]ush'
                },
            })
        end
    },
    { -- git diffview
        'sindrets/diffview.nvim',
        dependencies = {
            'rcarriga/nvim-notify',
        },
        opts = {
            file_panel = {
                listing_style = 'list',
                win_config = {
                    position = 'bottom',
                    height = 16,
                },
            },
        },
        keys = {
            {
                '<leader>gd',
                '<cmd>DiffviewOpen<cr>',
                desc = 'Open [G]it [D]iff panel.',
            },
            {
                '<leader>gh',
                '<cmd>DiffviewFileHistory --reflog<cr>',
                desc = 'Open [G]it [H]istroy panel.',
            },
            {
                '<leader>gq',
                '<cmd>DiffviewClose<cr>',
                desc = '[G]it panel [Q]uit.',
            },
        }
    },
    {
        'FabijanZulj/blame.nvim',
        dependencies = 'sindrets/diffview.nvim',
        keys = {
            {
                '<leader>gb',
                '<CMD>BlameToggle<CR>',
                desc = 'Show [G]it [B]lame',
            },
        },
        opts = {
            commit_detail_view = function(commit, row, path)
                vim.cmd('DiffviewOpen ' .. commit .. ' --selected-file=' .. path);
            end,
        }

    },
    {
        "harrisoncramer/gitlab.nvim",
        lazy = false,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            -- "stevearc/dressing.nvim",                                -- Recommended but not required. Better UI for pickers.
            "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
            'folke/which-key.nvim',
        },
        build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
        keys = {
            {
                '<leader>glC',
                function() require('gitlab').choose_merge_request() end,
                desc = '[C]hoose merge request'
            },
            {
                '<leader>glS',
                function() require('gitlab').review() end,
                desc = '[S]tart review'
            },
            {
                '<leader>glo',
                function() require('gitlab').open_in_browser() end,
                desc = '[O]pen in browser'
            },
            {
                '<leader>gln',
                function() require('gitlab').create_note() end,
                desc = 'Create [N]ote'
            },
            {
                '<leader>glc',
                function() require('gitlab').create_comment() end,
                desc = 'Create [C]omment'
            },
        },
        opts = {
            disable_all = false,    -- Disable all mappings created by the plugin
            help = "g?",            -- Open a help popup for local keymaps when a relevant view is focused (popup, discussion panel, etc)
            global = {
                disable_all = true, -- Disable all global mappings created by the plugin
                -- add_assignee = "<leader>glaa",
                -- delete_assignee = "<leader>glad",
                -- add_label = "<leader>glla",
                -- delete_label = "<leader>glld",
                -- add_reviewer = "<leader>glra",
                -- delete_reviewer = "<leader>glrd",
                -- approve = "<leader>glA",              -- Approve MR
                -- revoke = "<leader>glR",               -- Revoke MR approval
                -- merge = "<leader>glM",                -- Merge the feature branch to the target branch and close MR
                -- create_mr = "<leader>glC",            -- Create a new MR for currently checked-out feature branch
                -- choose_merge_request = "<leader>glc", -- Chose MR for review (if necessary check out the feature branch)
                -- start_review = "<leader>glS",         -- Start review for the currently checked-out branch
                -- summary = "<leader>gls",              -- Show the editable summary of the MR
                -- copy_mr_url = "<leader>glu",          -- Copy the URL of the MR to the system clipboard
                -- open_in_browser = "<leader>glo",      -- Openthe URL of the MR in the default Internet browser
                -- create_note = "<leader>gln",          -- Create a note (comment not linked to a specific line)
                -- pipeline = "<leader>glp",             -- Show the pipeline status
                -- toggle_discussions = "<leader>gld",   -- Toggle the discussions window
                -- toggle_draft_mode = "<leader>glD",    -- Toggle between draft mode (comments posted as drafts) and live mode (comments are posted immediately)
                -- publish_all_drafts = "<leader>glP",   -- Publish all draft comments/notes
            },

        },
        config = function(plugin, opts)
            require("gitlab").setup(opts)
            require("which-key").add({
                {
                    '<leader>gl',
                    group = '[G]it[L]ab',
                },
            })
        end,
    },
    {
        'isakbm/gitgraph.nvim',
        dependencies = { 'sindrets/diffview.nvim' },
        ---@type I.GGConfig
        opts = {
            git_cmd = "git",
            format = {
                timestamp = '%H:%M %d.%m.%y',
                fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
            },
            hooks = {
                -- Check diff of a commit
                on_select_commit = function(commit)
                    vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
                    vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
                end,
                -- Check diff from commit a -> commit b
                on_select_range_commit = function(from, to)
                    vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
                    vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
                end,
            },
            symbols = {
                merge_commit = '',
                commit = '',
                merge_commit_end = '◉',
                commit_end = '●',
                GVER = '│',
                GHOR = '─',
                GCLD = '┐',
                GCRD = '┌',
                GCLU = '┘',
                GCRU = '└',
                GLRU = '┴',
                GLRD = '┬',
                GLUD = '┤',
                GRUD = '├',
                GFORKU = '┼',
                GFORKD = '┼',
                GRUDCD = '├',
                GRUDCU = '├',
                GLUDCD = '┤',
                GLUDCU = '┤',
                GLRDCL = '┬',
                GLRDCR = '┬',
                GLRUCL = '┴',
                GLRUCR = '┴',
                --
                -- merge_commit = '',
                -- commit = '',
                -- merge_commit_end = '',
                -- commit_end = '',
                --
                -- -- Advanced symbols
                -- GVER = '',
                -- GHOR = '',
                -- GCLD = '',
                -- GCRD = '╭',
                -- GCLU = '',
                -- GCRU = '',
                -- GLRU = '',
                -- GLRD = '',
                -- GLUD = '',
                -- GRUD = '',
                -- GFORKU = '',
                -- GFORKD = '',
                -- GRUDCD = '',
                -- GRUDCU = '',
                -- GLUDCD = '',
                -- GLUDCU = '',
                -- GLRDCL = '',
                -- GLRDCR = '',
                -- GLRUCL = '',
                -- GLRUCR = '',
            },
        },
        keys = {
            {
                "<leader>gL",
                function()
                    require('gitgraph').draw({}, { all = true, max_count = 5000 })
                end,
                desc = "GitGraph - Draw",
            },
        },
    },
}
