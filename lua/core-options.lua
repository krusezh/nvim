-- =============================================================================
-- Neovim 核心设置
-- =============================================================================

-- 启用语法高亮和文件类型检测
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

-- 设置<Leader>键
vim.g.mapleader = ','

-- 编辑器外观
vim.opt.number = true              -- 显示行号
vim.opt.relativenumber = true      -- 显示相对行号
vim.opt.cursorline = true          -- 高亮当前行
vim.opt.cursorcolumn = true        -- 高亮当前列
vim.opt.signcolumn = "yes"         -- 始终显示符号列，以防止屏幕抖动
vim.opt.laststatus = 2             -- 总是显示状态栏
vim.opt.colorcolumn = '80'         -- 在80列处显示标尺
vim.opt.background = 'dark'        -- 设置深色背景

-- 行为设置
vim.opt.mouse = 'a'                -- 在所有模式下启用鼠标
vim.opt.hlsearch = true            -- 高亮搜索结果
vim.opt.ignorecase = true          -- 搜索时忽略大小写
vim.opt.smartcase = true           -- 如果搜索词包含大写字母，则不忽略大小写
vim.opt.smartindent = true         -- 智能缩进

-- 制表符和缩进
vim.opt.expandtab = true           -- 将Tab转换为空格
vim.opt.shiftwidth = 4             -- 自动缩进所用的空格数
vim.opt.softtabstop = 4            -- 按Tab键时插入的空格数

-- 编码设置
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- 退格行为
vim.opt.backspace = 'indent,eol,start'

-- 针对 Go 文件的特定设置
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})