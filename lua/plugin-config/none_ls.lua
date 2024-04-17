local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion

null_ls.setup({
	sources = {
		completion.spell,
		formatting.shfmt,
		formatting.stylua,
		formatting.asmfmt,
		formatting.goimports,
		formatting.prettier,
		-- Python
		-- pip install black
		-- asdf reshim python
		formatting.black.with({ extra_args = { "--fast" } }),
		-- diagnostics ----------------------
		-- diagnostics.revive,
		-- diagnostics.staticcheck,
		diagnostics.golangci_lint,
		-- code actions ---------------------
		code_actions.impl,
		-- code_actions.gitsigns,
		code_actions.gomodifytags,
	},
	-- you can reuse a shared lspconfig on_attach callback here
	on_attach = function(client, bufnr)
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
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
