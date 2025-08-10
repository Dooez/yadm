return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim'
    },
    keys = {
        { '<leader>ha', function() require('harpoon'):list():add() end,                                    desc = "[H]arpoon [A]dd to List" },
        { '<leader>hr', function() require('harpoon'):list():remove() end,                                 desc = "[H]arpoon [R]emove from List" },

        { '<C-e>',      function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'Show Harpoon List' },

        { "<F11>",      function() require('harpoon'):list():select(1) end,                                desc = "Harpoon select entry 1." },
        { "<F12>",      function() require('harpoon'):list():select(2) end,                                desc = "Harpoon select entry 2." },
        { "<F13>",      function() require('harpoon'):list():select(3) end,                                desc = "Harpoon select entry 3." },
        { "<F14>",      function() require('harpoon'):list():select(4) end,                                desc = "Harpoon select entry 4." },
        { "<F15>",      function() require('harpoon'):list():select(5) end,                                desc = "Harpoon select entry 5." },
    },
    config = true,
}
