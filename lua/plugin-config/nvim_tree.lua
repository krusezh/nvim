-- =============================================================================
-- 文件浏览器 (nvim-tree) 设置
-- =============================================================================

-- on_attach 函数: 在 nvim-tree 窗口中设置快捷键
local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- 应用默认的快捷键
	api.config.mappings.default_on_attach(bufnr)

	-- 自定义快捷键: ? 查看帮助
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

require("nvim-tree").setup({
	-- 核心行为配置
	on_attach = my_on_attach,
	sort_by = "case_sensitive",
	sync_root_with_cwd = true,
	reload_on_bufenter = true,
	respect_buf_cwd = true,

	-- 更新在 git checkout, git switch 等操作后的文件焦点
	update_focused_file = {
		enable = true,
		update_root = true,
	},

	-- 过滤不想显示的文件和目录
	filters = {
        git_ignored = false, -- 显示 .gitignore 中的文件
		custom = { "node_modules", ".cache", ".git" },
	},

	-- 视图配置
	view = {
		adaptive_size = true, -- 自适应宽度
	},

	-- 文件操作配置
	actions = {
		open_file = {
			resize_window = true, -- 调整窗口大小
		},
	},

	-- 渲染器配置
	renderer = {
		group_empty = true, -- 在空文件夹名称前添加图标
		highlight_git = true, -- 高亮 git 状态变化的文件
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

-- =============================================================================
-- 当只剩下 nvim-tree 窗口时，自动关闭 Neovim
-- =============================================================================
local myAutoGroup = vim.api.nvim_create_augroup("NvimTreeAutoClose", {
	clear = true,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = myAutoGroup,
	nested = true,
	callback = function()
		if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "NvimTree" then
			vim.cmd("quit")
		end
	end,
})