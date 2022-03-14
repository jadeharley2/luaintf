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