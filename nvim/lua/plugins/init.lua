-- This file can be loaded by calling `lua require('plugins')` from your init.lua

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- The Dracula theme
  use {'dracula/vim', as = 'dracula'}

  -- File icons req for nvim-tree
  use 'kyazdani42/nvim-web-devicons'

  -- Vim Three to easily navigate around in dir
  use 'kyazdani42/nvim-tree.lua'
end)
