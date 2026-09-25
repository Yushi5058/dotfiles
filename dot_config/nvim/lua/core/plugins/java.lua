-- jdtls is configured in ftplugin/java.lua (full start_or_attach with Mason check).
-- Keeping an empty config here caused a second, broken jdtls client on FileType java.
-- ftplugin/java.lua is the single source of truth for the Java LSP.
return { "mfussenegger/nvim-jdtls" }