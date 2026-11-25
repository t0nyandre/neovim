-- Entry point. Everything you normally want to change lives in lua/user/config.lua.
--
--   lua/core/       options, keymaps, autocmds, module/language loaders, toggles, actions
--   lua/modules/    one file per feature: lua/modules/<group>/<name>.lua  -> "group.name"
--   lua/languages/  one file per language
--   lua/user/       your switches and overrides
--
-- :checkhealth core  lists what's enabled and which external tools are missing.

require("core.options")
require("core.keymaps")
require("core.autocmds")

local modules = require("core.modules")
local languages = require("core.languages")

modules.discover()
languages.discover()
modules.init()

if require("core.lazy") then
	require("core.toggles").setup()
	require("core.actions").setup()
	languages.setup()
	modules.setup()
end
