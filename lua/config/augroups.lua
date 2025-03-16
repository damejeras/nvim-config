-- [[ Highlight on yank ]] See `:help vim.highlight.on_yank()`

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Cache for fabric command list
local fabric_commands_cache = nil

-- Function to get completion items for Assist command
local function assist_complete(arg_lead, cmd_line, cursor_pos)
  if fabric_commands_cache == nil then
    local fabric_list = vim.fn.system('fabric --listpatterns')
    fabric_commands_cache = vim.split(fabric_list, '\n')
  end

  local completions = {}
  for _, command in ipairs(fabric_commands_cache) do
    if vim.startswith(command, arg_lead) then
      table.insert(completions, command)
    end
  end
  return completions
end

-- Define the Assist command
vim.api.nvim_create_user_command('Assist', function(opts)
  -- Check if at least one argument is passed
  if #opts.fargs == 0 then
    print("Error: No command provided")
    return
  end

  -- Extract the first argument as the shell command
  local shell_command = opts.fargs[1]

  -- Get the input: either from visual selection or command-line arguments
  local input, start_line, end_line
  if opts.range > 0 then
    -- Get visually selected text
    start_line, end_line = opts.line1, opts.line2
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    input = table.concat(lines, "\n")
  else
    -- Get the rest of the arguments
    input = table.concat(vim.list_slice(opts.fargs, 2), " ")
  end

  -- Escape the input for shell
  local escaped_input = vim.fn.shellescape(input)

  -- Construct the final shell command
  local final_command = string.format("echo %s | fabric -p %s", escaped_input, vim.fn.shellescape(shell_command))

  -- Execute the shell command and capture the output
  local output = vim.fn.system(final_command)

  -- Check for errors during execution
  if vim.v.shell_error ~= 0 then
    print("Error executing shell command")
    return
  end

  -- Trim the output, split into lines, and filter out empty lines
  output = vim.trim(output)
  local lines = vim.tbl_filter(function(line)
    return line ~= ""
  end, vim.split(output, "\n"))

  -- Replace selected text with output or insert at cursor position
  if #lines > 0 then
    if opts.range > 0 then
      vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
    else
      vim.api.nvim_put(lines, 'l', true, true) -- Insert at the current cursor position
    end
  else
    print("No output to insert")
  end
end, {
  nargs = '*',
  complete = assist_complete,
  range = true
})
