local Util = require("Util")

function getInt(v)
    if v then
        return tostring(v) .. "\t"
    else
        return "\t"
    end
end

function getFloat(v)
    if v then
        return tostring(v) .. "\t"
    else
        return "\t"
    end
end

function getString(v)
    if v then
        local index = string.find(v, "\n")
        if index then
            v = string.gsub(v, "\n", "\\n")
        end
        return tostring(v) .. "\t"
    else
        return "\t"
    end
end

function getBoolean(v)
	if v == true then
		return "true"
	elseif v == false then
		return "false"
	else
		return "\t"
	end
end

function getCpp(v)
    if v then
        return v.x .. "," .. v.y .. "\t"
    else
        return "\t"
    end
end

function getArray(v, delimiter)
    if v then
        local str = ""
        for i, value in pairs(v) do
            str = str ..value .. delimiter
        end
        str = str .. "\t"
        return str
    else
        return "\t"
    end
end

function luaToExcel()
	local luaDir = "./luaFiles"
	local luaFiles = Util:getFilesOfDir(luaDir)

	local defDir = "./def"
	local defFiles = Util:getFilesOfDir(defDir)

	if #luaFiles ~= #defFiles then
		print("Lua文件数量:", #luaFiles, "描述文件数量:", #defFiles)
		print("lua 文件与描述文件数量不一致!")
		return
	end

	for i = 1, #luaFiles do
		local fileName = string.sub(luaFiles[i], 1, -5)
		local luaTable = require("luaFiles." .. fileName)
		local defFile = io.open("./def/" .. fileName .. "Def" .. ".txt", "r")
		if not defFile then
			print("找不到字段字义文件",fileName)
			return
		end
		local content = string.split(defFile:read("*a"), "\n")
		local fieldNames = string.split(content[1], ",")
		local fieldTypes = string.split(content[2], ",")

		if #fieldNames ~= #fieldTypes then
			print("字段名称与字段类型数量不一致",fileName)
			return
		end
		
		local destFile = io.open("./output/" .. fileName .. ".tab", "w")
		local str = "\n"
		for j, fieldName in pairs(fieldNames) do
			str = str .. fieldName .. "\t"
		end
		str = str .. "\n"
		
		for j, fieldType in pairs(fieldTypes) do
			str = str .. fieldType .. "\t"
		end
		str = str .. "\n"

		local records = luaTable.records
		for i, record in ipairs(records) do
			for j, fieldType in pairs(fieldTypes) do
				local fieldName = fieldNames[j]
				if fieldType == "int" then
					str = str .. getInt(record[fieldName])
				elseif fieldType == "float" then
					str = str .. getFloat(record[fieldName])
				elseif fieldType == "string" then
					str = str .. getString(record[fieldName])
				elseif fieldType == "boolean" then
					str = str .. getBoolean(record[fieldName])
				elseif string.find(fieldType, "array") ~= nil then
					local parts = string.split(fieldType, "+")
					str = str .. getArray(record[fieldName], parts[3])
				elseif string.find(fieldType, "ccp") ~= nil then
					str = str .. getCpp(record[fieldName])
				end
			end
			str = str .. "\n"
		end
		
	--    local bytes ={}
	--    for i=1,string.len(str) do
	--        local byte = string.byte(string.sub(str,i,i))
	--        table.insert(bytes,byte)
	--        if i == 1 or i == 2 then
	--            print(byte)
	--        end
	--    end
	--    table.insert(bytes, 1, 187)
	--    table.insert(bytes, 1, 239)
	--    print(bytes[1],bytes[2])

	--    str = ""
	--    for i = 1, #bytes do
	--        str = str .. string.char(bytes[i])
	--    end
		destFile:write(str)
		destFile:flush()
		io.close(destFile)
	end
end

luaToExcel()