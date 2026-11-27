-- Global keymaps that don't belong to a module. Leader groups (which-key):
--   <leader>f find   <leader>c code   <leader>x diagnostics   <leader>g git
--   <leader>u toggles   <leader>s snapshot   <leader>d debug
--   <leader>m make: build / run / test / configure / clean / pick task (core/actions.lua)
--   <leader>- split horizontally   <leader>| split vertically   <leader>w close split   (Alt+hjkl moves between splits)

local map = vim.keymap.set

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Splits
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>w", "<cmd>close<CR>", { desc = "Close split" })
map("n", "<A-h>", "<C-w>h", { desc = "Split left" })
map("n", "<A-j>", "<C-w>j", { desc = "Split down" })
map("n", "<A-k>", "<C-w>k", { desc = "Split up" })
map("n", "<A-l>", "<C-w>l", { desc = "Split right" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })

-- Diagnostics ([d / ]d are Neovim defaults)
map("n", "<leader>xf", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })

-- Leave terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
