return {
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        enabled = false,
        dependencies = {
            'williamboman/mason.nvim',
        },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                lua = { "luacheck" },
                cpp = { "clangtidy" },
            }

            local function debounce(ms, fn)
                local timer = vim.loop.new_timer()
                return function()
                    timer:start(ms, 0, function()
                        timer:stop()
                        vim.schedule_wrap(fn)()
                    end)
                end
            end

            local events = { "BufWritePost", "BufReadPost", "InsertLeave" }
            vim.api.nvim_create_autocmd(events, {
                group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
                callback = debounce(100, lint.try_lint),
            })
        end,
    },
}
