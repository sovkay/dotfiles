-- Add `require('keymaps')` in `init.lua` to use these

-- Set space as NO OP so we can use it as leader
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap= true,  silent= true })

-- Set Space as leader
vim.g.mapleader = " "

-- Opens up the netrw file explorer
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap= true, silent= true })

-- Better window movements using Ctrl + [h,j,k,l]
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { silent= true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { silent= true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { silent= true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { silent= true })

-- Better indentation in visual mode
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap=true, silent= true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap=true, silent= true })

-- Use jj in normal mode as ESC
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap=true, silent= true })
