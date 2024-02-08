local telescope = require('telescope')
telescope.load_extension('fzf')
--<<<dash>>>
telescope.setup({
  extensions = {
    dash = {
      search_engine = 'google',
      file_type_keywords = {
        ruby = { 'ruby', 'rails' },
        cmake = { 'cmake' },
        python = { 'python3', 'python' },
      }
    }
  }
})
--<<</dash>>>
--<<<lsp>>>
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')
--<<</lsp>>>
--<<<lsp_perl>>>

lspconfig['perlpls'].setup{
  capabilities = capabilities,
}
--<<</lsp_perl>>>
--<<<lsp_python>>>

lspconfig['pyright'].setup{
  capabilities = capabilities,
}
--<<</lsp_python>>>
--<<<lsp_rust>>>

lspconfig['rust_analyzer'].setup{
  capabilities = capabilities,
}
--<<</lsp_rust>>>
--<<<lsp_clangd>>>

lspconfig['clangd'].setup{
  capabilities = capabilities,
}
--<<</lsp_clangd>>>
--<<<lsp>>>
-- LSP keybinding
vim.keymap.set('n', '<Leader>le', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>lt', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<Leader>lgD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<Leader>lgd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<Leader>lK', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<Leader>lgi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>lwa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>lwr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>lwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Leader>lrn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<Leader>lca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<Leader>lgr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
--<<</lsp>>>
-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
--<<<lsp>>>
    { name = 'nvim_lsp' },
--<<</lsp>>>
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

-- `/` cmdline setup.
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{
			name = 'cmdline',
			option = {
				ignore_cmds = { 'Man', '!' }
			}
		}
	})
})