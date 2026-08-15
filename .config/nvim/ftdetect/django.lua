vim.filetype.add {
  extension = {
    djhtml = "htmldjango",
  },
  pattern = {
    [".*/templates/.*%.html"] = function(path)
      local project_dir = vim.fs.dirname(path)
      local manage_py = vim.fs.find("manage.py", {
        path = project_dir,
        upward = true,
        type = "file",
      })[1]

      return manage_py and "htmldjango" or "html"
    end,
  },
}
