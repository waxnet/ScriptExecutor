callbacks = {}
do
	callbacks.safeCall = function(scriptData, callback, ...)
		func = scriptData.objects[callback]
		if type(func) == "function" then
			func(...)
		end
	end
end
