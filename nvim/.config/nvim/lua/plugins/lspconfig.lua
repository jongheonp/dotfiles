vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  float = { header = '', prefix = '■ ', border = 'solid' },
  update_in_insert = true,
  severity_sort = true
})

-- Highlight line number instead of icons for diagnostics
for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
  vim.fn.sign_define("DiagnosticSign" .. diag, {
    text = "",
    texthl = "DiagnosticSign" .. diag,
    linehl = "",
    numhl = "DiagnosticSign" .. diag,
  })
end

local function client_capabilities()
  local capabilities = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
  )

  return capabilities
end

local function on_attach(ev)
  vim.lsp.inlay_hint.enable()

  -- Open diagnostic float when hover
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = ev.buf,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        source = 'if_many',
        scope = 'cursor'
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })

  -- Buffer local mappings
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "LSP signature help", buffer = ev.buf })
  vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, { desc = "LSP code action", buffer = ev.buf })
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, { desc = "LSP rename", buffer = ev.buf })
  vim.keymap.set('n', '<Leader>dd', "<Cmd>FzfLua lsp_document_diagnostics<CR>", { desc = 'LSP document diagnostics', buffer = ev.buf })
  vim.keymap.set('n', '<Leader>ds', "<Cmd>FzfLua lsp_document_symbols<CR>", { desc = 'LSP document symbols', buffer = ev.buf })
  vim.keymap.set('n', '<Leader>wd', "<Cmd>FzfLua lsp_workspace_diagnostics<CR>", { desc = 'LSP workspace diagnostics', buffer = ev.buf })
  vim.keymap.set('n', '<Leader>ws', "<Cmd>FzfLua lsp_workspace_symbols<CR>", { desc = 'LSP workspace symbols', buffer = ev.buf })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP declarations', buffer = ev.buf })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP definitions', buffer = ev.buf })
  vim.keymap.set('n', 'gI', "<Cmd>FzfLua lsp_implementations<CR>", { desc = 'LSP implementations', buffer = ev.buf })
  vim.keymap.set('n', 'gr', "<Cmd>FzfLua lsp_references<CR>", { desc = 'LSP references', buffer = ev.buf })
  vim.keymap.set('n', 'gy', "<Cmd>FzfLua lsp_typedefs<CR>", { desc = "LSP type definitions", buffer = ev.buf })
end

return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
          on_attach(ev)
        end
      })

      lspconfig = require('lspconfig')

      lspconfig.clangd.setup({ capabilities = client_capabilities() })

      lspconfig.lua_ls.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME }
            }
          })
        end,
        settings = {
          Lua = {
            diagnostics = { disable = { 'undefined-field' } }
          }
        }
      })

      lspconfig.ocamllsp.setup({ capabilities = client_capabilities() })

      lspconfig.zls.setup({ capabilities= client_capabilities() })
    end
  }
}
