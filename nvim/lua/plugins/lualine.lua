return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require('lualine').setup({
			theme = 'gruvbox',
			tabline = {
				lualine_a = { 'mode' },
				lualine_b = { 'filename' },
				lualine_c = {},
				lualine_x = { 'searchcount' },
				lualine_y = { 'hostname' },
				lualine_z = { 'lsp_status' },
			},
			sections = {},
		})
		vim.opt.showtabline = 2
	end,
}
