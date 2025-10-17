require("gitsigns").setup({
    -- 自定义 Git 状态图标
    signs = {
        add = { text = "+" },
        change = { text = "┃" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },

    -- 不为未跟踪的文件附加 Git 状态
    attach_to_untracked = false,

    -- 启用当前行 blame 信息
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text = false, -- 将 blame 信息显示在行内
        delay = 1000,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})
