#include "data/config.lua"

#include "core/callbacks.lua"
#include "core/handler.lua"
#include "core/storage.lua"

#include "utils/tables.lua"

function tick(dt)
	for _, scriptData in pairs(storage.scripts) do
		if not scriptData.init then
			callbacks.safeCall(scriptData, "INIT")
			scriptData.init = true
		end
		callbacks.safeCall(scriptData, "TICK", dt)
	end
end

function update(dt)
	for _, scriptData in pairs(storage.scripts) do
		if scriptData.init then
			callbacks.safeCall(scriptData, "UPDATE", dt)
		end
	end
end

function draw()
	-- check ui activation
	if InputPressed("return") then
        config.ui = not config.ui
    end
	if not config.ui then
		for _, scriptData in pairs(storage.scripts) do
			if scriptData.init then
				callbacks.safeCall(scriptData, "DRAW", dt)
			end
		end
		return
	end
	
	-- background
	UiPush()
		UiColor(0, 0, 0, .5)
		UiRect(UiWidth(), UiHeight())
	UiPop()
	UiBlur(.8)
	
	-- handle scrolling
	config.scrollPosition = (config.scrollPosition + (InputValue("mousewheel") * 10))
	if config.scrollPosition > 0 then
		config.scrollPosition = 0
	end
	UiTranslate(0, config.scrollPosition)
	
	-- setup
	UiMakeInteractive()
	UiTextOutline(0, 0, 0, 1, .5)
	UiAlign("center middle")
	UiFont("bold.ttf", 18)
	UiTranslate(
		(UiWidth() / 2),
		0
	)
	
	-- title
	UiPush()
		UiFont("bold.ttf", 60)
		UiTranslate(0, 40)
		UiText("Script Executor")
	UiPop()
	
	-- script manager
	UiPush()
		-- data
		local textWidth = UiGetTextSize(config.input)
	
		-- setup
		UiTranslate(0, 140)
		
		-- window and title
		local windowWidth = (100 + (textWidth + 12))
		local windowHeight = 90
		
		UiColor(1, 0, 0)
		UiRect(windowWidth, windowHeight)
		UiColor(.05, .05, .05)
		UiRect((windowWidth - 2), (windowHeight - 2))
		UiPush()
			UiColor(1, 1, 1)
			UiTranslate(0, -((windowHeight / 2) - 14))
			UiText("Manager")
		UiPop()
		
		-- input box and add button
		local inputWidth = (textWidth + 30)
		
		UiPush()
			UiTranslate(0, -((windowHeight / 2) - 38))
			UiColor(0, 0, 0)
			UiRect((inputWidth + 2), 28)
			UiColor(.1, .1, .1)
			UiRect(inputWidth, 26)
			UiPush()
				UiColor(1, 1, 1)
				config.input = UiTextInput(config.input, inputWidth, 42, false)
			UiPop()
			
			UiTranslate(0, 30)
			UiColor(0, 0, 0)
			UiRect(40, 28)
			UiColor(.1, .1, .1)
			UiRect(38, 26)
			UiColor(1, 1, 1)
			if UiTextButton("Add") then
				handler.addScript(config.input)
			end
		UiPop()
	UiPop()
	
	-- script list
	UiPush()
		-- data
		local windowWidth = 200
		local windowHeight = 70
		local spacing = 40

		local maxScriptsPerRow = 5
		local scriptAmount = tables.countDictKeys(storage.scripts)
		
		local rowWidth = (((windowWidth + spacing) * (maxScriptsPerRow - 1)) / 2)

		-- setup
		UiTranslate(-rowWidth, 330)

		-- draw
		local scriptGroups = tables.separateTable(storage.scripts)

		for _, scriptGroup in ipairs(scriptGroups) do
			UiPush()
				for _, script in ipairs(scriptGroup) do
					UiPush()
						-- draw window
						UiColor(1, 1, 0)
						UiRect(windowWidth, windowHeight)
						
						UiColor(.05, .05, .05)
						UiRect((windowWidth - 2), (windowHeight - 2))
						
						-- title
						UiPush()
							UiFont("bold.ttf", 20)
							UiColor(1, 1, 1)
							UiTranslate(0, -((windowHeight / 2) - 18))
							UiText(script.name)
						UiPop()
						
						-- remove button
						UiPush()
							UiTranslate(-40, 14)
							UiColor(0, 0, 0)
							UiRect(70, 28)
							UiColor(.1, .1, .1)
							UiRect(68, 26)
							UiColor(1, 1, 1)
							if UiTextButton("Remove") then
								handler.removeScript(script.name)
							end
						UiPop()
						
						-- reload button
						UiPush()
							UiTranslate(40, 14)
							UiColor(0, 0, 0)
							UiRect(70, 28)
							UiColor(.1, .1, .1)
							UiRect(68, 26)
							UiColor(1, 1, 1)
							if UiTextButton("Reload") then
								handler.reloadScript(script.name)
							end
						UiPop()
					UiPop()

					-- move cursor
					UiTranslate(windowWidth + spacing, 0)
				end
			UiPop()

			-- move to next row
			UiTranslate(0, 100)
		end
	UiPop()
end
