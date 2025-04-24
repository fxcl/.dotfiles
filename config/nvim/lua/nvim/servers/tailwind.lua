return {
  root_dir = function(fname)
    return require('lspconfig.util').root_pattern(
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts'
    )(fname)
  end,
}
