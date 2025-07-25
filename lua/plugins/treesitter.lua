return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          enable = true,
          line_numbers = true,
          separator = '─',
        },
      },
      {
        'LiadOz/nvim-dap-repl-highlights',
        opts = {},
      }
    },
    build = ':TSUpdate',
    config = function(_, _)
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
          -- Add languages to be installed here that you want installed for treesitter
          ensure_installed = { 'c', 'cpp', 'go', 'templ', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'yaml', 'markdown', 'zig', 'ruby' },

          -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
          auto_install = false,
          -- Install languages synchronously (only applied to `ensure_installed`)
          sync_install = false,
          -- List of parsers to ignore installing
          ignore_install = {},
          -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
          modules = {},
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              node_incremental = 'v',
              node_decremental = 'V',
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
              },
              goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
              },
              goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
              },
              goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
              },
            },
            -- swap = {
            --   enable = true,
            --   swap_next = {
            --     ['<leader>a'] = '@parameter.inner',
            --   },
            --   swap_previous = {
            --     ['<leader>A'] = '@parameter.inner',
            --   },
            -- },
          },
        }
      end, 0)
    end
  },
}
