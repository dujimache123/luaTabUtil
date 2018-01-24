@echo excelToLua:1  luaToExcel:2?
@echo off
set /p arg= 
if "%arg%"== "1" call lua.exe ExcelToLua.lua
if "%arg%"== "2" call lua.exe LuaToExcel.lua

pause