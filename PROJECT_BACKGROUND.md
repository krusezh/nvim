# Neovim Config Project Background

Overview of the current Neovim configuration in this repository. It documents the
load order, file responsibilities, plugins, and intentional behavior choices.

## Entry and Load Order

1. `init.lua` requires `core-options`, then `plugin`, then `keybindings`.
2. `lua/plugin.lua` bootstraps `lazy.nvim` and declares all plugins.
3. `lua/plugin-config/*` contains per-plugin configuration modules.

## Files

- `lua/core-options.lua` — leader key (`,`), UI, indentation, folds, undo, clipboard,
  and autocmds. Global indentation is 4 spaces; Go uses tabs; Lua uses 2 spaces.
  Autocmds: yank highlight, trailing-whitespace trim on save (skipped for Markdown),
  last-cursor restore, per-filetype indentation.
- `lua/plugin.lua` — lazy.nvim bootstrap, `vim.lsp.log` level, plugin specs, and
  disabling of unused built-in plugins (archives, matchit, etc.).
- `lua/keybindings.lua` — leader mappings for nvim-tree, LSP (`gd`, `gD`, `K`,
  rename, code action, format), diagnostics, Telescope, and ToggleTerm. Modern
  Neovim defaults (`gr*`, `gi`, `gf`) are intentionally left unshadowed.
- `lua/plugin-config/` — one module per plugin (see below).

## Plugins

Completion: `nvim-cmp` with LSP, signature help, LuaSnip, buffer, path, and git
sources; `lspkind` icons; VSCode snippets via `friendly-snippets`.

LSP: `mason.nvim`, `mason-lspconfig.nvim` (installs `lua_ls`, `gopls`, `pyright`,
`ruff`, `rust_analyzer`), `nvim-lspconfig`, `fidget.nvim`. Servers are configured
and enabled with `vim.lsp.config` / `vim.lsp.enable`:
- `lua_ls`, `gopls`, `pyright`, `ruff`, `rust_analyzer` from Mason.
- `clangd` from the system.
- Client capabilities force UTF-16 position encoding so pyright and ruff agree on
  one offset encoding.
- Format on save is on by default (`vim.g.lsp_format_on_save`), only for clients
  supporting `textDocument/formatting` (currently Ruff); `:LspFormatToggle`
  switches it. Ruff's `source.fixAll.ruff` action also runs on save.

Treesitter: `nvim-treesitter` is pinned (`pin = true`) to commit `310f0925`.
`:TSInstallPreferred` installs the languages listed in
`plugin-config/nvim_treesitter.lua` (including Python). Highlighting starts per
buffer when a parser is available.

Git: `gitsigns` with custom signs and current-line blame (virtual text, 1s delay).

UI: `gruvbox`, `lualine`, `bufferline`, `nvim-tree`, `alpha` (optional `fortune`
footer), `nvim-web-devicons`, `indent-blankline`, `trouble`.

Editing: `flash` (`s`, `S`, `r`, `R`, `<C-s>`), `nvim-autopairs`,
`Comment.nvim`, `nvim-surround`, `render-markdown` for Markdown.

Search and terminal: `telescope` with `fzf-native`, and `toggleterm`.

## Intentional Choices

- `flash` uses `s`/`S`, replacing Vim's substitute/change behavior. This is the
  standard flash.nvim setup for fast navigation.
- Trailing whitespace is trimmed on save for all filetypes except Markdown
  (where two trailing spaces are meaningful).
- `nvim-treesitter` is pinned to remain compatible with this configuration; do
  not update it without reviewing API changes.
- Plugin versions are locked in `lazy-lock.json`.

## Maintenance

- `:checkhealth` for diagnostics.
- `:Lazy sync` / `:Lazy update` for plugins (respecting pinned specs).
- `:Mason` to inspect LSP servers and tools.
- `:TSInstallPreferred` to restore the configured treesitter parsers.
