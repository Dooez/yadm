return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        "otavioschwanck/arrow.nvim",
    },
    config = function()
        local lualine = require('lualine')
        local conditions = {
            buffer_not_empty = function()
                return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
            end,
            hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end,
            check_git_workspace = function()
                local filepath = vim.fn.expand('%:p:h')
                local gitdir = vim.fn.finddir('.git', filepath .. ';')
                return gitdir and #gitdir > 0 and #gitdir < #filepath
            end,
        }
        local statusline = require('arrow.statusline')
        local arrow_fmt = function()
            local empty = '·'
            local present = ''
            local selected = ''
            local extra = '󰇘'
            local extra_selected = '󰟃'
            local max_len = 5
            local format = ''
            local n_empty = max_len

            local arrow_filenames = vim.g.arrow_filenames
            local cur_idx = statusline.is_on_arrow_file()
            if arrow_filenames then
                for i, _ in ipairs(arrow_filenames) do
                    if i <= max_len then
                        local tail = i < max_len and ' ' or ''
                        if cur_idx and i == cur_idx then
                            format = format .. selected .. tail
                        else
                            format = format .. present .. tail
                        end
                    else
                        if cur_idx and cur_idx >= i then
                            format = format .. ' ' .. extra_selected
                        else
                            format = format .. ' ' .. extra
                        end
                        break
                    end
                    n_empty = n_empty - 1
                end
            end
            if n_empty > 0 then
                for i = 1, n_empty - 1, 1 do
                    format = format .. empty .. ' '
                end
                format = format .. empty
            end
            return format
        end

        local config = {
            options = {
                component_separators = '',
                section_separators = '',
                theme = 'catppuccin',
            },
            sections = {
                -- these are to remove the defaults
                lualine_a = {
                    'mode',
                },
                lualine_b = {
                    arrow_fmt,
                },
                lualine_c = {
                    {
                        'filetype',
                        icon_only = true,
                        padding = { left = 1, right = 0 },
                    },
                    {
                        'filename',
                        -- separator = '',
                        icons_enabled = true,
                        cond = function()
                            return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
                        end
                    },
                    -- {
                    --    function()
                    --       return navic.get_location()
                    --    end,
                    --    cond = function()
                    --       return navic.is_available()
                    --    end
                    -- }
                },
                lualine_x = {
                },
                lualine_y = {
                    {
                        'diagnostics',
                        sources = { 'nvim_diagnostic', 'nvim_lsp' },
                        sections = { 'error', 'warn', 'info', 'hint' },
                    },
                    'progress' },
                lualine_z = {
                },
            },
        }
        lualine.setup(config)
    end

}
