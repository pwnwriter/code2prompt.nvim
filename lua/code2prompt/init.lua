---@class Code2prompt
local M = {}

function M.setup(opts)
  opts = opts or {}
  print("this is soemthing")

  vim.api.nvim_create_user_command("Pwned", function()
    print("this is a command")
  end, {})
end

M.required_options = {
  command = "code2prompt",
}

M.allowed_opts = {
  command = "string",
  template = "boolean",
  include = "string",
  exclude = "string",
}

return M
