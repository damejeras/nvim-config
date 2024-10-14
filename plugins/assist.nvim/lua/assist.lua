local M = {}

-- Function to stream Anthropic API response and append to current buffer
function M.stream_anthropic_response(query)
    -- Ensure we have an API key
    local api_key = os.getenv("ANTHROPIC_API_KEY")
    if not api_key then
        print("Error: Anthropic API key not set. Please set the ANTHROPIC_API_KEY environment variable")
        return
    end

    -- Prepare the curl command
    local curl_cmd = string.format(
        "curl https://api.anthropic.com/v1/messages " ..
        "-H 'Content-Type: application/json' " ..
        "-H 'anthropic-version: 2023-06-01' " ..
        "-H 'X-API-Key: %s' " ..
        "-d '{\"model\": \"claude-3-5-sonnet-20240620\", \"max_tokens\", \"messages\": [ { \"role\": \"user\", \"content\": \"%s\"}], \"stream\":true}'",
        api_key,
        vim.fn.shellescape(query)
    )

    -- Function to handle each line of the stream
    local function handle_stream_output(line)
        if line:match('^data: ') then
            local json_str = line:sub(7) -- Remove 'data: ' prefix
            local ok, decoded = pcall(vim.fn.json_decode, json_str)
            if ok and decoded.completion then
                vim.api.nvim_put({decoded.completion}, '', false, true)
            end
        end
    end

    -- Run the curl command and process the output
    vim.fn.jobstart(curl_cmd, {
        on_stdout = function(_, data)
            for _, line in ipairs(data) do
                if line ~= "" then
                    handle_stream_output(line)
                end
            end
        end,
        on_stderr = function(_, data)
            for _, line in ipairs(data) do
                if line ~= "" then
                    print("Error: " .. line)
                end
            end
        end,
        stdout_buffered = false
    })
end

-- Create a user command to call the function
vim.api.nvim_create_user_command('AssistAI', function(opts)
    M.stream_anthropic_response(opts.args)
end, {nargs = '+'})

return M
