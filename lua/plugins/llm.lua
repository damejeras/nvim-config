return {
  require("plugins.codecompanion"),
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
