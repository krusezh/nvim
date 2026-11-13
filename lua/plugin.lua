-- =============================================================================
-- Plugin management (lazy.nvim)
-- =============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Use the stable release branch
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set the LSP log level to reduce noise
vim.lsp.log.set_level("warn")

-- Helper to load plugin configuration modules
local function config_plugin(name)
  return function()
    require("plugin-config." .. name)
  end
end

-- lazy.nvim setup
require("lazy").setup({
    -- =======================================================================
    -- A. Completion
    -- =======================================================================
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = config_plugin("nvim_cmp"),
      dependencies = {
        "hrsh7th/cmp-path",
        -- "hrsh7th/cmp-vsnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "petertriho/cmp-git",
        { "onsails/lspkind.nvim", event = "InsertEnter" }, -- Add icons and kind labels to completion items
      },
    },

    -- =======================================================================
    -- B. LSP & tooling
    -- =======================================================================
    {
      "williamboman/mason.nvim",
      cmd = "Mason",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
      config = config_plugin("mason-lspconfig"),
    },
    {
      "neovim/nvim-lspconfig",
      event = "BufReadPre",
      dependencies = { "williamboman/mason-lspconfig.nvim" },
      config = config_plugin("nvim_lspconfig"),
    },
    {
      "j-hui/fidget.nvim",
      event = "LspAttach",
      config = function()
        require("fidget").setup({})
      end,
    },

    -- =======================================================================
    -- C. Git tools
    -- =======================================================================
    {
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      config = config_plugin("gitsigns"),
    },
    -- {
    -- 	"kdheepak/lazygit.nvim",
    -- 	cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    -- 	dependencies = { "nvim-lua/plenary.nvim" },
    -- 	keys = { { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
    -- },

    -- =======================================================================
    -- D. UI & appearance
    -- =======================================================================
    {
      "ellisonleao/gruvbox.nvim",
      lazy = false,
      priority = 1000,
      config = config_plugin("gruvbox"),
    },
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
      config = config_plugin("nvim_web_devicons"),
    },
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = config_plugin("lualine"),
    },
    {
      "akinsho/bufferline.nvim",
      version = "*",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("bufferline").setup({})
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      cmd = "NvimTreeToggle",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = config_plugin("nvim_tree"),
    },
    {
      "goolord/alpha-nvim",
      event = "VimEnter",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = config_plugin("alpha"),
    },

    -- =======================================================================
    -- E. Core enhancements
    -- =======================================================================
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = "BufReadPre",
      config = config_plugin("nvim_treesitter"),
      commit = "310f0925ec64c7e54f3ee952679d285b13e5a735",
      pin = true,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "BufReadPre",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("render-markdown").setup({})
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup({})
      end,
    },
    {
      "numToStr/Comment.nvim",
      event = "BufReadPre",
      config = function()
        require("Comment").setup({})
      end,
    },
    {
      "folke/flash.nvim",
      event = "BufRead",
      config = config_plugin("flash"),
    },

    -- =======================================================================
    -- F. Other tools
    -- =======================================================================
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      cmd = "ToggleTerm",
      config = config_plugin("toggleterm"),
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      cmd = "Telescope",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build =
          "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        },
      },
      config = config_plugin("telescope"),
    },
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end,
    },
    {
      "folke/trouble.nvim",
      config = config_plugin("trouble"),
      cmd = "Trouble",
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      event = "BufReadPre",
      config = config_plugin("indent_blankline"),
    },
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        "rafamadriz/friendly-snippets",
      },
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "saadparwaiz1/cmp_luasnip",
      event = "InsertEnter",
    },
  },
  {
    install = { missing = true },
    rocks = { enabled = false },
  })

-- Disable unused built-in plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logipat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_matchit = 1
