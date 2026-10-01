local languages = require("config.features")

for language, config in pairs(languages) do
	if type(config) == "table" and config.enabled and config.filetypes then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = config.filetypes,

			callback = function()
				local ok, module = pcall(require, "languages." .. language)

				if ok and module.setup then
					module.setup()
				end
			end,
		})
	end
end
