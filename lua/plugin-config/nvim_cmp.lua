-- lua/plugin-config/nvim_cmp.lua (重构后)

local cmp = require("cmp")
local lspkind = require("lspkind")

-- 设置 Neovim 的补全行为
-- menu: 显示补全菜单
-- menuone: 只有一个候选项时也显示菜单
-- noselect: 不自动选择第一个候选项，需要用户主动选择
vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup({
	-- 为 cmp 启用代码片段引擎
	snippet = {
		expand = function(args)
			-- 使用 vsnip 来展开代码片段
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},

	-- 补全窗口美化
	window = {
		-- 使用 nvim-cmp 内置的边框样式
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- 核心快捷键映射
	mapping = cmp.mapping.preset.insert({
		-- 上下选择
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		-- 上下翻页
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		-- 手动触发补全
		["<C-Space>"] = cmp.mapping.complete(),
		-- 退出补全
		["<C-e>"] = cmp.mapping.abort(),
		-- 确认选择
		-- select = true: 表示如果菜单可见，回车键会确认选择。
		-- 如果菜单不可见，回车键就是普通的回车。
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- Tab 键的超级功能
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- 如果补全菜单可见，Tab 键就选择下一个候选项
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				-- 如果处于一个可以展开或跳转的 snippet 中，Tab 键就执行跳转
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand-or-jump)", true, true, true), "", true)
			else
				-- 否则，执行默认的 Tab 行为（比如缩进）
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- 如果补全菜单可见，Shift-Tab 就选择上一个候选项
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				-- 如果可以向上一个位置跳转，就执行跳转
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "", true)
			else
				-- 否则，执行默认行为（比如反向缩进）
				fallback()
			end
		end, { "i", "s" }),
	}),

	-- 补全源配置
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" }, -- 在键入函数括号时，把签名作为补全项
		{ name = "vsnip" },
	}, {
		{ name = "buffer" }, -- 从当前缓冲区文本补全
		{ name = "path" },   -- 文件路径补全
	}),

	-- 使用 lspkind-nvim 美化补全项，添加图标和类型信息
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text", -- 显示图标和文本
			maxwidth = 50, -- 限制最大宽度
			ellipsis_char = "...", -- 宽度超出时显示省略号

			-- 你可以为不同类型的补全项定制图标
			-- 例如: require('lspkind').symbol_map.Text = '󰉿'
		}),
	},
})

-- 为不同上下文设置特定的补全源
-- 1. git commit message 的补全
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" },
	}, {
		{ name = "buffer" },
	}),
})

-- 2. 命令行补全
--    - 输入 "/" 或 "?" 进行搜索时
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

--    - 输入 ":" 进入命令模式时
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
