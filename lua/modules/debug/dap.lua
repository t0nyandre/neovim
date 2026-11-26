-- Debugging: nvim-dap + nvim-dap-ui + inline variable values.
-- Adapters and launch configurations come from the languages (their `dap` field), e.g.
-- languages/cpp.lua wires gdb. <leader>dc starts (building first) or continues.
return {
	desc = "Debugger (nvim-dap, dap-ui, virtual text); adapters come from languages",

	groups = { { "<leader>d", group = "debug" } },

	opts = {
		-- action -> lhs; set one to false to drop it.
		keys = {
			continue = "<leader>dc",
			breakpoint = "<leader>db",
			condition = "<leader>dB",
			step_over = "<leader>do",
			step_into = "<leader>di",
			step_out = "<leader>dO",
			repl = "<leader>dr",
			ui = "<leader>du",
			eval = "<leader>de",
			terminate = "<leader>dt",
		},
		-- Open the UI when a session starts. It stays open when the program exits so its
		-- output can still be read; <leader>dt / <leader>du close it.
		auto_open = true,
		ui = {}, -- passed to require("dapui").setup()
		virtual_text = {}, -- passed to require("nvim-dap-virtual-text").setup()
	},

	plugins = function(opts)
		local actions = {
			continue = {
				function()
					require("dap").continue()
				end,
				"Start / continue",
			},
			breakpoint = {
				function()
					require("dap").toggle_breakpoint()
				end,
				"Toggle breakpoint",
			},
			condition = {
				function()
					require("dap").set_breakpoint(vim.fn.input("Condition: "))
				end,
				"Conditional breakpoint",
			},
			step_over = {
				function()
					require("dap").step_over()
				end,
				"Step over",
			},
			step_into = {
				function()
					require("dap").step_into()
				end,
				"Step into",
			},
			step_out = {
				function()
					require("dap").step_out()
				end,
				"Step out",
			},
			repl = {
				function()
					require("dap").repl.toggle()
				end,
				"Toggle REPL",
			},
			ui = {
				function()
					require("dapui").toggle()
				end,
				"Toggle UI",
			},
			eval = {
				function()
					require("dapui").eval()
				end,
				"Evaluate",
				{ "n", "x" },
			},
			terminate = {
				function()
					require("dap").terminate()
					require("dapui").close()
				end,
				"Terminate",
			},
		}

		local keys = {}
		for name, lhs in pairs(opts.keys) do
			local action = actions[name]
			if lhs and action then
				table.insert(keys, { lhs, action[1], desc = action[2], mode = action[3] })
			end
		end

		return {
			{
				"mfussenegger/nvim-dap",
				dependencies = {
					{ "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
					"theHamsta/nvim-dap-virtual-text",
				},
				keys = keys,
				config = function()
					local dap, dapui = require("dap"), require("dapui")

					local spec = require("core.languages").dap()
					for name, adapter in pairs(spec.adapters) do
						dap.adapters[name] = adapter
					end
					for ft, list in pairs(spec.configurations) do
						dap.configurations[ft] = vim.list_extend(dap.configurations[ft] or {}, list)
					end

					dapui.setup(opts.ui)
					require("nvim-dap-virtual-text").setup(opts.virtual_text)

					if opts.auto_open then
						dap.listeners.after.event_initialized["debug.dap"] = function()
							dapui.open()
						end
					end

					vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
					vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
					vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
					vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })
				end,
			},
		}
	end,
}
