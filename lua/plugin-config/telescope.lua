-- =============================================================================
-- Fuzzy finder (Telescope) setup
-- =============================================================================

require("telescope").setup({
	defaults = {
		-- Custom keymaps
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
		-- Custom layout
		layout_config = {
			vertical = { width = 0.5 },
		},
	},
})

-- Load the fzf extension for better performance
require("telescope").load_extension("fzf")
