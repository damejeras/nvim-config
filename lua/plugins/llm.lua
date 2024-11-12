return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",                      -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim",         -- Optional: For using slash commands
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    opts = {
      strategies = {
        chat = {
          adapter = "anthropic",
          slash_commands = {
            ["buffer"] = {
              callback = "helpers.slash_commands.buffer",
              description = "Insert open buffers",
              opts = {
                contains_code = true,
                provider = "telescope", -- default|telescope|mini_pick|fzf_lua
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
              api_key = "cmd:op read op://Personal/anthropic/credential --account my.1password.com --no-newline"
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
              api_key = "cmd:op read op://Personal/openai/credential --account my.1password.com --no-newline",
            },
          })
        end,
      },
    },
    config = true
  }
}
