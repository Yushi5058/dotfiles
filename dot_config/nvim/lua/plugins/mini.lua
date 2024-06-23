return function()
    local mini_modules = {
      "cursorword",
      "indentscope",
      "pairs",
      "comment",
      "diff",
      "git",
      "completion",
      "notify",
      "statusline",
      "surround",
      "animate",
      "starter",
    }

    for _, module_name in ipairs(mini_modules) do
      -- Construct the full module name
      local full_module_name = "mini." .. module_name
      -- Require the module and call its setup method
      require(full_module_name).setup()
    end
    vim.notify = require("mini.notify").make_notify()
  end

