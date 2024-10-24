local M = {}

-- Default config
local default_opts = {
  command = "code2prompt",
  template = "default_template",
  include = nil,
  exclude = nil,
  extra_flag = "--line-number",
}

-- Options flags
local completion_options = { "template", "no_template" }

-- @param opts table: User-defined options
function M.setup(opts)
  opts = vim.tbl_extend("force", {}, default_opts, opts or {})

  vim.api.nvim_create_user_command("Code2prompt", function(args)
    local action = args.fargs[1]
    if action == "template" then
      M.select_template_and_run(opts)
    elseif action == "no_template" then
      M.run_code2prompt_without_template(opts)
    else
      vim.notify("Code2prompt: Invalid argument. Use 'template' or 'no_template'.", vim.log.levels.ERROR,
        { title = "Code2prompt.nvim" })
    end
  end, {
    nargs = 1,
    complete = function() return completion_options end,
  })
end

-- @param opts table: Configuration options
function M.select_template_and_run(opts)
  M.list_files_in_directory(opts.template, function(filename)
    if filename then
      M.run_code2prompt_with_template(opts, filename)
    else
      vim.notify("Code2prompt: No template selected", vim.log.levels.WARN, { title = "Code2prompt.nvim" })
    end
  end)
end

function M.run_code2prompt_with_template(opts, template_name)
  local command = string.format("%s %s -t %s %s", opts.command, vim.fn.getcwd(), template_name, opts.extra_flag)
  M.execute_command(command)
end

function M.run_code2prompt_without_template(opts)
  local command = string.format("%s %s %s", opts.command, opts.extra_flag, vim.fn.getcwd())
  M.execute_command(command)
end

function M.execute_command(command)
  local result = vim.fn.system(command)
  local log_level = vim.v.shell_error ~= 0 and vim.log.levels.ERROR or vim.log.levels.INFO
  vim.notify("Code2prompt: " .. result, log_level, { title = "Code2prompt.nvim" })
end

function M.list_files_in_directory(dir, callback)
  local files = vim.fn.glob(dir .. "/*.hbs")
  local file_list = vim.split(files, '\n')
  local choices = {}

  for _, file in ipairs(file_list) do
    if file ~= "" then
      choices[vim.fn.fnamemodify(file, ":t")] = file
    end
  end

  vim.ui.select(vim.tbl_keys(choices), { prompt = 'Select a Template:' }, function(choice)
    if choice then
      callback(choices[choice])
    end
  end)
end

return M
