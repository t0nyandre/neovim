return {
    "stevearc/conform.nvim",

    opts = function()
        local languages = require("config.features")
        local registry = require("utils.language_registry")

        local formatters_by_ft = registry.filetype_map("formatter")

        for ft, lang in pairs(languages) do
            if lang.enabled then
                formatters_by_ft[ft] = lang.formatter
            end
        end

        return {
            formatters_by_ft = formatters_by_ft,

            format_on_save = {
                timeout_ms = 500,
            },
        }
    end,
}
