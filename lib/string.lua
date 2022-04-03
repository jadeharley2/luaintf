function string.left( str, num ) return string.sub( str, 1, num ) end
function string.right( str, num ) return string.sub( str, -num ) end

function string.replace( str, tofind, toreplace )
	local tbl = string.split( str, tofind )
	if ( tbl[ 1 ] ) then return table.concat( tbl, toreplace ) end
	return str
end

--[[---------------------------------------------------------
	Name: Trim( s )
	Desc: Removes leading and trailing spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.trim( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
	Name: TrimRight( s )
	Desc: Removes trailing spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.trimright( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
	Name: TrimLeft( s )
	Desc: Removes leading spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.trimleft( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^" .. char .. "*(.+)$" ) or s
end

local sub = string.sub
function string.split(s, char)
	local result = {}
	local lastpos = 1
	local slen = #s
	for k=1,slen do 
		local c = sub(s,k,k)
		if c == char then
			result[#result+1] = sub(s,lastpos,k-1) 
			lastpos = k+1
		end 
	end
	result[#result+1] = sub(s,lastpos,slen) 
	return result
end
function string.wmatch(s, variants)
	local parts = string.split(variants,'|')
	if #parts == 1 then
		return string.match(s,variants)
	else
		local words = string.split(s,' ')

		for k,v in pairs(parts) do
			for k2,v2 in pairs(words) do
				if v==v2 then return true end
			end
			--if string.match(s,v) then return true end
		end
	end
	return false
end

local split_characters = {
    [' '] = true,
    ['?'] = '?',
    ['!'] = '!',
    [','] = ',',
    ['.'] = '.',
}
function string.getwords(s) 
	local result = {}
	local lastpos = 1
	local slen = #s
	for k=1,slen do 
		local c = sub(s,k,k)
        local rx = split_characters[c]
		if rx then
			local x = sub(s,lastpos,k-1) 
			if #x>0 then
				result[#result+1] = x
			end
			lastpos = k+1
            if rx~=true then
                result[#result+1] = rx
            end
		end 
	end
	local x = sub(s,lastpos,slen)  
	if #x>0 then
		result[#result+1] = x
	end 
	return result
end

function string.find_anycase(s,sub)
	return string.find( string.lower(s), string.lower(sub) ) and true or false
end

function string.isupper(s)
	return string.match(s, "%u")
end
function string.islower(s)
	return not string.match(s, "%u")
end

function string.starts_with(str, start) 
	return start == "" or str:sub(1, #start) == start
end
function string.ends_with(str, ending) 
	return ending == "" or str:sub(-#ending) == ending
end


function string.starts_with_any(str,...)
	for k,v in pairs({...}) do
		if v == "" or str:sub(1, #v) == v then
			return true
		end
	end
	return false 
end
 
function string.ends_with_any(str,...)
	for k,v in pairs({...}) do
		if v == "" or str:sub(1, -#v) == v then
			return true
		end
	end
	return false
end

-- Returns the Levenshtein distance between the two given strings
function string.levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0
	
        -- quick cut-offs to save time
	if (len1 == 0) then
		return len2
	elseif (len2 == 0) then
		return len1
	elseif (str1 == str2) then
		return 0
	end
	
        -- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end
	
        -- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if (str1:byte(i) == str2:byte(j)) then
				cost = 0
			else
				cost = 1
			end
			
			matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
		end
	end
	
        -- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end