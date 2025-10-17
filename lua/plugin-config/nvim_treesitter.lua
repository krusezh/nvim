-- =============================================================================
-- 语法高亮引擎 (nvim-treesitter) 设置
-- =============================================================================

require("nvim-treesitter.configs").setup({
	-- 确保安装以下语言的解析器
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"elixir",
		"heex",
		"javascript",
		"html",
		"go",
		"gomod",
		"gosum",
		"gotmpl",
		"gowork",
		"rust",
		"toml",
	},

	-- 启用增量选择模块
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			node_incremental = "<CR>",
			node_decremental = "<BS>",
			scope_incremental = "<TAB>",
		},
	},
})

-- 开启基于 Treesitter 的代码折叠
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- 默认不折叠代码
vim.opt.foldlevel = 99