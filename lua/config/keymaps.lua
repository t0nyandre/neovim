local map = vim.keymap.set

vim.g.mapleader = " "

local opts = {
    noremap = true,
    silent = true,
}

--------------------------------------------------
-- Window Navigation
--------------------------------------------------

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

--------------------------------------------------
-- Clear Search
--------------------------------------------------

map("n", "<Esc>", "<cmd>noh<CR>", opts)

--------------------------------------------------
-- Telescope
--------------------------------------------------

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

--------------------------------------------------
-- LSP
--------------------------------------------------

map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gD", vim.lsp.buf.declaration, opts)
map("n", "gr", vim.lsp.buf.references, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "K", vim.lsp.buf.hover, opts)

map("n", "<leader>lr", vim.lsp.buf.rename, opts)
map("n", "<leader>la", vim.lsp.buf.code_action, opts)

--------------------------------------------------
-- Diagnostics
--------------------------------------------------

map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)

map("n", "<leader>dd", vim.diagnostic.open_float, opts)

--------------------------------------------------
-- Formatting
--------------------------------------------------

map("n", "<leader>cf", function()
    require("conform").format({
        async = true,
    })
end, opts)
