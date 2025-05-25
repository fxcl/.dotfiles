vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { 'tsconfig.json' },

  callback = function()
    Set.filetype = 'jsonc'
  end,
})

return {}
