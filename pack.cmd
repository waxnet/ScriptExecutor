@echo off

mkdir "%userprofile%/Documents/ScriptExecutor/mods/ScriptExecutor"
xcopy /c /y /e . "%userprofile%/Documents/Teardown/mods/ScriptExecutor"

cd "%userprofile%/Documents/Teardown/mods/ScriptExecutor"
rmdir /s /q .github
rmdir /s /q media
del steam_description.txt
del publish.cmd
del preview.jpg
del README.md
del pack.cmd
del LICENSE
del id.txt
