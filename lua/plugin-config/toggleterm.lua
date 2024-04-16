toggleterm = require("toggleterm")
toggleterm.setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.3
		end
	end,
	start_in_insert = true,
	open_mapping = [[<c-\><c-\>]],
	hide_numbers = true, -- hide the number column in toggleterm buffers
	shade_terminals = true,
	-- shading_factor = 1,       -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
	start_in_insert = true,
	insert_mappings = true, -- whether or not the open mapping applies in insert mode
	autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
	terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
	-- persist_size = true,
	direction = "float",
	close_on_exit = true, -- close the terminal window when the process exits
	shell = vim.o.shell, -- change the default shell
	float_opts = {
		border = "double",
	},
	highlights = {
		-- highlights which map to a highlight group name and a table of it's values
		-- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
		-- Normal = {
		--   link = 'Pmenu'
		-- },
		-- NormalFloat = {
		--   link = 'Pmenu'
		-- },
		-- FloatBorder = {
		--   link = 'Pmenu'
		-- },
	},
})

