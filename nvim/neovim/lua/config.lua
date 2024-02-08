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
--<<<lsp_perl>>>

require'lspconfig'.perlpls.setup{}
--<<</lsp_perl>>>
--<<<lsp_python>>>

require'lspconfig'.pyright.setup{}
--<<</lsp_python>>>
