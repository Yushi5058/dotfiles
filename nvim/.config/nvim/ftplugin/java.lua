local jdtls = require("jdtls")
local home = os.getenv("HOME")

local mason_path = home .. "/.local/share/nvim/mason/packages/jdtls"

if vim.fn.isdirectory(mason_path) == 0 then
	vim.notify("JDTLS not found in Mason. Run :MasonInstall jdtls", vim.log.levels.WARN)
	return
end

local launcher_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]

local os_config = "config_linux"
if vim.fn.has("mac") == 1 then
	os_config = "config_mac"
elseif vim.fn.has("win32") == 1 then
	os_config = "config_win"
end

local config_dir = mason_path .. "/" .. os_config
local lombok_path = mason_path .. "/lombok.jar"

local project_root = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

if not project_root then
	-- Fallback to current directory for single files
	project_root = vim.fn.getcwd()
end

-- Check if jdtls already running for this project
local project_name = vim.fn.fnamemodify(project_root, ":p:h:t")
local instance_key = "jdtls_" .. project_name

local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok_path,
		"-jar",
		launcher_jar,
		"-configuration",
		config_dir,
		"-data",
		workspace_dir,
	},
	root_dir = project_root,
	handlers = {
		["$/progress"] = function() end,
	},
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
		},
	},
}

local map = vim.keymap.set
map("n", "<A-o>", jdtls.organize_imports, { buffer = true, desc = "Organize Imports" })
map("n", "crv", jdtls.extract_variable, { buffer = true, desc = "Extract Variable" })
map("v", "crv", function()
	jdtls.extract_variable(true)
end, { buffer = true, desc = "Extract Variable" })
map("n", "crc", jdtls.extract_constant, { buffer = true, desc = "Extract Constant" })
map("v", "crc", function()
	jdtls.extract_constant(true)
end, { buffer = true, desc = "Extract Constant" })
map("v", "crm", function()
	jdtls.extract_method(true)
end, { buffer = true, desc = "Extract Method" })
map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = true, desc = "Rename Symbol" })

jdtls.start_or_attach(config)