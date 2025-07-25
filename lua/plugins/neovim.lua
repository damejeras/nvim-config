return {
  {
    'uga-rosa/ccc.nvim',
    config = true
  },
  {
    "refractalize/oil-git-status.nvim",
    opts = {
      show_ignored = false,
      symbols = {
        index = {
          ["!"] = "!",
          ["?"] = "?",
          ["A"] = "A",
          ["C"] = "C",
          ["D"] = "D",
          ["M"] = "M",
          ["R"] = "R",
          ["T"] = "T",
          ["U"] = "U",
          [" "] = " ",
        },
        working_tree = {
          ["!"] = "!",
          ["?"] = "?",
          ["A"] = "A",
          ["C"] = "C",
          ["D"] = "D",
          ["M"] = "M",
          ["R"] = "R",
          ["T"] = "T",
          ["U"] = "U",
          [" "] = " ",
        },
      }
    },
    dependencies = {
      {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
          cleanup_delay_ms = false, -- does not cleanup, you can ctrl+o to go back. ignore lint
          win_options = {
            signcolumn = "yes:2",
          },
          view_options = {
            show_hidden = true,
          },
        },
        dependencies = {
          'nvim-tree/nvim-web-devicons',
        },
      },
    },

    config = true,
  },
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

      vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, fg = c.vscViolet, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, fg = c.vscBlueGreen, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, fg = c.vscBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, fg = c.vscBlueGreen, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, fg = c.vscPink, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, fg = c.vscFront, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, fg = c.vscUiOrange, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, fg = c.vscYellow, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, fg = c.vscBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, fg = c.vscOrange, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, fg = c.vscLightGreen, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, fg = c.vscBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, fg = c.vscPink, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, fg = c.vscBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, fg = c.vscBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, fg = c.vscLightBlue, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, fg = c.vscFront, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, fg = c.vscBlueGreen, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicText", { default = true, fg = c.vscFront, bg = c.vscLeftMid })
      vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, fg = c.vscFront, bg = c.vscLeftMid })

      -- Set mini-files colors
      vim.api.nvim_set_hl(0, "MiniFilesNormal", { default = true, fg = c.vscPopupFront, bg = c.vscBack })
      vim.api.nvim_set_hl(0, "MiniFilesBorder", { default = true, fg = c.vscPopupBack, bg = c.vscBack })
      vim.api.nvim_set_hl(0, "MiniFilesDirectory", { default = true, fg = c.vscBlue, bg = c.vscBack })
      vim.api.nvim_set_hl(0, "MiniFilesTitle", { default = true, fg = c.vscPopupFront, bg = c.vscBack })
      vim.api.nvim_set_hl(0, "MiniFilesTitleFocused", { default = true, fg = c.vscPink, bg = c.vscBack })
      vim.api.nvim_set_hl(0, "MiniFilesCursorLine", { default = true, fg = c.vscYellow, bg = c.vscBack })

      vim.api.nvim_set_hl(0, "BufferVisibleCHANGED", { default = true, link = "BufferVisible" })
      vim.api.nvim_set_hl(0, "BufferVisibleDELETED", { default = true, link = "BufferVisible" })
      vim.api.nvim_set_hl(0, "BufferVisibleADDED", { default = true, link = "BufferVisible" })

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
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            'filename',
            path = 1,
            on_click = function()
              local filepath = vim.fn.expand('%:.')
              if filepath and filepath ~= '' then
                vim.fn.setreg('+', filepath)
                vim.notify('File path copied to clipboard: ' .. filepath, vim.log.levels.INFO)
              else
                vim.notify('No file to copy', vim.log.levels.WARN)
              end
            end
          },
          'diagnostics'
        },
        lualine_x = { 'filetype' },
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
