-- =============================================================================
-- Terminal (toggleterm.nvim) setup
-- =============================================================================

require("toggleterm").setup({
    -- Compute the terminal size dynamically
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.3
        end
    end,
    -- Hide line numbers in toggleterm buffers
    hide_numbers = true,
    -- Sync the terminal's directory with Neovim's cwd on next open
    autochdir = true,
    -- Floating window options
    float_opts = {
        border = "double",
    },
})
