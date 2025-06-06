local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
vim.lsp.set_log_level("warn")

require("lazy").setup({
	{ "hrsh7th/nvim-cmp", event = "InsertEnter" },
	{ "hrsh7th/cmp-path", event = "InsertEnter" },
	{ "hrsh7th/vim-vsnip", event = "InsertEnter" },
	{ "hrsh7th/cmp-vsnip", event = "InsertEnter" },
	{ "hrsh7th/cmp-buffer", event = "InsertEnter" },
	{ "hrsh7th/cmp-cmdline", event = "InsertEnter" },
	{ "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
	{ "hrsh7th/cmp-nvim-lsp-signature-help", event = "InsertEnter" },
	{ "onsails/lspkind.nvim" },
	{ "numToStr/Comment.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "zbirenbaum/copilot.lua" },
	{ "lewis6991/gitsigns.nvim" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "j-hui/fidget.nvim", version = "*" },
	-- { "nvim-treesitter/nvim-treesitter-context" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvimtools/none-ls.nvim", requires = "nvim-lua/plenary.nvim" },
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{ "nvim-lualine/lualine.nvim", event = "VeryLazy", dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "akinsho/bufferline.nvim", version = "*", event = "VeryLazy", dependencies = "nvim-tree/nvim-web-devicons" },
	{ "nvim-tree/nvim-tree.lua", version = "*", lazy = false, dependencies = { "nvim-tree/nvim-web-devicons" } },
	-- {
	-- 	"linrongbin16/lsp-progress.nvim",
	-- 	config = function()
	-- 		require("lsp-progress").setup()
	-- 	end,
	-- },
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		lazy = true,
		keys = {
			{ "<c-\\>t", "<cmd>ToggleTerm<cr>", desc = "ToggleTerm" },
			{
				"<c-\\>a",
				"<cmd>ToggleTerm dir=~/Desktop direction=horizontal name=desktop<cr>",
				desc = "ToggleTerm Desktop",
			},
			{ "<c-\\>s", "<cmd>TermSelect<cr>", desc = "Term Select" },
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = {
			"sharkdp/fd",
			"BurntSushi/ripgrep",
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
	{
		"folke/flash.nvim",
		event = "BufRead",
		---@type Flash.Config
		opts = {
			label = {
				uppercase = false,
			},
			modes = {
				search = {
					enabled = false,
				},
			},
		},
                -- stylua: ignore
                keys = {
                    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
                    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
                    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
                    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
                },
	},
})
