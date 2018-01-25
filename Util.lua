local lfs = require("lfs")
local Util = {}
function Util:getFilesOfDir(dirPath, files)
	local len = string.len(dirPath)
	if string.sub(dirPath, -1) == "/" or string.sub(dirPath, -1) == "\\" then
		dirPath = string.sub(dirPath, 0, len - 1)
	end

    local files = files or {}
	for entry in lfs.dir(dirPath) do
	    if entry ~= '.' and entry ~= '..' then
	        local path = dirPath .. '/' .. entry
	        local attr = lfs.attributes(path)
	        --print(entry)
	        if attr.mode == 'directory' then
	            self:getFilesOfDir(path, files)
	        else
	            table.insert(files, entry)
	        end
	    end
	end

    return files
end

function string.split(input, delimiter)
	input = tostring(input)

	delimiter = tostring(delimiter)
	if (delimiter=='') then
		return false 
	end
	local pos,arr = 0, {}
	-- for each divider found

	for st,sp in function() return string.find(input, delimiter, pos, true) end do

		table.insert(arr, string.sub(input, pos, st - 1))

		pos = sp + 1

	end
	table.insert(arr, string.sub(input, pos))
	return arr
end

--[[--

去除输入字符串头部的空白字符，返回结果

~~~ lua

local input = "  ABC"
print(string.ltrim(input))
-- 输出 ABC，输入字符串前面的两个空格被去掉了

~~~

空白字符包括：

-   空格
-   制表符 \t
-   换行符 \n
-   回到行首符 \r

@param string input 输入字符串

@return string 结果

@see string.rtrim, string.trim

]]
function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

--[[--

去除输入字符串尾部的空白字符，返回结果

~~~ lua

local input = "ABC  "
print(string.ltrim(input))
-- 输出 ABC，输入字符串最后的两个空格被去掉了

~~~

@param string input 输入字符串

@return string 结果

@see string.ltrim, string.trim

]]
function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

--[[--

去掉字符串首尾的空白字符，返回结果

@param string input 输入字符串

@return string 结果

@see string.ltrim, string.rtrim

]]
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

return Util