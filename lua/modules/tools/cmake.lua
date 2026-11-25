-- Inside a CMake project, <leader>b/r/t use cmake (overrides the C/C++ language fallback).
return {
	desc = "CMake build/run/test actions in CMake projects",

	requires = { "cmake" },

	opts = {
		build_dir = "build",
		-- Command for <leader>r, relative to the project root. nil = ask once per session.
		run = nil,
	},

	setup = function(opts)
		local dir = opts.build_dir
		local run_cmd = opts.run

		require("core.actions").register({
			name = "cmake",
			priority = 50,
			filetypes = { "c", "cpp", "cmake" },
			root_markers = { "CMakeLists.txt" },
			actions = {
				configure = ("cmake -B %s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"):format(dir),
				build = ("cmake --build %s"):format(dir),
				test = ("ctest --test-dir %s --output-on-failure"):format(dir),
				run = function(ctx)
					if not run_cmd then
						local input = vim.fn.input("Executable to run: ", "./" .. dir .. "/", "file")
						if input == "" then
							return nil
						end
						run_cmd = input
					end
					return ("cmake --build %s && %s"):format(dir, run_cmd)
				end,
			},
		})
	end,
}
