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

ȥ�������ַ���ͷ���Ŀհ��ַ������ؽ��

~~~ lua

local input = "  ABC"
print(string.ltrim(input))
-- ��� ABC�������ַ���ǰ��������ո�ȥ����

~~~

�հ��ַ�������

-   �ո�
-   �Ʊ�� \t
-   ���з� \n
-   �ص����׷� \r

@param string input �����ַ���

@return string ���

@see string.rtrim, string.trim

]]
function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

--[[--

ȥ�������ַ���β���Ŀհ��ַ������ؽ��

~~~ lua

local input = "ABC  "
print(string.ltrim(input))
-- ��� ABC�������ַ������������ո�ȥ����

~~~

@param string input �����ַ���

@return string ���

@see string.ltrim, string.trim

]]
function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

--[[--

ȥ���ַ�����β�Ŀհ��ַ������ؽ��

@param string input �����ַ���

@return string ���

@see string.ltrim, string.rtrim

]]
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

return Util