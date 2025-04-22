-- LSP diagnostics, code actions, etc.
-- https://github.com/nvimtools/none-ls.nvim
return {
	"nvimtools/none-ls.nvim",
	event = "VeryLazy",
	opts = function()
		return require "null-ls"
	end,
}
