require("gitsigns").setup({
    -- Customize Git status signs
    signs = {
        add = { text = "+" },
        change = { text = "┃" },
        delete = { text = "-" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },

    -- Don't attach to untracked files
    attach_to_untracked = false,

    -- Show blame for the current line
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 1000,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})
