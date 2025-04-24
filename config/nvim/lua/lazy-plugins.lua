-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  defaults = {
    version = '*',
  },
  spec = {
    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

    -- Use `opts = {}` to force a plugin to be loaded.
    --
    --  This is equivalent to:
    --    require('Comment').setup({})

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    require 'nvim/plugins/theme',

    require 'nvim/plugins/web-devicons',

    require 'nvim/plugins/gitsigns',

    require 'nvim/plugins/which-key',

    require 'nvim/plugins/telescope',

    require 'nvim/plugins/lspconfig',

    require 'nvim/plugins/conform',

    require 'nvim/plugins/autopairs',

    require 'nvim/plugins/cmp',

    require 'nvim/plugins/todo-comments',

    require 'nvim/plugins/mini',

    require 'nvim/plugins/treesitter',

    require 'nvim/plugins/harpoon',

    require 'nvim/plugins/debug',

    require 'nvim/plugins/indent-line',

    require 'nvim/plugins/neotest',

    require 'nvim/plugins/trouble',

    require 'nvim/plugins/lualine',

    require 'nvim/plugins/tmux',

    require 'nvim/plugins/surround',

    require 'nvim/plugins/treesitter-context',

    require 'nvim/plugins/gitignore',

    require 'nvim/plugins/oil',

    require 'nvim/plugins/supermaven',

    require 'nvim/plugins/mdx',
  },
}, {
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicodes icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
