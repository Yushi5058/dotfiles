local mini_modules = {
  "indentscope",
  "pairs",
  "comment",
  "diff",
  "git",
  "completion",
  "notify",
  "surround",
}

for _, module_name in ipairs(mini_modules) do
  -- Construct the full module name
  local full_module_name = "mini." .. module_name
  -- Require the module and call its setup method
  require(full_module_name).setup()
end
vim.notify = require("mini.notify").make_notify()
