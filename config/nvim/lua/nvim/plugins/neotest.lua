return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-go',
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace 'neotest'
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      require('neotest').setup {
        adapters = {
          require 'neotest-vitest',
          require 'neotest-go',
        },
      }

      vim.keymap.set('n', '<leader>tr', function()
        require('neotest').run.run()
      end, { desc = '[R]un the nearest [t]est' })
      vim.keymap.set('n', '<leader>tt', function()
        require('neotest').run.run(vim.fn.expand '%')
      end, { desc = 'Run the curren[t] file' })
      vim.keymap.set('n', '<leader>td', function()
        require('neotest').run.run { strategy = 'dap' }
      end, { desc = '[D]ebug the nearest test' })
      vim.keymap.set('n', '<leader>tl', function()
        require('neotest').run.run_last()
      end, { desc = 'Run [L]ast' })
      vim.keymap.set('n', '<leader>ts', function()
        require('neotest').summary.toggle()
      end, { desc = 'Toggle [S]ummary' })
      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output.open { enter = true, auto_close = true }
      end, { desc = 'Show [O]utput' })
      vim.keymap.set('n', '<leader>tO', function()
        require('neotest').output_panel.toggle()
      end, { desc = 'Toggle [O]utput Panel' })
    end,
  },
}
