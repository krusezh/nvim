-- 自定义 on_attach 函数，用于在 nvim-tree 窗口中设置快捷键
local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- 保留并应用默认的快捷键
	api.config.mappings.default_on_attach(bufnr)

	-- 自定义快捷键
	-- ? : 查看帮助
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

require("nvim-tree").setup({
	-- 核心行为配置
	on_attach = my_on_attach,
	sort_by = "case_sensitive",
	-- 自动更新 git 状态和文件树
	sync_root_with_cwd = true,
	reload_on_bufenter = true,
	respect_buf_cwd = true,

	-- 更新在 git checkout, git switch 等操作后的文件焦点
	update_focused_file = {
		enable = true,
		update_root = true,
	},

	-- git 状态图标
	git = {
		enable = true,
		ignore = false, -- true 表示不显示 git 状态
	},

	-- 过滤不想显示的文件和目录
	filters = {
		dotfiles = false, -- false 表示显示隐藏文件
		custom = { "node_modules", ".cache", ".git" }, -- 其他过滤目录
	},

	-- 视图配置
	view = {
		-- 自适应宽度，在窗口大小变化时自动调整
		adaptive_size = true,
		width = 30,
		side = "left",
		-- 不显示行号
		number = false,
		relativenumber = false,
		-- 显示图标列
		signcolumn = "yes",
	},

	-- 文件操作配置
	actions = {
		open_file = {
			-- 在打开文件后自动关闭 nvim-tree 窗口
			quit_on_open = false,
			-- 调整窗口大小
			resize_window = true,
			-- 你可以自定义打开文件的方式，例如在新 tab 中打开
			-- window_picker = {
			-- 	enable = true,
			-- 	chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
			-- 	exclude = {
			-- 		filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
			-- 		buftype = { "nofile", "terminal", "help" },
			-- 	},
			-- },
		},
	},

	-- 渲染器配置
	renderer = {
		-- 在文件夹名称前添加图标
		group_empty = true,
		-- 高亮 git 状态变化的文件
		highlight_git = true,
		-- 图标配置
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
-- [!] 自动关闭问题修复
-- =============================================================================
local myAutoGroup = vim.api.nvim_create_augroup("NvimTreeAutoClose", {
	clear = true,
})

-- 当只剩下 nvim-tree 窗口时，自动关闭 Neovim
vim.api.nvim_create_autocmd("BufEnter", {
	group = myAutoGroup,
	nested = true,
	callback = function()
		-- [!] 添加的诊断信息
		-- print("Auto-close check triggered!")
		-- print("Window count: " .. #vim.api.nvim_list_wins())
		-- print("Current filetype: '" .. vim.bo.filetype .. "'")

		if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "NvimTree" then
			-- 使用 :quit 而不是 :q 以避免在有未保存修改时报错
			vim.cmd("quit")
		end
	end,
})
