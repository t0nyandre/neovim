-- Global keymaps that don't belong to a module. Leader groups (which-key):
--   <leader>f find   <leader>c code   <leader>x diagnostics   <leader>g git
--   <leader>u toggles   <leader>s snapshot   <leader>d debug
--   <leader>m make: build / run / test / configure / clean / pick task (core/actions.lua)

local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })

-- Diagnostics ([d / ]d are Neovim defaults)
map("n", "<leader>xf", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })

-- Leave terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
