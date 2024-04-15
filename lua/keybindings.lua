local opt = {
	noremap = true,
	silent = true,
}

vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", opt)
-- rename
vim.keymap.set("n", "<leader>r", ":Lspsaga rename<CR>", opt)
-- code action
vim.keymap.set("n", "<leader>c", ":Lspsaga code_action<CR>", opt)
-- go xx
vim.keymap.set("n", "gd", ":Lspsaga goto_definition<CR>", opt)
vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", opt)
vim.keymap.set("n", "gf", ":Lspsaga finder def+ref<CR>", opt)
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opt)
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opt)
-- diagnostic
vim.keymap.set("n", "gp", "<cmd>Lspsaga show_line_diagnostics<CR>", opt)
vim.keymap.set("n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opt)
vim.keymap.set("n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", opt)

vim.keymap.set("n", "<leader>=", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opt)
-- 没用到
vim.keymap.set("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opt)
-- vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opt)
-- vim.keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opt)
-- vim.keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opt)
-- vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opt)
-- vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opt)
