-- File Explorer
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		{ "3rd/image.nvim", opts = {} },
	},
	lazy = false,
	opts = {},
	config = function()
		vim.keymap.set('n', '<leader>e', ":Neotree toggle<CR>", { silent = true })
		require("neo-tree").setup({
			event_handlers = {
				{
					event = 'after_render',
					handler = function()
						local state = require('neo-tree.sources.manager').get_state('filesystem')
						if not require('neo-tree.sources.common.preview').is_active() then
							state.config = { use_float = false } -- or whatever your config is
							state.commands.toggle_preview(state)
						end
					end
				},
				{
					event = "file_open_requested",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end
				},
			},
		})
	end,
}
