return {
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
      '<leader>ac',
      '<cmd>CodeCompanionChat<CR>',
      desc = '[A]I [C]hat',
    },
    {
      '<leader>aa',
      '<cmd>CodeCompanionActions<CR>',
      desc = '[A]I [A]ctions',
    },
  },
  opts = function()
    local function load_prompt_files()
      local prompts = {}
      local prompt_dir = vim.fn.stdpath("config") .. "/lua/plugins/codecompanion/prompts"
      local files = vim.fn.glob(prompt_dir .. "/*.lua", false, true)

      for _, file in ipairs(files) do
        local filename = vim.fn.fnamemodify(file, ":t:r")
        if filename ~= "init" then
          local prompt_name = filename:gsub("_", " "):gsub("(%l)(%w*)", function(a, b)
            return string.upper(a) .. b
          end)
          local ok, prompt_config = pcall(require, "plugins.codecompanion.prompts." .. filename)
          if ok then
            prompts[prompt_name] = prompt_config
          end
        end
      end

      return prompts
    end

    return {
      prompt_library = load_prompt_files(),
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
            -- Picker keymap (n is for normal mode, i is for insert)
            picker_keymaps = {
              rename = { n = "r" },
              delete = { n = "d", i = "<Delete>" },
              duplicate = { n = "yy" },
            },
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
        action_palette = {
          opts = {
            show_default_actions = false,
            show_default_prompt_library = false,
          }
        }
      },
      strategies = {
        chat = {
          adapter = "gemini",
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
            schema = {
              model = {
                default = "claude-3-5-haiku-20241022",
                choices = {
                  "claude-opus-4-20250514",
                  "claude-sonnet-4-20250514",
                  "claude-3-7-sonnet-20250219",
                  "claude-3-5-haiku-20241022",
                },
              }
            },
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
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "cmd:echo $GEMINI_API_KEY"
            },
          })
        end,
      },
    }
  end,
  config = true
}
