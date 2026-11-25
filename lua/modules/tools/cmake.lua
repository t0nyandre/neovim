-- Inside a CMake project, <leader>b/r/t use cmake (overrides the C/C++ language fallback).
-- Build (and debug) (re)configures first when build/ is missing or has another build type.
return {
	desc = "CMake build/run/test actions in CMake projects",

	requires = { "cmake" },

	opts = {
		build_dir = "build",
		-- CMAKE_BUILD_TYPE. "Debug" gives -g so breakpoints bind; "Release"/"RelWithDebInfo" also work.
		build_type = "Debug",
		-- Executable for <leader>r and the debugger, relative to the project root, e.g. "./build/tank".
		-- nil = ask once per session (the answer is shared by run and debug).
		run = nil,
	},

	setup = function(opts)
		local dir = opts.build_dir

		local configure = ("cmake -B %s -DCMAKE_BUILD_TYPE=%s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"):format(
			dir,
			opts.build_type
		)

		-- Configure only when the cache is missing or was made with another build type.
		local function build(ctx)
			local cache = vim.fs.joinpath(ctx.root, dir, "CMakeCache.txt")
			local configured = false
			if vim.uv.fs_stat(cache) then
				for line in io.lines(cache) do
					local value = line:match("^CMAKE_BUILD_TYPE:%w+=(.*)$")
					if value then
						configured = value == opts.build_type
						break
					end
				end
			end
			local cmd = ("cmake --build %s"):format(dir)
			return configured and cmd or (configure .. " && " .. cmd)
		end

		--- The executable as typed (relative to root), asked once and stored in opts.run.
		local function executable()
			if not opts.run then
				local input = vim.fn.input("Executable: ", "./" .. dir .. "/", "file")
				if input == "" then
					return nil
				end
				opts.run = input
			end
			return opts.run
		end

		require("core.actions").register({
			name = "cmake",
			priority = 50,
			filetypes = { "c", "cpp", "cmake" },
			root_markers = { "CMakeLists.txt" },
			actions = {
				configure = configure,
				build = build,
				test = ("ctest --test-dir %s --output-on-failure"):format(dir),
				run = function(ctx)
					local exe = executable()
					return exe and ("%s && %s"):format(build(ctx), exe)
				end,
			},
			-- For the debugger: first word of `run`, made absolute.
			program = function(ctx)
				local exe = executable()
				exe = exe and exe:match("^%S+")
				if not exe then
					return nil
				end
				return vim.fs.normalize(exe:sub(1, 1) == "/" and exe or vim.fs.joinpath(ctx.root, exe))
			end,
		})
	end,
}
