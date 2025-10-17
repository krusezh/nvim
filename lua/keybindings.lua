-- =============================================================================
-- 全局快捷键设置
-- =============================================================================

local opt = {
	noremap = true,
	silent = true,
}

-- 文件浏览器 (NvimTree)
vim.keymap.set("n", "<leader>d", ":NvimTreeToggle<CR>", opt)

-- LSP (Lspsaga & vim.lsp)
-- 重命名
vim.keymap.set("n", "<leader>r", ":Lspsaga rename<CR>", opt)
-- 代码操作
vim.keymap.set("n", "<leader>a", ":Lspsaga code_action<CR>", opt)
-- 跳转到定义
vim.keymap.set("n", "gd", ":Lspsaga goto_definition<CR>", opt)
-- 显示文档
vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", opt)
-- 查找引用
vim.keymap.set("n", "gf", ":Lspsaga finder def+ref<CR>", opt)
-- 跳转到声明
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
-- 跳转到实现
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opt)
-- 查找引用 (vim.lsp)
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opt)
-- 格式化代码
vim.keymap.set("n", "<leader>=", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opt)

-- 诊断 (Lspsaga & vim.diagnostic)
-- 显示行诊断
vim.keymap.set("n", "<leader>q", "<cmd>Lspsaga show_line_diagnostics<CR>", opt)
-- 上一个诊断
-- vim.keymap.set("n", "gk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opt)
-- 下一个诊断
-- vim.keymap.set("n", "gj", "<cmd>lua vim.diagnostic.goto_next()<CR>", opt)

-- 模糊搜索 (Telescope)
vim.keymap.set("n", "<leader>f", function()
	require("telescope.builtin").find_files()
end, {})
vim.keymap.set("n", "<leader>g", function()
	require("telescope.builtin").live_grep()
end, {})
vim.keymap.set("n", "<leader>b", function()
	require("telescope.builtin").buffers()
end, {})
vim.keymap.set("n", "<leader>hf", function()
	require("telescope.builtin").help_tags()
end, {})
