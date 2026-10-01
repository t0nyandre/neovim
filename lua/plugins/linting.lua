return {
    "mfussenegger/nvim-lint",

    config = function()
        local lint = require("lint")
        local registry = require("utils.language_registry")
        local languages = require("config.features")

        local linters_by_ft = registry.filetype_map("linter")

        for ft, lang in pairs(languages) do
            if lang.enabled then
                linters_by_ft[ft] = lang.linter
            end
        end

        lint.linters_by_ft = linters_by_ft

        vim.api.nvim_create_autocmd(
            { "BufWritePost", "InsertLeave" },
            {
                callback = function()
                    lint.try_lint()
                end,
            }
        )
    end,
}
