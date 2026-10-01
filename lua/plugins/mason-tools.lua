local registry =
    require("utils.language_registry")

return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        dependencies = {
            "williamboman/mason.nvim",
        },

        opts = {
            ensure_installed =
                registry.collect("mason"),
        },
    },
}
