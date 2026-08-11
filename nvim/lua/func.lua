----------------------
-- Custom Functions --
----------------------
--
-- Compile and run the current file in a real terminal. Unlike jobstart(), a
-- terminal passes stdin through to the program, which is essential for CP.
function Compile()
  local filename = vim.fn.expand "%:p"
  local filetype = vim.bo.filetype

  if filename == "" then
    vim.notify("Save the file before running it", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    local ok, err = pcall(vim.cmd.write)
    if not ok then
      vim.notify("Could not save the file: " .. err, vim.log.levels.ERROR)
      return
    end
  end

  local escaped_file = vim.fn.shellescape(filename)
  local directory = vim.fn.fnamemodify(filename, ":h")
  local command

  if filetype == "cpp" then
    local output = "/tmp/nvim-cp-" .. vim.fn.sha256(filename):sub(1, 16)
    command = table.concat({
      "g++",
      "-std=gnu++17",
      "-O2",
      "-pipe",
      "-Wall",
      "-Wextra",
      "-Wshadow",
      escaped_file,
      "-o",
      vim.fn.shellescape(output),
      "&&",
      "/usr/bin/time -f '\\nTime: %es  Memory: %MKB'",
      vim.fn.shellescape(output),
    }, " ")
  elseif filetype == "c" then
    local output = "/tmp/nvim-cp-" .. vim.fn.sha256(filename):sub(1, 16)
    command = "gcc -std=gnu17 -O2 -pipe -Wall -Wextra " .. escaped_file
      .. " -o " .. vim.fn.shellescape(output)
      .. " && /usr/bin/time -f '\\nTime: %es  Memory: %MKB' " .. vim.fn.shellescape(output)
  elseif filetype == "python" then
    command = "/usr/bin/time -f '\\nTime: %es  Memory: %MKB' python3 " .. escaped_file
  elseif filetype == "lua" then
    command = "lua " .. escaped_file
  elseif filetype == "java" then
    local class_name = vim.fn.expand "%:t:r"
    command = "javac " .. escaped_file .. " && java -cp " .. vim.fn.shellescape(directory)
      .. " " .. vim.fn.shellescape(class_name)
  else
    vim.notify("No runner configured for filetype: " .. filetype, vim.log.levels.WARN)
    return
  end

  vim.cmd "botright 15new"
  local terminal_buffer = vim.api.nvim_get_current_buf()
  vim.bo[terminal_buffer].bufhidden = "wipe"
  vim.fn.termopen(command, {
    cwd = directory,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.schedule(function()
          vim.notify("Program exited with code " .. exit_code, vim.log.levels.ERROR)
        end)
      end
    end,
  })
  vim.cmd "startinsert"
end
