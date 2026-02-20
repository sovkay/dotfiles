return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"prettierd",
				"eslint_d",
			},
		},
	},
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp", "j-hui/fidget.nvim" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = require("lspconfig")

			-- servers to set up with default config
			local servers = { "lua_ls", "ts_ls" }
			for _, server in ipairs(servers) do
				lspconfig[server].setup({ capabilities = capabilities })
			end

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "jdl", vim.diagnostic.goto_prev, {})
			vim.keymap.set("n", "jdr", vim.diagnostic.goto_next, {})
		end,
	},
}
