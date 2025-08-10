return {
    {
        "stevearc/conform.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            formatters_by_ft = {
                cpp = { "clang_format" },
                python = { "isort", "black" },
                cmake = { "cmakelang" },
            },
        },
        keys = {
            {
                '<leader>f',
                function() require('conform').format({ lsp_fallback = true }) end,
                desc = "[F]ormat current buffer",
            }
        },
    },
    {
        "zapling/mason-conform.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "stevearc/conform.nvim",
        },
        config = true,
    },
}
