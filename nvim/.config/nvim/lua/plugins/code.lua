return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = function()
			local builtin = require("telescope.builtin")

			return {
				{
					"<leader>ff",
					function()
						builtin.find_files()
					end,
				},
        {
					"<leader>fb",
					function()
						builtin.buffers()
					end,
				},
        {
					"<leader>fh",
					function()
						builtin.help_tags()
					end,
				},
				{
					"<leader>fg",
					function()
						builtin.live_grep()
					end,
				},
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",

		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"lua",
					"html",
					"javascript",
					"typescript",
					"vim",
					"vimdoc",
					"css",
				},
				sync_install = true,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
				},
			})

			vim.keymap.set("n", "<leader>fh", vim.lsp.buf.format, {})
		end,
	},
}