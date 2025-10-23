-- =============================================================================
-- 插件管理 (lazy.nvim)
-- =============================================================================

-- 自动安装 lazy.nvim
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

-- 设置LSP日志级别，减少不必要的日志输出
vim.lsp.set_log_level("warn")

-- 一个辅助函数，用于简化插件配置的加载
local function config_plugin(name)
    return function()
        require("plugin-config." .. name)
    end
end

-- lazy.nvim 设置
require("lazy").setup({
    -- =========================================================================
    -- A. 补全引擎
    -- =========================================================================
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = config_plugin("nvim_cmp"),
        dependencies = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/vim-vsnip",
            { "onsails/lspkind.nvim", event = "InsertEnter" }, -- 美化补全项
        },
    },

    -- =========================================================================
    -- B. LSP & 开发工具链
    -- =========================================================================
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        config = config_plugin("mason"),
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
        config = config_plugin("fidget"),
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufReadPre",
        config = config_plugin("none_ls"),
    },
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        config = config_plugin("lspsaga"),
    },

    -- =========================================================================
    -- C. Git 工具
    -- =========================================================================
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = config_plugin("gitsigns"),
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = { { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" } },
    },

    -- =========================================================================
    -- D. UI & 外观
    -- =========================================================================
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = config_plugin("gruvbox"),
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

    -- =========================================================================
    -- E. 核心功能增强
    -- =========================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPre",
        config = config_plugin("nvim_treesitter"),
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
    },
    {
        "numToStr/Comment.nvim",
        event = "BufReadPre",
    },
    {
        "folke/flash.nvim",
        event = "BufRead",
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
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    -- =========================================================================
    -- F. 其他工具
    -- =========================================================================
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = { "<c-\\>t", "<c-\\>a", "<c-\\>s" },
        config = config_plugin("toggleterm"),
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
        },
        config = config_plugin("telescope"),
    },
})