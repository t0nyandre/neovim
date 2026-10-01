return {
    "folke/which-key.nvim",

    lazy = false,

    opts = {},

    config = function(_, opts)

        local wk = require("which-key")

        wk.setup(opts)

        wk.add({
            { "<leader>f", group = "Find" },
            { "<leader>l", group = "LSP" },
            { "<leader>d", group = "Diagnostics" },
            { "<leader>c", group = "Code" },
            { "<leader>g", group = "Git" },
        })
    end,
}
