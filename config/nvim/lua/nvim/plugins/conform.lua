return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
      local util = require 'conform.util'
      require('conform').setup {
        formatters = {
          prettier = {
            require_cwd = true,
            cwd = util.root_file {
              -- https://prettier.io/docs/en/configuration.html
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.yml',
              '.prettierrc.yaml',
              '.prettierrc.json5',
              '.prettierrc.js',
              '.prettierrc.cjs',
              '.prettierrc.mjs',
              '.prettierrc.toml',
              'prettier.config.js',
              'prettier.config.cjs',
              'prettier.config.mjs',
              -- "package.json",
            },
          },
        },
        formatters_by_ft = {
          lua = { 'stylua' },

          css = { 'prettier' },
          html = { 'prettier' },
          javascript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescript = { 'prettier' },
          typescriptreact = { 'prettier' },
          vue = { 'prettier' },
          astro = { 'prettier' },

          json = { 'prettier' },
          jsonc = { 'prettier' },
          markdown = { 'prettier' },
          ['markdown.mdx'] = { 'prettier' },

          sh = { 'shfmt' },

          go = { 'gofumpt', 'goimports', 'golines' },
        },
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = {
            c = true,
            cpp = true,
            vue = true,
            typescript = true,
            typescriptreact = true,
            javascript = true,
            javascriptreact = true,
            json = true,
            jsonc = true,
          }
          return {
            timeout_ms = 500,
            lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
          }
        end,
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
