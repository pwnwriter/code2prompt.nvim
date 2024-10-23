local M = {}

local command = "code2prompt"

M.check = function()
  vim.health.start("code2prompt.nvim report")

  if vim.fn.executable(command) == 1 then
    vim.health.ok(command .. " is installed")
  else
    vim.health.error(command .. " command is not installed")
  end
end

return M
