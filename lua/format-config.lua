local null_ls = require("null-ls")


local lspkind = require('lspkind')

local tabnine = require 'cmp_tabnine.config'

tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = '..',
	ignored_file_types = {
		-- default is not to ignore
		-- uncomment to ignore in lua:
		-- lua = true
	},
	show_prediction_strength = false
})


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
      -- ['<Tab>'] = cmp.mapping.select_next_item({behavior=cmp.SelectBehavior.Insert}),
      -- ['<S-Tab>'] = cmp.mapping.select_prev_item({behavior=cmp.SelectBehavior.Insert}),
			["<Tab>"] = cmp.mapping(function(fallback)
            local luasnip = require "luasnip"
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif luasnip.expandable() then
							luasnip.expand()
						else
							fallback()
						end
        end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
            local luasnip = require "luasnip"
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = {
      { name = 'cmp_tabnine' },
			{ name = 'treesitter' },
			{ name = 'path' },
			{ name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = "luasnip" },
    },
		formatting = {
        format = function(entry, item)
            item.kind = lspkind.symbolic(item.kind, {mode = "symbol"})
            if entry.source.name == "cmp_tabnine" then
                item.kind = "   (TabNine)"
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                    item.kind = "   (" .. entry.completion_item.data.detail .. ")"
                end
            end
				    local maxwidth = 80
            item.menu = ({
                buffer = "[Buffer]",
                cmp_tabnine = "[T9]",
                nvim_lsp = "[LSP]",
                treesitter = "[TS]",
                path = "[Path]",
            })[entry.source.name]
            return item
        end,
    },
		snippet = {
        expand = function(args)
            local luasnip = require "luasnip"
            if not luasnip then
                return
            end
            luasnip.lsp_expand(args.body)
        end,
    },
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
local nvim_lsp = require 'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- automatically select lang server instead of prompt
local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- add to your shared on_attach callback
null_ls.setup({
		debug = false,
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
									lsp_formatting(bufnr)
							end,
					})
			end
    end,
    sources = {
				null_ls.builtins.formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote"}}),
        null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.shfmt,
        null_ls.builtins.diagnostics.eslint,
				null_ls.builtins.diagnostics.flake8,
    },
})

-- Enable the following language servers
local servers = {
  "pyright",
  "sqls",
  "vimls",
  "yamlls",
	"tsserver"
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

vim.cmd[[au VimEnter * highlight ColorColumn guibg=#171717]]
