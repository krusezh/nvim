-- =============================================================================
-- Completion engine (nvim-cmp) setup
-- =============================================================================

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

cmp.setup({
	-- Use LuaSnip for snippet expansion
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	-- Rounded borders for completion and documentation windows
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- Key mappings
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous item
		["<C-j>"] = cmp.mapping.select_next_item(), -- Next item
		["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
		["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
		["<C-Space>"] = cmp.mapping.complete(), -- Manually trigger completion
		["<C-e>"] = cmp.mapping.abort(), -- Close the completion menu
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm the selected item

		-- Smart Tab behavior
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- If the menu is visible, Tab selects the next item
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				-- If a snippet can be expanded or jumped to, expand or jump
				luasnip.expand_or_jump()
			else
				-- Otherwise, fall back to the default Tab behavior
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- If the menu is visible, Shift-Tab selects the previous item
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				-- If a previous snippet placeholder exists, jump back to it
				luasnip.jump(-1)
			else
				-- Otherwise, fall back to the default behavior
				fallback()
			end
		end, { "i", "s" }),
	}),

	-- Completion sources (LSP and snippets first, buffer and path as fallback)
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000, max_item_count = 20 },
		{ name = "nvim_lsp_signature_help", priority = 1000 }, -- Show function signatures as completion items
		{ name = "luasnip", priority = 750, max_item_count = 10 },
	}, {
		{ name = "buffer", priority = 500, max_item_count = 10 }, -- Complete from the current buffer
		{ name = "path", priority = 250, max_item_count = 10 }, -- Complete file paths
	}),

	-- Use lspkind to add icons and item kinds
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text", -- Show icon and text
			maxwidth = 50, -- Limit the maximum width
			ellipsis_char = "...", -- Truncate with an ellipsis when too wide
		}),
	},
})

-- Enable Git completion (commits, branches, etc.)
require("cmp_git").setup()

-- Context-specific completion sources
-- 1. Git commit messages
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" },
	}, {
		{ name = "buffer" },
	}),
})

-- 2. Command-line completion
--    - When searching with "/" or "?"
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

--    - When entering a ":" command
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
