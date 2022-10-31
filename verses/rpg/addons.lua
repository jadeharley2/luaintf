
 
local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
  end
  
-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
local function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do 
        lines[#lines + 1] = line
    end
    return lines
end
 
if file_exists("addons/loadorder.txt") then  
    for k,line in ipairs(lines_from("addons/loadorder.txt")) do 
        local p = 'addons/'..line..'/init.lua'
        print('Addon ',line,p)
        dofile(p)
    end 
end
 