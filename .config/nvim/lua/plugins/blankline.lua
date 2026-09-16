
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      -- Indent guides are enabled per buffer below, for Python only.
      enabled = false,
      indent = { highlight = "IblIndent" },
      scope = { highlight = "IblScope" },
    },
    config = function(_, opts)
      local ibl = require "ibl"
      ibl.setup(opts)

      local group = vim.api.nvim_create_augroup("PythonIndentGuides", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = function(args)
          ibl.setup_buffer(args.buf, { enabled = vim.bo[args.buf].filetype == "python" })
        end,
      })

      -- Apply the setting to buffers whose FileType event already happened.
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          ibl.setup_buffer(bufnr, { enabled = vim.bo[bufnr].filetype == "python" })
        end
      end
    end,
  },
}
