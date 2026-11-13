-- =============================================================================
-- Syntax highlighting (nvim-treesitter) setup
-- =============================================================================

-- Parsers for commonly used languages
local preferred_parsers = {
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
	"python",
}

-- Install all listed parsers synchronously
vim.api.nvim_create_user_command("TSInstallPreferred", function()
	vim.cmd("TSInstallSync " .. table.concat(preferred_parsers, " "))
end, {})

local augroup = vim.api.nvim_create_augroup("TreesitterStart", { clear = true })

-- Start highlighting when a parser is available
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})
