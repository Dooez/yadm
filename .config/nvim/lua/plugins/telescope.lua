return {
    'nvim-telescope/telescope.nvim',
    --branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function() return vim.fn.executable 'make' == 1 end
        },
        'MunifTanjim/nui.nvim',
    },
    keys = {
        {
            '<leader>/',
            function()
                require('telescope.builtin').current_buffer_fuzzy_find(
                    require('telescope.themes').get_dropdown {
                        winblend = 10,
                        previewer = false
                    }
                )
            end,
            desc = '[/] Fuzzily search in current buffer',
        },
        {
            '<leader>gf',
            require('telescope.builtin').git_files,
            desc = 'Search [G]it [F]iles',
        },
        -- {
        --     '<leader>sf',
        --     require('telescope.builtin').find_files,
        --     desc = '[S]earch [F]iles',
        -- },
        {
            '<leader>sh',
            require('telescope.builtin').help_tags,
            desc = '[S]earch [H]elp',
        },
        {
            '<leader>sg',
            require('telescope.builtin').live_grep,
            desc = '[S]earch by [G]rep',
        },
        {
            '<leader>sd',
            require('telescope.builtin').diagnostics,
            desc = '[S]earch [D]iagnostics',
        },
        {
            '<leader>sc',
            require('telescope.builtin').commands,
            desc = '[S]earch [C]ommands',
        },
        {
            '<leader>sr',
            require('telescope.builtin').resume,
            desc = '[S]earch [R]esume',
        },
        {
            '<leader>sm',
            function()
                require('telescope.builtin').lsp_document_symbols({
                    symbols = 'method',
                    show_line = true,
                    symbol_type_width = 8,
                })
            end,
            desc = '[S]earch [M]ethods',
        },
        {
            '<leader>sM',
            function()
                require('telescope.builtin').lsp_document_symbols({
                    symbols = 'field',
                    show_line = true,
                    symbol_type_width = 8,
                })
            end,
            desc = '[S]earch Data [M]embers',
        },

    },
    config = function()
        local Popup = require("nui.popup")
        local Layout = require("nui.layout")

        local telescope = require("telescope")
        local TSLayout = require("telescope.pickers.layout")

        local function make_popup(options)
            local popup = Popup(options)
            function popup.border:change_title(title)
                popup.border.set_text(popup.border, "top", title)
            end

            return TSLayout.Window(popup)
        end
        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        require('telescope').setup {
            defaults = {
                mappings = { i = { ['<C-u>'] = false, ['<C-d>'] = false } },
                layout_strategy = "vertical",
                layout_config = {
                    horizontal = {
                        size = {
                            width = "90%",
                            height = "90%",
                        },
                    },
                    vertical = {
                        size = {
                            width = "90%",
                            height = "90%",
                        },
                    },
                },
                create_layout = function(picker)
                    local border = {
                        results = {
                            top_left = "┌",
                            top = "─",
                            top_right = "┬",
                            right = "│",
                            bottom_right = "",
                            bottom = "",
                            bottom_left = "",
                            left = "│",
                        },
                        results_patch = {
                            minimal = {
                                top_left = "┌",
                                top_right = "┐",
                            },
                            horizontal = {
                                top_left = "┌",
                                top_right = "┬",
                            },
                            vertical = {
                                top_left = "├",
                                top_right = "┤",
                            },
                        },
                        prompt = {
                            top_left = "├",
                            top = "─",
                            top_right = "┤",
                            right = "│",
                            bottom_right = "┘",
                            bottom = "─",
                            bottom_left = "└",
                            left = "│",
                        },
                        prompt_patch = {
                            minimal = {
                                bottom_right = "┘",
                            },
                            horizontal = {
                                bottom_right = "┴",
                            },
                            vertical = {
                                bottom_right = "┘",
                            },
                        },
                        preview = {
                            top_left = "┌",
                            top = "─",
                            top_right = "┐",
                            right = "│",
                            bottom_right = "┘",
                            bottom = "─",
                            bottom_left = "└",
                            left = "│",
                        },
                        preview_patch = {
                            minimal = {},
                            horizontal = {
                                bottom = "─",
                                bottom_left = "",
                                bottom_right = "┘",
                                left = "",
                                top_left = "",
                            },
                            vertical = {
                                bottom = "",
                                bottom_left = "",
                                bottom_right = "",
                                left = "│",
                                top_left = "┌",
                            },
                        },
                    }

                    local results = make_popup({
                        focusable = false,
                        border = {
                            style = border.results,
                            text = {
                                top = picker.results_title,
                                top_align = "center",
                            },
                        },
                        win_options = {
                            winhighlight = "NormalFloat:NormalFloat",
                        },
                    })

                    local prompt = make_popup({
                        enter = true,
                        border = {
                            style = border.prompt,
                            text = {
                                top = picker.prompt_title,
                                top_align = "center",
                            },
                        },
                        win_options = {
                            winhighlight = "NormalFloat:NormalFloat",
                        },
                    })

                    local preview = make_popup({
                        focusable = false,
                        border = {
                            style = border.preview,
                            text = {
                                top = picker.preview_title,
                                top_align = "center",
                            },
                        },
                        win_options = {
                            winhighlight = "NormalFloat:NormalFloat",
                        },
                    })

                    local box_by_kind = {
                        vertical = Layout.Box({
                            Layout.Box(preview, { grow = 1 }),
                            Layout.Box(results, { grow = 1 }),
                            Layout.Box(prompt, { size = 3 }),
                        }, { dir = "col" }),
                        horizontal = Layout.Box({
                            Layout.Box({
                                Layout.Box(results, { grow = 1 }),
                                Layout.Box(prompt, { size = 3 }),
                            }, { dir = "col", size = "50%" }),
                            Layout.Box(preview, { size = "50%" }),
                        }, { dir = "row" }),
                        minimal = Layout.Box({
                            Layout.Box(results, { grow = 1 }),
                            Layout.Box(prompt, { size = 3 }),
                        }, { dir = "col" }),
                    }

                    local function get_box()
                        local strategy = picker.layout_strategy
                        if strategy == "vertical" or strategy == "horizontal" then
                            return box_by_kind[strategy], strategy
                        end

                        local height, width = vim.o.lines, vim.o.columns
                        local box_kind = "horizontal"
                        if width < 100 then
                            box_kind = "vertical"
                            if height < 40 then
                                box_kind = "minimal"
                            end
                        end
                        return box_by_kind[box_kind], box_kind
                    end

                    local function prepare_layout_parts(layout, box_type)
                        layout.results = results
                        results.border:set_style(border.results_patch[box_type])

                        layout.prompt = prompt
                        prompt.border:set_style(border.prompt_patch[box_type])

                        if box_type == "minimal" then
                            layout.preview = nil
                        else
                            layout.preview = preview
                            preview.border:set_style(border.preview_patch[box_type])
                        end
                    end

                    local function get_layout_size(box_kind)
                        return picker.layout_config[box_kind == "minimal" and "vertical" or box_kind].size
                    end

                    local box, box_kind = get_box()
                    local layout = Layout({
                        relative = "editor",
                        position = "50%",
                        size = get_layout_size(box_kind),
                    }, box)

                    layout.picker = picker
                    prepare_layout_parts(layout, box_kind)

                    local layout_update = layout.update
                    function layout:update()
                        local box, box_kind = get_box()
                        prepare_layout_parts(layout, box_kind)
                        layout_update(self, { size = get_layout_size(box_kind) }, box)
                    end

                    return TSLayout(layout)
                end,
            },
        }
        -- Enable telescope fzf native, if installed
        pcall(require('telescope').load_extension, 'fzf')
    end
}
