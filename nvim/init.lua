require("config.options")
require("config.lazy")
require("config.spell")

vim.keymap.set('n', '<leader>cn', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
vim.keymap.set('n', '<leader>cp', '<cmd>cprev<CR>', { desc = 'Previous quickfix item' })
