local telescope = require('telescope')
telescope.load_extension('fzf')
telescope.setup({
  extensions = {
    dash = {
      search_engine = 'google',
      file_type_keywords = {
        ruby = { 'ruby', 'rails' },
      }
    }
  }
})

