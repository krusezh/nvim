-- =============================================================================
-- File explorer (nvim-tree) setup
-- =============================================================================

-- on_attach: set up keymaps inside the nvim-tree window
local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- Apply the default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- Custom mapping: ? toggles help
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

require("nvim-tree").setup({
	-- Core behavior
	on_attach = my_on_attach,
	sort_by = "case_sensitive",
	sync_root_with_cwd = true,
	reload_on_bufenter = true,
	respect_buf_cwd = true,

	-- Update the focused file and root when entering buffers
	update_focused_file = {
		enable = true,
		update_root = true,
	},

	-- Hide unwanted files and directories
	filters = {
		git_ignored = false, -- Show files ignored by .gitignore
		custom = { [[^node_modules$]], [[^\.cache$]], [[^\.git$]] },
	},

	-- View settings
	view = {
		adaptive_size = true, -- Fit the window to the longest line
	},

	-- File actions
	actions = {
		open_file = {
			resize_window = true, -- Resize the tree window after opening a file
		},
	},

	-- Renderer
	renderer = {
		group_empty = true, -- Compact single-child folders into one node
		highlight_git = true, -- Highlight files with Git status changes
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = true,
			},
			glyphs = {
				default = "󰈚",
				symlink = "",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "",
					open = "",
					empty = "󰜌",
					empty_open = "󰜌",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
})
