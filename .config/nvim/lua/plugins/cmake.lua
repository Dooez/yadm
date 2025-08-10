return {
    'Civitasv/cmake-tools.nvim',
    -- commit = 'd6fa30479c5f392f6f80b4b2e542f91155b289a8',
    dependencies = {
        "nvim-lua/plenary.nvim",
        'mfussenegger/nvim-dap',
        'stevearc/overseer.nvim',
        'akinsho/toggleterm.nvim',
    },
    config = function()
        require("cmake-tools").setup {
            cmake_command = "cmake",                                          -- this is used to specify cmake command path
            cmake_regenerate_on_save = true,                                  -- auto generate when save CMakeLists.txt
            cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
            cmake_build_options = {},                                         -- this will be passed when invoke `CMakeBuild`
            -- support macro expansion:
            --       ${kit}
            --       ${kitGenerator}
            --       ${variant:xx}
            cmake_build_directory = "build",             -- this is used to specify generate directory for cmake, allows macro expansion
            cmake_soft_link_compile_commands = true,     -- this will automatically make a soft link from compile commands file to project root dir
            cmake_compile_commands_from_lsp = false,     -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
            cmake_kits_path = nil,                       -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
            cmake_variants_message = {
                short = { show = true },                 -- whether to show short message
                long = { show = true, max_length = 40 }, -- whether to show long message
            },
            cmake_dap_configuration = {                  -- debug settings for cmake
                name = "cpp",
                type = "codelldb",
                request = "launch",
                stopOnEntry = false,
                runInTerminal = true,
                console = "integratedTerminal",
            },
            cmake_executor = {                       -- executor to use
                name = "quickfix",                   -- name of the executor
                opts = {
                    auto_close_when_success = false, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
                }
            },
            cmake_runner = {
                name = "quickfix",
                opts = {
                    auto_close_when_success = false, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
                }
            },
            cmake_notifications = {
                enabled = true, -- show cmake execution progress in nvim-notify
                spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
                refresh_rate_ms = 100, -- how often to iterate icons
            },
        }

        vim.keymap.set('n', '<leader>cb', '<Cmd>CMakeBuild<CR>', { desc = '[C]Make [B]uild' })
        vim.keymap.set('n', '<leader>cd', '<Cmd>CMakeDebug<CR>', { desc = '[C]Make [D]ebug' })
        vim.keymap.set('n', '<leader>csb', '<Cmd>CMakeSelectBuildTarget<CR>',
            { desc = '[C]Make [S]elect [B]uild Target' })
        vim.keymap.set('n', '<leader>csp', '<Cmd>CMakeSelectBuildPreset<CR>',
            { desc = '[C]Make [S]elect Build [P]reset' })
        vim.keymap.set('n', '<leader>cst', '<Cmd>CMakeSelectBuildType<CR>',
            { desc = '[C]Make [S]elect Build [T]ype' })
        vim.keymap.set('n', '<leader>csk', '<Cmd>CMakeSelectKit<CR>',
            { desc = '[C]Make [S]elect [K]it' })
        vim.keymap.set('n', '<leader>csl', '<Cmd>CMakeSelectLaunchTarget<CR>',
            { desc = '[C]Make [S]elect [L]aunch Target' })
    end
}
