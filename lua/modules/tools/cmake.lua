-- Inside a CMake project, <leader>m* use cmake (overrides the C/C++ language fallback).
--
-- The project root is the OUTERMOST CMakeLists.txt inside the git repo, so editing
-- src/foo.cpp next to src/CMakeLists.txt still builds in <root>/build.
--
-- Configuring writes build/compile_commands.json and symlinks it to <root>/compile_commands.json,
-- so clangd (and clang-tidy) see the same include paths as the build, find_package libraries
-- included. Add compile_commands.json to the project's .gitignore.
--
--   <leader>mc  configure (regenerates compile_commands.json)
--   <leader>mb  build (configures first when needed)
--   <leader>mC  delete build/ and reconfigure (asks first)
return {
	desc = "CMake build/run/test actions in CMake projects",

	requires = { "cmake" },

	opts = {
		build_dir = "build",
		-- CMAKE_BUILD_TYPE. "Debug" gives -g so breakpoints bind; "Release"/"RelWithDebInfo" also work.
		build_type = "Debug",
		-- Executable for <leader>mr and the debugger, relative to the project root, e.g. "./build/tank".
		-- nil = ask once per session (the answer is shared by run and debug).
		run = nil,
	},

	setup = function(opts)
		local dir = opts.build_dir
		assert(dir ~= "" and dir ~= "." and dir ~= "/", "tools.cmake: build_dir must be a subdirectory")
		local db = vim.fs.joinpath(dir, "compile_commands.json")

		local link = ("ln -sfn %s compile_commands.json"):format(vim.fn.shellescape(db))
		local configure = ("cmake -S . -B %s -DCMAKE_BUILD_TYPE=%s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && %s"):format(
			vim.fn.shellescape(dir),
			opts.build_type,
			link
		)

		--- Whether build/ exists and was configured with opts.build_type.
		local function configured(ctx)
			local cache = vim.fs.joinpath(ctx.root, dir, "CMakeCache.txt")
			if not vim.uv.fs_stat(cache) then
				return false
			end
			for line in io.lines(cache) do
				local value = line:match("^CMAKE_BUILD_TYPE:%w+=(.*)$")
				if value then
					return value == opts.build_type
				end
			end
			return false
		end

		local function build(ctx)
			local cmd = ("cmake --build %s"):format(vim.fn.shellescape(dir))
			if not configured(ctx) then
				return configure .. " && " .. cmd
			end
			-- Projects configured before the symlink existed: add it.
			if not vim.uv.fs_lstat(vim.fs.joinpath(ctx.root, "compile_commands.json")) then
				cmd = cmd .. " && " .. link
			end
			return cmd
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
			outermost_root = true,
			actions = {
				configure = configure,
				build = build,
				test = function(ctx)
					return build(ctx) .. (" && ctest --test-dir %s --output-on-failure"):format(vim.fn.shellescape(dir))
				end,
				run = function(ctx)
					local exe = executable()
					return exe and ("%s && %s"):format(build(ctx), exe)
				end,
				clean = function(ctx)
					local target = vim.fs.joinpath(ctx.root, dir)
					if vim.fn.confirm(("Delete %s and reconfigure?"):format(target), "&Yes\n&No", 2) ~= 1 then
						return nil
					end
					return ("rm -rf %s && %s"):format(vim.fn.shellescape(dir), configure)
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
