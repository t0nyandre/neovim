local registry = require("utils.language_registry")

for _, tool in ipairs(registry.enabled_tools()) do
	local ok, module = pcall(require, "tools." .. tool)

	if ok and module.setup then
		module.setup()
	end
end
