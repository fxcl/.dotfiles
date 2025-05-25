return {
  {
    'wintermute-cell/gitignore.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      local gitignore = require 'gitignore'

      vim.keymap.set('n', '<leader>gi', gitignore.generate, { desc = '[G]enerate .g[i]tignore' })
    end,
  },
}
