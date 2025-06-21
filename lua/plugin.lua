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

local function config_plugin(name)
    return function()
        require("plugin-config." .. name)
    end
end

require("lazy").setup({
    -- 补全引擎 (nvim-cmp)
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        config = config_plugin("nvim_cmp"),
    },
    { "hrsh7th/cmp-path",                    event = "InsertEnter" },
    { "hrsh7th/cmp-vsnip",                   event = "InsertEnter" },
    { "hrsh7th/cmp-buffer",                  event = "InsertEnter" },
    { "hrsh7th/cmp-cmdline",                 event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lsp",                event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lsp-signature-help", event = "InsertEnter" },
    { "hrsh7th/vim-vsnip",                   event = "InsertEnter" },

    -- 补全美化
    { "onsails/lspkind.nvim",                event = "InsertEnter" },

    -- 注释工具
    { "numToStr/Comment.nvim",               event = "BufReadPre" },

    -- LSP & 工具链
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = config_plugin("mason"),
    },
    -- LSP 核心生态 (整合为一个单元以确保加载顺序)
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre", -- 整个LSP生态系统在打开文件时加载
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        -- config = config_plugin("nvim_lspconfig"),
        config = function()
            require("plugin-config.mason")
            require("plugin-config.nvim_lspconfig")
        end,
    },
    {
        "j-hui/fidget.nvim",
        version = "*",
        event = "LspAttach",
        config = config_plugin("fidget"),
    },
    {
        "nvimtools/none-ls.nvim",
        requires = "nvim-lua/plenary.nvim",
        event = "BufReadPre",
        config = config_plugin("none_ls"),
    },

    -- Git
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

    -- 语法高亮
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPre",
        config = config_plugin("nvim_treesitter"),
    },

    -- UI & 主题
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,    -- 确保在启动时立即加载
        priority = 1000, -- 确保在其他UI插件前加载
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
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        cmd = "NvimTreeToggle",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = config_plugin("nvim_tree"),
    },

    -- 自动配对
    { "windwp/nvim-autopairs", event = "InsertEnter" },

    -- 终端
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = { "<c-\\>t", "<c-\\>a", "<c-\\>s" },
        config = config_plugin("toggleterm"),
    },

    -- 模糊搜索
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
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

    -- LSP UI 增强
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        config = config_plugin("lspsaga"),
    },

    -- 快速跳转
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
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
})
