return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require('catppuccin').setup({
            flavour = 'macchiato',
            color_overrides = {
                macchiato = {
                    surface2 = "#4e5468",
                    surface1 = "#414656",
                    surface0 = "#313542",
                    base = "#242730",
                    mantle = "#1c1f26",
                    crust = "#181B21",
                    rosewater = "#e1b9b9",
                    pink = "#d68fb8",
                    mauve = "#b394de",
                    red = "#e07f7f",
                    peach = "#f5a97f",
                    yellow = "#d9b445",
                    green = "#92bf8e",
                    teal = "#4cbaa4",
                    blue = "#82a2d9",
                    lavender = "#b1b6e2",
                    text = "#d9d1c9",
                    subtext1 = "#b3aca6",
                    subtext0 = "#a19b96",
                    overlay2 = "#8c8781",
                    overlay1 = "#807b76",
                    overlay0 = "#736e6b",
                },
            },
            custom_highlights = function(colors)
                local generic = colors.red
                local class = colors.blue
                local string = colors.yellow
                local fn = colors.green
                local const = colors.mauve
                local iface = colors.rosewater
                local member = colors.lavender

                return {
                    Constant = { fg = const },
                    String = { fg = string },
                    Character = { fg = string },
                    Number = { fg = const },
                    Boolean = { fg = const },
                    Identifier = { fg = colors.text },
                    Function = { fg = fn },
                    Statement = { fg = generic },
                    Conditional = { link = "Statement" },
                    Repeat = { fg = generic },
                    Label = { link = "Statement" },
                    Operator = { fg = generic },
                    Keyword = { fg = generic },
                    Exception = { fg = generic },

                    PreProc = { fg = colors.red },
                    Include = { fg = colors.red },
                    Macro = { fg = colors.red, style = { 'bold' } },

                    StorageClass = { fg = generic },
                    Structure = { fg = colors.sapphire },
                    Special = { fg = generic },
                    Type = { fg = class },
                    ['@module'] = { fg = colors.text, style = {} },
                    ['@parameter'] = { fg = colors.peach, style = { 'italic' } },
                    ['@lsp.type.class'] = { fg = class },
                    ['@lsp.type.concept'] = { fg = iface },
                    ['@lsp.mod.readonly'] = { fg = const },
                    ['@lsp.typemod.variable.static'] = { fg = member, style = { 'bold' } },
                    ['@lsp.typemod.method.readonly'] = { link = "@lsp.type.method" },
                    ['@lsp.typemod.parameter.readonly'] = { link = "@parameter" },
                    ['@function.builtin'] = { link = "Funciton" },
                    ['@type.builtin'] = { link = 'Type' },
                    ['@type.builtin.cpp'] = { link = 'Type' },
                    ['@attribute'] = { fg = colors.subtext0 },
                    ['@keyword.return'] = { link = 'Keyword' },
                    ['@keyword.operator'] = { link = 'Keyword' },
                    ['@keyword.doxygen'] = { fg = colors.subtext0 },

                    ['IlluminatedWordText'] = { bg = colors.surface0 },
                }
            end,
            integrations = {
                indent_blankline = {
                    scope_color = 'surface2'
                },
                noice = true,
            },

        })
        vim.cmd.colorscheme "catppuccin"
    end
}
