return {
  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {},
    config = function(_, _)
      -- document existing key chains
      require('which-key').add {
        { '<leader>c',  group = '[C]ode' },
        { '<leader>c_', hidden = true },
        { '<leader>d',  group = '[D]ebug' },
        { '<leader>d_', hidden = true },
        { '<leader>g',  group = '[G]o' },
        { '<leader>g_', hidden = true },
        { '<leader>h',  group = '[H]unk' },
        { '<leader>h_', hidden = true },
        { '<leader>f',  group = '[F]ind' },
        { '<leader>f_', hidden = true },
        { '<leader>t',  group = '[T]oggle' },
        { '<leader>t_', hidden = true },
        { '<leader>w',  group = '[W]orkspace' },
        { '<leader>w_', hidden = true },
        { '<leader>s',  group = '[S]earch' },
        { '<leader>s_', hidden = true },
      }
      -- register which-key VISUAL mode
      -- required for visual <leader>hs (hunk stage) to work
      require('which-key').add {
        { '<leader>',  group = 'VISUAL <leader>', mode = 'v' },
        { '<leader>h', group = 'Git [H]unk',      mode = 'v' },
      }
    end
  },

  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    config = function()
      local c = require('vscode.colors').get_colors()
      vim.cmd.colorscheme 'vscode'

      -- Change spelling underline colors
      vim.api.nvim_set_hl(0, "SpellBad", { default = false, undercurl = true, sp = c.vscUiOrange })
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',

    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'vscode',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diagnostics' },
        lualine_x = { 'diff', { 'filename', path = 1 }, 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = "┊",
      },
      scope = {
        enabled = false,
      },
    },
  },

  -- Auto close brackets
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
}
