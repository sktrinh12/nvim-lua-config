local bo = vim.bo
local set = vim.opt
local win = vim.wo
local g = vim.g
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

bo.expandtab = true
bo.shiftwidth = 2
bo.softtabstop = 2
set.number = true
set.hidden = true
set.wrap = false 
set.termguicolors = true
set.clipboard = 'unnamedplus'
bo.textwidth = 80
g.shell = '/bin/zsh'
g.hidden = true
g.noswapfile = true
g.nobackup = true
g.nowritebackup = true

keymap('n', '<c-s>', ':w<CR>', {})
keymap('i', '<c-s>', '<Esc>:w<CR>a', {})
keymap('n', '<c-j>', '<c-w>j', opts) 
keymap('n', '<c-h>', '<c-w>h', opts) 
keymap('n', '<c-k>', '<c-w>k', opts) 
keymap('n', '<c-l>', '<c-w>l', opts) 
keymap('n', '<leader>c', "<cmd>lua require('specs').show_specs()<CR>", { noremap = true, silent = true })

-- telescope
keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true})
keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap = true})
keymap('n', '<leader>b', "<cmd>lua require('telescope.builtin').buffers()<cr>", {noremap = true})
keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", {noremap = true})

-- prettier manual 
vim.keymap.set('n', '<Leader>p', ':silent %!prettier --stdin-filepath %<CR>')

require('plugins')
require('format-config')

-- require('dracula').setup {}
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
