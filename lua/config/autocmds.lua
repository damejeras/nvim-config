local autocmd = vim.api.nvim_create_autocmd

-- Clear jump list on start, so you would not jump to previous projects.
autocmd("VimEnter", {
  callback = function()
    vim.cmd.clearjumps()
  end
})

-- Detect JSON when files don't have .json extension. Could backfire, but had no problems yet.
autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    -- Skip if filetype is already set or buffer has a name
    if vim.bo.filetype ~= "" then return end

    local filename = vim.fn.expand("%")
    if filename ~= "" then
      -- If file has an extension, let Neovim handle filetype detection
      if filename:match("%.%w+$") then return end
    end

    -- Only check first line with a maximum of 100 characters
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if not first_line then return end

    first_line = first_line:sub(1, 100)

    -- Quick pattern match for common JSON starts
    if first_line:match("^%s*[{%[]") or first_line:match('^%s*"[^"]*"%s*:%s*') then
      vim.bo.filetype = "json"
    end
  end,
})

vim.api.nvim_create_autocmd('CursorHold', {
  pattern = '*',
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      scope = 'cursor',
      border = 'single',

    })
  end,
})

-- Close diagnostic floating windows only when using jumplist navigation
vim.keymap.set('n', '<C-o>', function()
  vim.diagnostic.hide()
  return '<C-o>'
end, { expr = true })

vim.keymap.set('n', '<C-i>', function()
  vim.diagnostic.hide()
  return '<C-i>'
end, { expr = true })
