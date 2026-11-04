-- No tree-sitter parser for MDX yet; use Markdown highlighting as fallback.
vim.filetype.add({
	extension = {
		mdx = "markdown",
	},
})
