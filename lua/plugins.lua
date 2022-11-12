local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-obsession'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-commentary'
  Plug 'bfredl/nvim-ipy'
  Plug ('dracula/vim', { ['as'] = 'dracula' })
  Plug 'ryanoasis/vim-devicons'
  Plug 'sheerun/vim-polyglot'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug ('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'edluffy/specs.nvim'
  Plug 'lukas-reineke/lsp-format.nvim'
  Plug 'smbl64/vim-black-macchiato'

vim.call('plug#end')
