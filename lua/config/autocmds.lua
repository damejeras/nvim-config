local autocmd = vim.api.nvim_create_autocmd

-- create an empty, unmodified buffer on startup and change directory if needed
autocmd("VimEnter", {
  callback = function()
    local bufferPath = vim.fn.expand("%:p")
    if vim.fn.isdirectory(bufferPath) ~= 0 then
      -- Delete empty buffer
      vim.api.nvim_buf_delete(0, { force = true })
      -- Change directory if audirectory path is provided
      vim.cmd.cd(bufferPath)
      -- Create a new empty buffer
      vim.cmd("enew")
      -- Set the buffer as unmodified
      vim.bo.modified = false
      -- Set the buffer as not a file (scratch buffer)
      vim.bo.buftype = "nofile"
    end
  end,
})

-- automatic goimports on save
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end
})

-- automatic format on save
autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({})
  end,
})

-- clear jumplist
autocmd("VimEnter", {
  callback = function()
    vim.cmd.clearjumps()
  end
})

autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    -- Skip if filetype is already set or buffer has a name
    if vim.bo.filetype ~= "" or vim.fn.expand("%") ~= "" then
      return
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
