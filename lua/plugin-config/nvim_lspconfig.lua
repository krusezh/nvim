local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities() -- nvim-cmp

-- =============================================================================
-- on_attach 函数: 在 LSP 附加到缓冲区时执行的通用回调
-- =============================================================================
local on_attach = function(client, bufnr)
	-- 为当前缓冲区启用“保存时自动格式化”
	-- if client.supports_method("textDocument/formatting") then
	-- 	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	-- 	vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	-- 	vim.api.nvim_create_autocmd("BufWritePre", {
	-- 		group = augroup,
	-- 		buffer = bufnr,
	-- 		callback = function()
	-- 			-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
	-- 			-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
	-- 			-- vim.lsp.buf.formatting_sync()
	-- 			vim.lsp.buf.format({ async = false })
	-- 		end,
	-- 	})
	-- end
end

-- =============================================================================
-- 各个语言服务器的配置
-- =============================================================================

-- Lua
-- lspconfig.lua_ls.setup({
--     capabilities = capabilities,
--     on_attach = on_attach,
--     settings = {
--         Lua = {
--             diagnostics = {
--                 globals = { "vim" },
--             },
--         },
--     },
-- })
lspconfig.lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			-- 让语言服务器知道 "vim" 是一个全局变量，从而消除警告
			diagnostics = {
				globals = { "vim" },
			},
			-- 让 lsp 知道我们正在使用的 Neovim 版本，以便提供更准确的补全
			-- runtime = {
			-- 	version = "Neovim-0.11.2", -- 请根据您的 Neovim 版本调整
			-- },
			workspace = {
				checkThirdParty = false,
			},
		},
	},
})

-- C / C++
lspconfig.clangd.setup({
	cmd = { "clangd", "--background-index", "--offset-encoding=utf-16" },
	capabilities = capabilities,
	on_attach = on_attach,
})

-- GoLang
lspconfig.gopls.setup({
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

-- Python
lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- TypeScript / JavaScript
lspconfig.ts_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Rust
lspconfig.rust_analyzer.setup({
	cmd = { "rust-analyzer" },
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		["rust-analyzer"] = {},
	},
})

-- =============================================================================
-- LSP 诊断信息的美化配置
-- =============================================================================

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
-- 	underline = true,
-- 	virtual_text = true,
-- 	signs = function(namespace, bufnr)
-- 		return vim.b[bufnr].show_signs == true
-- 	end,
-- 	update_in_insert = false,
-- })
--
-- -- 定义错误、警告等图标
-- local signs = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
-- for type, icon in pairs(signs) do
-- 	local hl = "DiagnosticSign" .. type
-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end

vim.diagnostic.config({
	-- 关闭虚拟文本（virtual_text）
	-- 如果想看到单行错误信息，可以设置为 true
	virtual_text = true,

	-- 在代码下方显示波浪线
	underline = true,

	-- 在插入模式下不实时更新诊断信息
	update_in_insert = false,

	-- 设置诊断信息的严重性级别排序
	severity_sort = true,

	-- 配置诊断图标
	signs = {
		active = true, -- 开启图标显示
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅙", -- 错误图标
			[vim.diagnostic.severity.WARN] = "", -- 警告图标
			[vim.diagnostic.severity.INFO] = "󰋼", -- 信息图标
			[vim.diagnostic.severity.HINT] = "󰌵", -- 提示图标
		},
	},
})

-- =============================================================================
-- LSP 快捷键 (这些是在 keybindings.lua 中定义的，这里只是确保 LSP 附加后功能正常)
-- =============================================================================
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- 开启 omnifunc 代码补全 (由 <c-x><c-o> 触发)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- 可以在这里定义 LSP 相关的快捷键，但您的配置已经将它们放在了 keybindings.lua 中
		-- 这也是一种好的实践，只要确保它们能正常工作即可
	end,
})

-- 您原有的全局诊断快捷键，保留在这里没有问题
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- =============================================================================
-- [!] 全局唯一的“保存时自动格式化”配置
-- =============================================================================
local format_augroup = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_augroup,
	pattern = "*", -- 对所有文件生效
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
