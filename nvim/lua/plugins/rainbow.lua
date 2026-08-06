return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    -- Load before FileType so the plugin can attach to the first opened buffer.
    event = { "BufReadPre", "BufNewFile" },
  },
}
