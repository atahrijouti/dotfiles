local M = {}

local documentHighlightAugroup = vim.api.nvim_create_augroup("LSP_DOCUMENT_HIGHLIGHT", {})

M.on_attach = function(client, bufnr)
  local capabilities = client.server_capabilities

  -- stylua: ignore start
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
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "[G]o to the [D]efinition of current symbol" })
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
