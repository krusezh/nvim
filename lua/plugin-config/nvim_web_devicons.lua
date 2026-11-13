-- =============================================================================
-- File icons (nvim-web-devicons) setup
-- =============================================================================

require("nvim-web-devicons").setup({
    -- Custom icon overrides
    override = {
        zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh",
        },
    },
    -- Use default icons for unhandled filetypes
    default = true,
    -- Match by filename first, then by exact extension
    strict = true,
    -- Override icons by filename
    override_by_filename = {
        [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore",
        },
    },
    -- Override icons by extension
    override_by_extension = {
        ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log",
        },
    },
    -- Override icons by operating system
    override_by_operating_system = {
        ["apple"] = {
            icon = "",
            color = "#A2AAAD",
            cterm_color = "248",
            name = "Apple",
        },
    },
})
