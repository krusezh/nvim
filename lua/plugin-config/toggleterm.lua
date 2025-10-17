-- =============================================================================
-- 终端 (toggleterm.nvim) 设置
-- =============================================================================

require("toggleterm").setup({
    -- 动态计算终端窗口的大小
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.3
        end
    end,
    -- 隐藏 toggleterm 缓冲区的行号
    hide_numbers = true,
    -- 当 Neovim 的当前目录更改时，终端下次打开时也会更改目录
    autochdir = true,
    -- 浮动窗口选项
    float_opts = {
        border = "double",
    },
})
