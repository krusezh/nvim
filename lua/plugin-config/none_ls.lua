local null_ls = require("null-ls")

-- 为 none-ls 定义代码源
local sources = {
    -- 格式化
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.asmfmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),

    -- 诊断
    null_ls.builtins.diagnostics.golangci_lint,

    -- 代码操作
    null_ls.builtins.code_actions.impl,
    null_ls.builtins.code_actions.gomodifytags,

    -- 补全
    null_ls.builtins.completion.spell,
}

-- 设置 none-ls
null_ls.setup({
    sources = sources,
    -- 设置保存时自动格式化
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            local augroup = vim.api.nvim_create_augroup("NoneLsFormatOnSave", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        filter = function(c)
                            return c.name == "null-ls"
                        end,
                        async = false,
                    })
                end,
            })
        end
    end,
})
