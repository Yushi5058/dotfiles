-- jdtls is configured in ftplugin/java.lua (full start_or_attach with Mason check).
-- Keeping an empty config here caused a second, broken jdtls client on FileType java.
-- ftplugin/java.lua is the single source of truth for the Java LSP.
return {
	{ "mfussenegger/nvim-jdtls" },
	{
		-- Spring Boot language server: application.properties / application.yml
		-- completion, bean + endpoint lookup, Spring-aware code actions.
		-- Provides lsp/spring-boot.lua and registers it via vim.lsp.enable().
		"JavaHello/spring-boot.nvim",
		ft = { "java", "yaml", "jproperties" },
		dependencies = { "mfussenegger/nvim-jdtls" },
		opts = {
			-- Only start in real Spring Boot projects (checks pom.xml/build.gradle
			-- for spring-boot-starter-* or the org.springframework.boot plugin).
			project_filter = function(root_dir)
				return require("spring_boot.util").has_spring_boot_dependency(root_dir)
			end,
		},
	},
}
