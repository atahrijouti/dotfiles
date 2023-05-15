local M = {}

local documentHighlightAugroup = vim.api.nvim_create_augroup("LSP_DOCUMENT_HIGHLIGHT", {})

M.on_attach = function(client, bufnr)
  local capabilities = client.server_capabilities

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
