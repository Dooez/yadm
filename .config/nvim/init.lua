vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
-- require("lazy").setup()

vim.o.conceallevel = 2
vim.o.clipboard = 'unnamedplus'
-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false
vim.wo.foldlevel = 99

vim.o.scrolloff = 8
vim.o.startofline = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'number'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
-- vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

--vim.keymap.set('n', '<leader>z', 'zA', { desc = 'Toggle fold under cursor recureively' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true })
-- Diagnostic keymaps
-- vim.keymap.set('n', '[3', vim.diagnostic.goto_prev,
--   { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']3', vim.diagnostic.goto_next,
--   { desc = 'Go to next diagnostic message' })
--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
--{ desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist,
--   { desc = 'Open diagnostics list' })
-- See `:help telescope.builtin`
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
--   { desc = '[?] Find recently opened files' })

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to the left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to the down window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to the up window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to the right window' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.open_float, { desc = 'Show diagnostics' })

vim.keymap.set('i', 'jj', '<Esc>')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight',
  { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = '*'
})
