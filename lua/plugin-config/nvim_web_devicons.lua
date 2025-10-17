-- =============================================================================
-- 文件图标 (nvim-web-devicons) 设置
-- =============================================================================

require("nvim-web-devicons").setup({
    -- 自定义图标覆盖
    override = {
        zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh",
        },
    },
    -- 为未明确处理的文件类型启用默认图标
    default = true,
    -- 启用更严格的图标匹配规则
    strict = true,
    -- 按文件名覆盖图标
    override_by_filename = {
        [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore",
        },
    },
    -- 按文件扩展名覆盖图标
    override_by_extension = {
        ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log",
        },
    },
    -- 按操作系统覆盖图标
    override_by_operating_system = {
        ["apple"] = {
            icon = "",
            color = "#A2AAAD",
            cterm_color = "248",
            name = "Apple",
        },
    },
})
