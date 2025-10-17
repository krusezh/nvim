-- =============================================================================
-- 模糊搜索 (Telescope) 设置
-- =============================================================================

require("telescope").setup({
	defaults = {
        -- 自定义快捷键
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
				["<C-n>"] = "move_selection_next",
				["<C-p>"] = "move_selection_previous",
				["<Down>"] = "cycle_history_next",
				["<Up>"] = "cycle_history_prev",
				["<C-c>"] = "close",
				["<C-u>"] = "preview_scrolling_up",
				["<C-d>"] = "preview_scrolling_down",
			},
		},
        -- 自定义布局
		layout_config = {
			vertical = { width = 0.5 },
		},
	},
})

-- 加载 fzf 扩展以提高性能
require("telescope").load_extension("fzf")