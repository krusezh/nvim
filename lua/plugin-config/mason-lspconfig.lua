require("mason-lspconfig").setup({
	-- Servers to install automatically
	ensure_installed = {
		"lua_ls",
		"gopls",
		"pyright",
		"ruff",
		"rust_analyzer",
	},
	-- Disable automatic enabling; nvim_lspconfig.lua configures and enables each server
	automatic_enable = false,
})
