return {
	desc = "Language servers from enabled languages (nvim-lspconfig + vim.lsp.enable)",

	groups = { { "<leader>c", group = "code" } },

	plugins = {
		{ "neovim/nvim-lspconfig", lazy = false },
	},

	setup = function()
		local modules = require("core.modules")

		for server, cfg in pairs(require("core.languages").servers()) do
			vim.lsp.config(server, cfg)
			vim.lsp.enable(server)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("modules.coding.lsp", { clear = true }),
			callback = function(ev)
				local function map(lhs, rhs, desc, mode)
					vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, desc = desc, nowait = true })
				end

				local picker = modules.is_enabled("editor.picker") and _G.Snacks and Snacks.picker
				if picker then
					map("gd", function()
						Snacks.picker.lsp_definitions()
					end, "Goto definition")
					map("gr", function()
						Snacks.picker.lsp_references()
					end, "References")
					map("gi", function()
						Snacks.picker.lsp_implementations()
					end, "Goto implementation")
					map("gy", function()
						Snacks.picker.lsp_type_definitions()
					end, "Goto type definition")
					map("<leader>cs", function()
						Snacks.picker.lsp_symbols()
					end, "Document symbols")
					map("<leader>cS", function()
						Snacks.picker.lsp_workspace_symbols()
					end, "Workspace symbols")
				else
					map("gd", vim.lsp.buf.definition, "Goto definition")
					map("gr", vim.lsp.buf.references, "References")
					map("gi", vim.lsp.buf.implementation, "Goto implementation")
					map("gy", vim.lsp.buf.type_definition, "Goto type definition")
					map("<leader>cs", vim.lsp.buf.document_symbol, "Document symbols")
				end

				map("gD", vim.lsp.buf.declaration, "Goto declaration")
				map("K", vim.lsp.buf.hover, "Hover")
				map("<leader>cr", vim.lsp.buf.rename, "Rename")
				map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
				map("<leader>ci", "<cmd>checkhealth vim.lsp<CR>", "LSP info")
			end,
		})
	end,
}
