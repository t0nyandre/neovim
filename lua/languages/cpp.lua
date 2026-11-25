-- C / C++. Single-file build/run fallback; CMake and PlatformIO projects override it
-- (see modules/tools). clangd finds compile_commands.json in the root or build/ by itself.

local function compile(ctx)
	local compiler = ctx.ft == "c" and "gcc -std=c17" or "g++ -std=c++20"
	local out = vim.fn.fnamemodify(ctx.file, ":r")
	return ("%s -Wall -Wextra -g %s -o %s"):format(compiler, vim.fn.shellescape(ctx.file), vim.fn.shellescape(out)), out
end

return {
	filetypes = { "c", "cpp" },
	treesitter = { "c", "cpp", "cmake" },

	lsp = {
		clangd = {
			filetypes = { "c", "cpp" },
			cmd = { "clangd", "--background-index", "--clang-tidy" },
		},
	},

	formatters = {
		c = { "clang_format" },
		cpp = { "clang_format" },
	},

	linters = {
		c = { "cpplint" },
		cpp = { "cpplint" },
	},

	mason = { "clangd", "clang-format", "cpplint" },
	requires = { "gcc", "g++" },

	provider = {
		priority = 10,
		actions = {
			build = function(ctx)
				return (compile(ctx))
			end,
			run = function(ctx)
				local cmd, out = compile(ctx)
				return ("%s && %s"):format(cmd, vim.fn.shellescape(out))
			end,
		},
	},

	buffer = function(buf)
		vim.bo[buf].commentstring = "// %s"
	end,
}
