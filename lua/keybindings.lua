-- =============================================================================
-- Global keymaps
-- =============================================================================

local opt = {
	noremap = true,
	silent = true,
}

-- File explorer (NvimTree)
vim.keymap.set("n", "<leader>d", ":NvimTreeToggle<CR>", opt)

-- LSP (native)
-- Rename
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opt)
-- Code action
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opt)
-- Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opt)
-- Show documentation
vim.keymap.set("n", "K", vim.lsp.buf.hover, opt)
-- Go to declaration
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opt)
-- Format code
vim.keymap.set("n", "<leader>=", function()
	vim.lsp.buf.format({ async = true })
end, opt)

-- Diagnostics (vim.diagnostic)
-- Show diagnostics for the current line in a floating window
vim.keymap.set("n", "<leader>q", vim.diagnostic.open_float, opt)

-- Fuzzy finder (Telescope)
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", opt)
vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<CR>", opt)
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", opt)
vim.keymap.set("n", "<leader>hf", "<cmd>Telescope help_tags<CR>", opt)

-- Terminal (ToggleTerm)
vim.keymap.set("n", "<c-\\>t", "<cmd>ToggleTerm direction=horizontal<CR>", opt)
vim.keymap.set("n", "<c-\\>a", "<cmd>ToggleTerm direction=float<CR>", opt)
vim.keymap.set("n", "<c-\\>s", "<cmd>ToggleTerm direction=vertical<CR>", opt)
