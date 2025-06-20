return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "ravitemer/codecompanion-history.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",              -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      -- { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    keys = {
      {
        '<leader>cc',
        '<cmd>CodeCompanionChat<CR>',
        desc = '[C]ode [C]ompanion Chat',
      },
    },
    opts = {
      extensions = {
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Automatically generate titles for new chats
            auto_generate_title = true,
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            -- Picker interface ("telescope" or "default")
            picker = "telescope",
            ---Enable detailed logging for history extension
            enable_logging = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          }
        }
      },
      provider = 'telescope',
      display = {
        chat = {
          window = {
            layout = "horizontal",
            height = 0.5,
          },
        },
      },
      strategies = {
        chat = {
          adapter = "anthropic",
          slash_commands = {
            ["buffer"] = {
              callback = "helpers.slash_commands.buffer",
              description = "Insert open buffers",
              opts = {
                contains_code = true,
              },
            },
          }
        },
        inline = {
          adapter = "anthropic",
        },
        agent = {
          adapter = "openai",
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "cmd:echo $ANTHROPIC_API_KEY"
            },
          })
        end,
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                order = 1,
                mapping = "parameters",
                type = "enum",
                desc =
                "ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.",
                default = "gpt-4o-mini",
                choices = {
                  "gpt-4o",
                  "gpt-4o-mini",
                  "gpt-4-turbo-preview",
                  "gpt-4",
                  "gpt-3.5-turbo",
                },
              },
            },
            env = {
              api_key = "cmd:echo $OPENAI_API_KEY"
            },
          })
        end,
      },
    },
    config = true
  },
  {
    "github/copilot.vim",
    cmd = {
      "Copilot",
    },
    config = function()
      -- disable tab mapping
      vim.g.copilot_no_tab_map = true

      -- next suggestion
      vim.keymap.set('i', '<C-J>', 'copilot#Next()', {
        expr = true,
        replace_keycodes = false
      })

      -- accept suggested
      vim.keymap.set('i', '<C-F>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
    end
  }
}
