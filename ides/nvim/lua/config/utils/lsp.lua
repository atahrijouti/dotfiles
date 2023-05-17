local M = {}

local documentHighlightAugroup = vim.api.nvim_create_augroup("LSP_DOCUMENT_HIGHLIGHT", {})

M.on_attach = function(client, bufnr)
  local capabilities = client.server_capabilities
  local telescopeBuiltin = require("telescope.builtin")

  -- stylua: ignore start
  vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP information" })
  vim.keymap.set("n", "<leader>lI", "<cmd>NullLsInfo<cr>", { desc = "Null-ls information" })
  
  vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, { desc = "Hover [L]SP [diagonstic]" })
  vim.keymap.set("n", "<leader>[d", function() vim.diagnostic.goto_prev() end, { desc = "Previous [d]iagnostic" })
  vim.keymap.set("n", "<leader>]d", function() vim.diagnostic.goto_next() end, { desc = "Next [d]iagostic" })
  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, { desc = "[G]o to [L]SP diagonstics" })
  -- stylua: ignore end

  if capabilities.codeActionProvider then
    local action = function()
      vim.lsp.buf.code_action()
    end
    -- stylua: ignore start
    vim.keymap.set("v", "<leader>la", action, { desc = "Display [L]SP code [a]ction" })
    vim.keymap.set("n", "<leader>la", action, { desc = "Display [L]SP code [a]ction" })
    -- stylua: ignore end
  end

  if capabilities.declarationProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, { desc = "[G]o to the [D]eclaration of current symbol" })
    -- stylua: ignore end
  end

  if capabilities.definitionProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "gd", function() telescopeBuiltin.lsp_definitions() end, { desc = "[G]o to the [D]efinition of current symbol" })
    -- stylua: ignore end
  end

  if capabilities.hoverProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover symbol details" })
    -- stylua: ignore end
  end

  if capabilities.implementationProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "gI", function() telescopeBuiltin.lsp_implementations() end, { desc = "Implementation of current symbol" })
    -- stylua: ignore end
  end

  if capabilities.referencesProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "gr", function() telescopeBuiltin.lsp_references() end, { desc = "References of current symbol" })
    vim.keymap.set("n", "<leader>lR", function() telescopeBuiltin.lsp_references() end, { desc = "Search references" })
    -- stylua: ignore end
  end

  if capabilities.renameProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, { desc = "Rename current symbol" })
    -- stylua: ignore end
  end

  if capabilities.signatureHelpProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
    -- stylua: ignore end
  end

  if capabilities.typeDefinitionProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "gT", function() telescopeBuiltin.lsp_type_definitions() end, { desc = "Definition of current type" })
    -- stylua: ignore end
  end

  if capabilities.documentSymbolProvider then
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>ls", function() telescopeBuiltin.lsp_document_symbols() end, { desc = "Definition of current type" })
    -- stylua: ignore end
  end
  if capabilities.workspaceSymbolProvider then
    local workspaceSymbols = function()
      vim.ui.input({ prompt = "Symbol Query: " }, function(query)
        if query then
          require("telescope.builtin").lsp_workspace_symbols({ query = query })
        end
      end)
    end
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>lG", workspaceSymbols, { desc = "Search workspace symbols" })
    -- stylua: ignore end
  end

  if capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = documentHighlightAugroup,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = bufnr,
      group = documentHighlightAugroup,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
end

return M
