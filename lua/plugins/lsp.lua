return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'j-hui/fidget.nvim',      opts = {} },
      { 'williamboman/mason.nvim' },
      { 'towolf/vim-helm',        ft = 'helm' },
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { { 'folke/neodev.nvim' },
          { 'nanotee/sqls.nvim' },
        },
        config = function(_, _)
          -- mason-lspconfig requires that these setup functions are called in this order
          -- before setting up the servers.
          require('neodev').setup()
          require('mason').setup()

          -- [[ Configure LSP ]]
          --  This function gets run when an LSP connects to a particular buffer.
          local on_attach = function(_, bufnr)
            -- NOTE: Remember that lua is a real programming language, and as such it is possible
            -- to define small helper and utility functions so you don't have to repeat yourself
            -- many times.
            --
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            local nmap = function(keys, func, desc)
              if desc then
                desc = 'LSP: ' .. desc
              end

              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
            nmap('<leader>cf', '<cmd>Format<CR>', '[C]ode [F]ormat')
            nmap('<leader>cd', vim.diagnostic.open_float, '[C]ode [D]iagnostic error')
            nmap('<leader>cs', vim.lsp.buf.signature_help, '[C]ode [S]ignature')

            nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
              vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
          end

          -- Enable the following language servers
          --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
          --
          --  Add any additional override configuration in the following tables. They will be passed to
          --  the `settings` field of the server config. You must look up that documentation yourself.
          --
          --  If you want to override the default filetypes that your language server will attach to you can
          --  define the property 'filetypes' to the map in question.
          local servers = {
            -- clangd = {},
            -- pyright = {},
            -- rust_analyzer = {},
            -- tsserver = {},
            -- html = { filetypes = { 'html', 'twig', 'hbs'} },

            -- phpactor = {},
            lua_ls = {
              Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
                -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
              },
            },
            gopls = {
              env = { GOFLAGS = '-tags=unit', GOOS = 'linux' },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true
              },
              usePlaceholders = true,
            },
            zls = {},
            helm_ls = {}, -- configured in ftplugin/yaml.lua
            yamlls = {},  -- configured in ftplugin/yaml.lua
          }

          -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

          -- Ensure the servers above are installed
          local mason_lspconfig = require 'mason-lspconfig'

          mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
          }

          mason_lspconfig.setup_handlers {
            function(server_name)
              require('lspconfig')[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
                filetypes = (servers[server_name] or {}).filetypes,
              }
            end,
          }
        end
      },
    },
  },
}
