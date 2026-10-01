return {
    "saghen/blink.cmp",

    version = "*",

    opts = {
        keymap = {
            preset = "default",
            ["<Tab>"] = { "accept" },
            ["<S-Tab>"] = { "select_prev" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },

        completion = {
            documentation = {
                auto_show = true,
            },
        },
    },
}
