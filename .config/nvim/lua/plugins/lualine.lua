return {
   {
      'nvim-lualine/lualine.nvim',
      dependencies = {
         'nvim-tree/nvim-web-devicons',
         'abeldekat/harpoonline',
         -- "SmiteshP/nvim-navic",
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
         -- local navic = require('nvim-navic')
         local harpoonline = require("harpoonline")
         harpoonline.setup({
            icon = "",
            custom_formatter = 
               function(data)
                  local empty = '·'
                  local present = ''
                  local selected = ''
                  local extra = '󰇘'
                  local extra_selected = '󰟃'
                  local max_len = 5
                  local format = ''
                  local n_present = math.min(#data.items, max_len)
                  for i = 1, n_present do
                     if data.active_idx and data.active_idx == i then
                        format = format .. selected .. ' '
                     else
                        format = format .. present .. ' '
                     end
                  end
                  for i = n_present + 1, max_len do
                     format = format .. empty .. ' '
                  end
                  if #data.items > max_len then
                     if data.active_idx and data.active_idx > max_len then
                        format = format .. extra_selected
                     else
                        format = format .. extra
                     end
                  else
                     format = format:sub(1, -2)
                  end
                  return format
               end
            ,
            on_update = function() require("lualine").refresh() end,

         })

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
                  harpoonline.format,
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
}
