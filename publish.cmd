@echo off

mkdir "%userprofile%/Documents/ScriptExecutor/mods/ScriptExecutor"
xcopy /c /y /e . "%userprofile%/Documents/Teardown/mods/ScriptExecutor"

cd "%userprofile%/Documents/Teardown/mods/ScriptExecutor"
rmdir /s /q .github
rmdir /s /q media
rmdir /s /q utils
rmdir /s /q core
rmdir /s /q data
del publish.cmd
del README.md
del main.lua
del pack.cmd
del LICENSE

echo function draw() UiAlign("center middle") UiTranslate(UiWidth()/2, UiHeight()/2) UiFont("bold.ttf", 30) UiText("Script Executor needs to be installed from the GitHub page.") end > main.lua
