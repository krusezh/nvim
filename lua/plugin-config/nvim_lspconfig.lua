-- =============================================================================
-- LSP (Language Server Protocol) 核心设置
-- =============================================================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- on_attach 函数: 在 LSP 附加到缓冲区时执行的通用回调
local on_attach = function(client, bufnr)
	-- 可以在这里为所有 LSP 设置通用的 on_attach 逻辑
	-- 例如: vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
end

-- =============================================================================
-- 各个语言服务器的配置
-- =============================================================================

-- Lua
vim.lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
})
vim.lsp.enable("lua_ls")

-- C / C++
vim.lsp.config("clangd", {
	cmd = { "clangd", "--background-index", "--offset-encoding=utf-16" },
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.enable("clangd")

-- GoLang
vim.lsp.config("gopls", {
	cmd = { "gopls" },
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			usePlaceholders = true,
			experimentalPostfixCompletions = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
		},
	},
})
vim.lsp.enable("gopls")

-- Python
vim.lsp.config("pyright", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.enable("pyright")

-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.enable("ts_ls")

-- Rust
vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		["rust-analyzer"] = {},
	},
})
vim.lsp.enable("rust_analyzer")

-- =============================================================================
-- LSP 诊断信息的美化配置
-- =============================================================================
vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	signs = {
		active = true,
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "󰋼",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
})

-- =============================================================================
-- LSP 快捷键 (部分)
-- =============================================================================
-- 当 LSP 附加到缓冲区时，启用 omnifunc 代码补全
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
	end,
})

-- 诊断相关的快捷键
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- =============================================================================
-- [!] “保存时自动格式化”配置 (已移至 none-ls.lua)
-- =============================================================================
-- local format_augroup = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
-- 
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = format_augroup,
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.lsp.buf.format({ async = false })
-- 	end,
-- })
