-- Setup language servers.
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({})
lspconfig.pyright.setup({})
lspconfig.tsserver.setup({})
lspconfig.lua_ls.setup({})

local capabilities = require("cmp_nvim_lsp").default_capabilities() --nvim-cmp
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
				-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
				-- vim.lsp.buf.formatting_sync()
				vim.lsp.buf.format({
					bufnr = bufnr,
				})
			end,
		})
	end
end
-- C / C++
lspconfig.clangd.setup({
	cmd = { "clangd", "--background-index", "--offset-encoding=utf-16" },
	on_attach = on_attach,
	capabilities = capabilities,
})

-- GoLang
lspconfig.gopls.setup({
	cmd = { "gopls" },
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		gopls = {
			usePlaceholders = true,
			experimentalPostfixCompletions = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			-- staticcheck = true,
		},
	},
})
-- Rust
lspconfig.rust_analyzer.setup({
	-- Server-specific settings. See `:help lspconfig-setup`
	cmd = { "rust-analyzer" },
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {},
	},
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	-- Enable underline, use default values
	underline = true,
	-- disable virtual text
	virtual_text = true,

	-- show signs
	-- signs = true,

	-- Use a function to dynamically turn signs off
	-- and on, using buffer local variables
	signs = function(namespace, bufnr)
		return vim.b[bufnr].show_signs == true
	end,

	-- delay update diagnostics
	update_in_insert = false,
	-- display_diagnostic_autocmds = { "InsertLeave" },
})

-- 对错误警告的图标
local signs = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		--[[
                local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts) 
                ]]
	end,
})
