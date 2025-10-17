require("lspsaga").setup({
    -- UI 界面设置
    ui = {
        border = "rounded",
        -- 自定义图标
        expand = "⊞",
        collapse = "⊟",
        code_action = "💡",
        actionfix = " ",
        lines = { "┗", "┣", "┃", "━", "┏" },
        imp_sign = "󰳛 ",
    },

    -- 代码操作灯泡图标的防抖设置 (ms)
    lightbulb = {
        debounce = 10,
    },

    -- 在 winbar 中显示代码结构
    symbol_in_winbar = {
        enable = true,
        separator = " / ",
        ignore_patterns = {},
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true,
    },
})
