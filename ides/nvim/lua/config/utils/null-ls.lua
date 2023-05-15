local M = {}

local formatAugroup = vim.api.nvim_create_augroup("LSP_DOCUMENT_FORMAT", {})

M.on_attach = function(client, bufnr)
  local capabilities = client.server_capabilities

  if capabilities.documentFormattingProvider then
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
      vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = formatAugroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
      desc = "autoformat on save",
    })
  end
end

return M
