#include "core/callbacks.lua"
#include "core/storage.lua"

handler = {}
do
	handler.currentScriptIndex = 0

	handler.addScript = function(path)
		local scriptName = path:match("([^/\\]+)%.%w+$")
		
		storage.scripts[scriptName] = {
			name = scriptName,
			objects = dofile(path),
			file = path,
			init = false,
			index = handler.currentScriptIndex
		}
		handler.currentScriptIndex = (handler.currentScriptIndex + 1)
	end

	handler.removeScript = function(scriptName)
		storage.scripts[scriptName] = nil
	end

	handler.reloadScript = function(scriptName)
		storage.scripts[scriptName]["objects"] = dofile(storage.scripts[scriptName]["file"])
		storage.scripts[scriptName]["init"] = false
	end
end
