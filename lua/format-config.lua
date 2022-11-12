-- Formatters

-- vim.api.nvim_command([[
-- 				au FileType *.R :setlocal shiftwidth=2 tabstop=2 expandtab
-- ]])



local configs = require'nvim-treesitter.configs'
configs.setup {
  sync_install = false,
  ignore_install = {},
  highlight = { -- enable highlighting
    enable = true,
    disable = {},
  },
  indent = {
  enable = true, -- default is disabled
  }
}



local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {}
  server:setup(opts)
end)


-- nvim cmp
local cmp = require'cmp'

  cmp.setup({
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<Tab>'] = cmp.mapping.select_next_item({behavior=cmp.SelectBehavior.Insert}),
      ['<S-Tab>'] = cmp.mapping.select_prev_item({behavior=cmp.SelectBehavior.Insert}),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })


-- specs for cursor
require('specs').setup{ 
    show_jumps  = true,
    min_jump = 10,
    popup = {
        delay_ms = 0, -- delay before popup displays
        inc_ms = 10, -- time increments used for fade/resize effects 
        blend = 5, -- starting blend, between 0-100 (fully transparent), see :h winblend
        width = 25,
        winhl = "PMenu",
        fader = require('specs').linear_fader,
        resizer = require('specs').shrink_resizer
    },
    ignore_filetypes = {},
    ignore_buftypes = {
        nofile = true,
    },
}


-- Setup lspconfig.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local nvim_lsp = require 'lspconfig'
-- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Enable the following language servers
local servers = {
  "bashls",
  "cssls",
  "dockerls",
  "jsonls",
  "pyright",
  "sqls",
  "vimls",
  "yamlls"
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

vim.cmd[[au VimEnter * highlight ColorColumn guibg=#171717]]
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--   nvim_lsp['pyright'].setup {
--     capabilities = capabilities
-- }

-- require'lsp-format'.setup {
-- 			  javascript = { cmd = { "prettier -w"}},
-- 			  javascriptreact = { cmd = { "prettier -w"}},
-- 			  html = { cmd = { "prettier -w"}}
-- }
-- nvim_lsp.gopls.setup { on_attach = require "lsp-format".on_attach }

-- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
--vim.api.nvim_exec([[
-- augroup FormatAutogroup
--   autocmd!
-- 	  autocmd BufWritePost *.js,*.py,*.lua,*.html,*.css,*.json,*.md FormatWrite
-- 	augroup END
-- ]], true)
