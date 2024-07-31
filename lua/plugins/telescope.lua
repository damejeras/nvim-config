local width = 0.9

return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',

    event = { 'VeryLazy' },

    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-dap.nvim' },
    },

    config = function(_, _)
      local telescope = require('telescope')
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup({
        defaults = {
          file_ignore_patterns = { ".git/", ".cache", "%.o", "%.a",
            "%.out", "%.class", "%.pdf", "%.mkv",
            "%.mp4", "%.zip", "vendor/" },
          vimgrep_arguments = { 'rg', '--hidden', '--color=never',
            '--no-heading', '--with-filename', '--line-number',
            '--column', '--smart-case', '-g', '!.git', },
          path_display = { 'truncate' },
          layout_strategy = 'vertical',
          layout_config = {
            height = 0.9,
            width = width,
            preview_cutoff = 1,
            prompt_position = 'bottom',
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {
              -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                ["<C-f>"] = lga_actions.quote_prompt({ postfix = " --fixed-strings" }),
              },
            },
          }
        }
      })

      telescope.load_extension('fzf')
      telescope.load_extension('ui-select')
      telescope.load_extension('dap')

      -- Show line numbers in preview
      vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")
    end,

    keys = {
      -- {
      --   '<leader>?',
      --   function()
      --     require('telescope.builtin').oldfiles()
      --   end,
      --   desc = '[?] Find recently opened files'
      -- },
      -- {
      --   '<leader>/',
      --   function()
      --     require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --       winblend = 10,
      --       previewer = false,
      --     })
      --   end,
      --   desc = '[/] Fuzzily search in current buffer'
      -- },
      {
        '<leader>ft',
        function()
          require('telescope.builtin').builtin()
        end,
        desc = '[F]ind [T]elescope'
      },
      {
        '<leader>fs',
        function()
          require('telescope.builtin').lsp_document_symbols({ symbol_width = 50 })
        end,
        desc = '[F]ind Document [S]ymbols'
      },
      {
        '<leader>fS',
        function()
          local symbol_type_width = 10
          local symbol_width = 50

          -- Get width of the terminal and resolve fname_width, symbol_width and symbol_type_width
          local full_width = vim.api.nvim_win_get_width(0)
          local available = full_width * width
          local fname_width = available - symbol_width - symbol_type_width

          if fname_width > 100 then
            fname_width = 100
          end

          require('telescope.builtin').lsp_dynamic_workspace_symbols({
            fname_width = fname_width,
            symbol_width = symbol_width,
            symbol_type_width = symbol_type_width
          })
        end,
        desc = '[F]ind Workspace [S]ymbols'
      },
      {
        '<leader>ff',
        function()
          require('telescope.builtin').find_files({ hidden = true, no_ignore = true })
        end,
        desc = '[F]ind [F]iles'
      },
      {
        '<leader>fh',
        function()
          require('telescope.builtin').git_status()
        end,
        desc = '[F]ind Git [H]unks'
      },
      {
        '<leader>f?',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = '[F]ind [?]Help'
      },
      {
        '<leader>fg',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = '[F]ind by [G]rep'
      },
      {
        '<leader>fG',
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = '[F]ind by [G]rep with Args'
      },
      {
        '<leader>fd',
        function()
          require('telescope.builtin').diagnostics()
        end,
        desc = '[F]ind [D]iagnostics'
      },
      {
        '<leader>fr',
        function()
          require('telescope.builtin').resume()
        end,
        desc = '[F]ind [R]esume'
      },
      {
        '<leader>fb',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = '[F]ind [B]uffers'
      },
      {
        '<leader>fm',
        function()
          require('telescope.builtin').marks()
        end,
        desc = '[F]ind [M]arks'
      }
    },

    cmd = {
      "Telescope",
    },
  },
}
