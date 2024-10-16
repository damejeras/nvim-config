local autocmd = vim.api.nvim_create_autocmd

-- create an empty, unmodified buffer on startup and change directory if needed
autocmd("VimEnter", {
  callback = function()
    local bufferPath = vim.fn.expand("%:p")
    if vim.fn.isdirectory(bufferPath) ~= 0 then
      -- Change directory if a directory path is provided
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

-- automatic terraform format on save
autocmd("BufWritePre", {
  pattern = { "*.tf", "*.tfvars" },
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
