local tsort = table.sort
local tinsert = table.insert
local srep = string.rep

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
table.HasValue = table.contains

local function isnumber(x)
    return type(x)=='number'
end

function stdcomp(a,b) 
	if isnumber(a) and isnumber(b) then
		return a<b
	else
		return tostring(a)<tostring(b) 
	end 
end
function SortedPairs (t, f)
    f = f or stdcomp
	local a = {}
	for n in pairs(t) do tinsert(a, n) end
	tsort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
	i = i + 1
	if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end
function AscendingPairs (t, f) 
	return SortedPairs(t,function(a,b) return f(a) < f(b) end)
end
function DescendingPairs (t, f) 
	return SortedPairs(t,function(a,b) return f(a) > f(b) end)
end
local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
function reversedipairs(t)
    return reversedipairsiter, t, #t + 1
end

function TableToString (tbl, indent, maxlevel)
	if tbl then
		if not indent then indent = 0 end
		if not maxlevel then maxlevel = 2 end
		if indent > maxlevel then return end
		local st = ""
		for k, v in SortedPairs(tbl,stdcomp) do
			formatting = srep("  ", indent) ..  tostring(k) .. ": "
			if type(v) == "table" then
				if v ~= tbl then
					st = st .. formatting .. "\r\n"
					st = st .. (TableToString(v, indent+1,maxlevel) or "")
				else
					st = st .. formatting .. tostring(v) .. "\r\n"
				end
			else
				st = st .. formatting .. tostring(v) .. "\r\n"
			end
		end
		return st
	else
		return "nil"
	end
end

function PrintTable(tbl, maxlevel)
	print(TableToString(tbl,0,maxlevel))
end




local tc = table.concat
function table.concat(t,sep)
    local ts ={}
    for k,v in pairs(t) do
        ts[k] = tostring(t[k])
    end
    return tc(ts,sep)
end

function table.keys_to_values(t)
    local n = {}
    for k,v in pairs(t) do
        n[#n+1] = k
    end
    return n
end

function table.set(t)
    local r = {}
    for k,v in pairs(t) do
        r[v] = true
    end
    return r
end

function table.print(t,level,hash) 
    level = level or 0
    for k,v in sortedpairs(t) do

    end

end