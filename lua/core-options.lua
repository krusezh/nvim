vim.cmd('syntax on')
vim.g.mapleader = ','
vim.cmd('filetype plugin indent on')

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.encoding = 'utf-8'
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.cursorcolumn = true
vim.opt.laststatus = 2
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.colorcolumn = '80'
vim.opt.relativenumber = true
vim.opt.background = 'dark'
vim.opt.fileencoding = 'utf-8'
vim.opt.backspace = 'indent,eol,start'

vim.cmd('au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4')
