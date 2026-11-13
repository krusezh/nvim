-- =============================================================================
-- Core Neovim options
-- =============================================================================

-- Set the <Leader> key
vim.g.mapleader = ","

-- Disable unused language providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Editor appearance
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight the current line
vim.opt.cursorcolumn = true -- Highlight the current column
vim.opt.signcolumn = "yes" -- Always show the sign column to prevent layout shifts
vim.opt.colorcolumn = "80" -- Show a guide at column 80

-- Behavior
vim.opt.mouse = "a" -- Enable mouse support in all modes
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Respect case when the pattern contains uppercase
vim.opt.smartindent = true -- Enable smart auto-indenting

-- Indentation
vim.opt.expandtab = true -- Expand tabs to spaces
vim.opt.shiftwidth = 4 -- Spaces per auto-indent step
vim.opt.softtabstop = 4 -- Spaces inserted when pressing Tab
vim.opt.tabstop = 4 -- Display width of a tab
vim.opt.autoindent = true -- Copy the previous line's indentation
vim.opt.shiftround = true -- Round indentation to a multiple of shiftwidth

-- Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Files and UI
vim.opt.fileformats = "unix,dos,mac"
vim.opt.showmode = false -- Don't show the mode message
vim.opt.showcmd = false -- Don't show pending commands
vim.opt.ruler = false -- Don't show the cursor position

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use Tree-sitter for folds
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Splits
vim.opt.splitright = true -- Open new windows to the right
vim.opt.splitbelow = true -- Open new windows below

-- Undo and backups
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true -- Persist undo history across sessions

-- Responsiveness
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.redrawtime = 10000

-- Clipboard and misc
vim.opt.clipboard = "unnamedplus" -- Use the system clipboard
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")
vim.opt.confirm = true -- Confirm actions that would discard modified buffers

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10

-- Register the Go template filetype for gopls
vim.filetype.add({
	extension = { gotmpl = "gotmpl" },
})

local augroup = vim.api.nvim_create_augroup("CoreOptions", { clear = true })

-- Use tabs for Go files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "go" },
	callback = function()
		vim.opt_local.expandtab = false
	end,
})

-- Use 2-space indentation for Lua
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "lua" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- Trim trailing whitespace on save (skip Markdown, where trailing spaces are meaningful)
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		if vim.bo[bufnr].filetype == "markdown" then
			return
		end
		if not vim.bo[bufnr].modifiable or vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].readonly then
			return
		end
		local save_cursor = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.setpos(".", save_cursor)
	end,
})

-- Restore the cursor position saved when the buffer was last closed
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
