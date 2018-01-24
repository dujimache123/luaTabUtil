local Util = require("Util")

function getOneFieldStr(fieldName, fieldType, fieldStr)
	local result = ""
	result = "\t\t\t" .. result
	
	if fieldType == "int" or fieldType == "float" or fieldType == "boolean"  then
		result = result .. fieldName .. " = " .. fieldStr .. ",\n"
	elseif fieldType == "string" then
		result = result .. fieldName .. " = \"" .. fieldStr .. "\",\n" 
	elseif fieldType == "ccp" then
		local valueStrs = string.split(fieldStr, ",")
		if #valueStrs == 2 then
			result = result .. fieldName .. " = {x = " .. valueStrs[1] .. ", y = " .. valueStrs[2] .. "},\n" 
		end
	elseif string.find(fieldType, "array") ~= nil then
		local valueStrs = string.split(fieldStr, ";")
		result = result .. fieldName .. " = {\n"
		for i, vStr in ipairs(valueStrs) do
			if string.len(vStr) > 0 then
				result = result .. "\t\t\t\t[" .. i .. "] = " .. vStr .. ",\n" 
			end
		end
		result = result .. "\t\t\t},\n"
	end

	return result
end

--excel������lua�ļ�
function excelToLua()
	print("\nExcel�ļ�ת����Lua�ļ�-----------------------------------")
	local excelDir = "./excelFiles"
	local excelFiles = Util:getFilesOfDir(excelDir)
	local luaDir = "./outPut"
	for i, file in pairs(excelFiles) do
		local fileHandle = io.open(excelDir .. "/" .. file)
		if not fileHandle then
			print("���ļ�" .. file .."��������!")
		else
			local content = string.split(fileHandle:read("*a"), "\n")
			fileHandle:close()
			local fieldNames = nil
			local fieldTypes = nil
			if content[2] and content[3] then
				fieldNames = string.split(content[2], "\t")
				fieldTypes = string.split(content[3], "\t")
			end
			if not fieldNames or not fieldTypes then
				print(file .. "�ļ�δ�����ֶλ��ֶ�����!")
			elseif #fieldNames ~= #fieldTypes then
				print(file .. "�ļ��ֶ�����������������һ��!")
			else
				print(file)
				local fileName = string.sub(file, 1, -5)
				local depth = 1
				local index = 1
				local resultStr = "local " .. fileName .. " = " .. " {\n"
				resultStr = resultStr .. "\t" .. "records = {\n"
				for j = 4, #content do
					local oneLine = content[j]
					if string.len(oneLine) > 0 then
						resultStr = resultStr .. "\t\t[" .. index .. "] = {\n"
						local fieldStrs = string.split(oneLine, "\t")
						for k = 1, #fieldNames do
							local fieldName = fieldNames[k]
							local fieldType = fieldTypes[k]
							local fieldStr = fieldStrs[k]
							if string.len(fieldStr) > 0 then
								resultStr = resultStr .. getOneFieldStr(fieldName, fieldType, fieldStr)
							end
						end
						resultStr = resultStr .. "\t\t},\n"
					end
					index = index + 1
				end
				resultStr = resultStr .. "\t}\n}"
				resultStr = resultStr .. "\nreturn " .. fileName
				local luaFilePath = "./outPut/" .. fileName .. ".lua"
				local luaFile = io.open(luaFilePath, "w+")
				luaFile:write(resultStr)
				luaFile:close()
			end
			
		end
	end
end

excelToLua()