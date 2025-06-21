require("mason").setup()
require("mason-lspconfig").setup({
	-- 告知 mason-lspconfig 需要确保安装的 LSP 服务器列表。
	-- 它会自动为您安装这些服务器，但不会再自动调用 setup()。
	ensure_installed = {
		"lua_ls",
		"clangd",
		"gopls",
		"pyright",
		"ts_ls",
		"rust_analyzer",
	},

	-- [!] 关键改动：
	-- 我们提供一个空的 "handlers" 表格来覆盖默认的配置行为。
	-- 这样，mason-lspconfig 就不会再为我们自动调用 lspconfig.<服务器>.setup() 了。
	-- 所有 setup 调用都将由 nvim_lspconfig.lua 文件全权负责。
	handlers = {},
})
