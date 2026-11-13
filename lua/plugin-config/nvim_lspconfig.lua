-- =============================================================================
-- LSP (Language Server Protocol) core setup
-- =============================================================================

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

-- Prefer Mason-installed executables, falling back to the same command on PATH
local function mason_cmd(name, args)
  local path = mason_bin .. "/" .. name
  local cmd

  if vim.fn.executable(path) == 1 then
    cmd = path
  elseif vim.fn.executable(name) == 1 then
    cmd = name
  else
    return nil
  end

  local full_cmd = { cmd }
  if args then
    vim.list_extend(full_cmd, args)
  end
  return full_cmd
end

-- Global client capabilities and defaults
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Use UTF-16 offsets consistently so pyright and ruff agree
capabilities.general = { positionEncodings = { "utf-16" } }

vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { ".git", ".hg", ".svn" },
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  }
})

-- Format-on-save toggle
if vim.g.lsp_format_on_save == nil then
  vim.g.lsp_format_on_save = true
end

-- Toggle format-on-save at runtime
vim.api.nvim_create_user_command("LspFormatToggle", function()
  vim.g.lsp_format_on_save = not vim.g.lsp_format_on_save
  local state = vim.g.lsp_format_on_save and "enabled" or "disabled"
  vim.notify("LSP format on save: " .. state, vim.log.levels.INFO)
end, {})

-- =============================================================================
-- Language server configurations
-- =============================================================================

-- Lua
vim.lsp.config("lua_ls", {
  cmd = mason_cmd("lua-language-server"),
  settings = {
    Lua = {
      diagnostics = {
        -- Treat `vim` as a global to avoid undefined-variable warnings
        globals = { "vim" },
      },
      workspace = {
        -- Don't check third-party libraries
        checkThirdParty = false,
      },
      -- Default formatting: 2-space indentation
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
    },
  },
})
vim.lsp.enable("lua_ls")

-- C / C++
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--offset-encoding=utf-16" }, -- Match the shared UTF-16 offset encoding
})
vim.lsp.enable("clangd")

-- Go
vim.lsp.config("gopls", {
  cmd = mason_cmd("gopls"),
  settings = {
    gopls = {
      usePlaceholders = true,
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
    },
  },
})
vim.lsp.enable("gopls")

-- Python
vim.lsp.config("pyright", {
  cmd = mason_cmd("pyright-langserver", { "--stdio" }),
  root_markers = { "pyproject.toml", "pyrightconfig.json", "setup.py", "setup.cfg", "requirements.txt", ".git" },
})
vim.lsp.enable("pyright")

-- Ruff: linting and auto-fixes
vim.lsp.config("ruff", {
  cmd = mason_cmd("ruff", { "server" }),
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})
vim.lsp.enable("ruff")

-- Rust
vim.lsp.config("rust_analyzer", {
  cmd = mason_cmd("rust-analyzer"),
  settings = {
    ["rust-analyzer"] = {}, -- Use default settings
  },
})
vim.lsp.enable("rust_analyzer")

-- =============================================================================
-- Diagnostic display settings
-- =============================================================================
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅙",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "󰋼",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

-- =============================================================================
-- LSP buffer setup
-- =============================================================================
-- Enable omnifunc completion when a server attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Ruff: apply source.fixAll.ruff fixes on save
    if client and client.name == "ruff" then
      local group = vim.api.nvim_create_augroup("RuffFixOnSave", {})
      vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        buffer = bufnr,
        callback = function()
          if not vim.bo[bufnr].modifiable or vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].readonly then
            return
          end

          -- Request and apply the first matching code action
          local function apply_code_action(kind)
            local params = {
              textDocument = vim.lsp.util.make_text_document_params(bufnr),
              range = {
                start = { line = 0, character = 0 },
                ["end"] = { line = 0, character = 0 },
              },
              context = {
                only = { kind },
                diagnostics = {},
              },
            }

            local resp = client.request_sync("textDocument/codeAction", params, 2000, bufnr)
            if not resp or not resp.result then
              return
            end

            for _, action in ipairs(resp.result) do
              local action_kind = action.kind or ""
              if action_kind == kind or vim.startswith(action_kind, kind) then
                local resolved_action = action
                if (not action.edit and not action.command) and client:supports_method("codeAction/resolve") then
                  local resolved = client.request_sync("codeAction/resolve", action, 2000, bufnr)
                  if resolved and resolved.result then
                    resolved_action = resolved.result
                  end
                end

                if resolved_action.edit then
                  vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
                end

                local command = resolved_action.command
                if command then
                  if type(command) == "table" then
                    client.request_sync(
                      "workspace/executeCommand",
                      { command = command.command, arguments = command.arguments },
                      2000,
                      bufnr
                    )
                  else
                    client.request_sync(
                      "workspace/executeCommand",
                      { command = command, arguments = resolved_action.arguments },
                      2000,
                      bufnr
                    )
                  end
                end
                return
              end
            end
          end

          apply_code_action("source.fixAll.ruff")
        end,
      })
    end

    -- Format on save (only for clients with textDocument/formatting support)
    if client and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          if vim.g.lsp_format_on_save == false then
            return
          end
          vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
        end,
      })
    end
  end,
})
