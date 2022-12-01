local config = require'matrixconf'

local VALUE_SEPARATOR = config.VALUE_SEPARATOR
local ROW_FORMAT = config.ROW_FORMAT

local matrix_meta = {}

function matrix_meta.__tostring(o)
   local buff = ( (ROW_FORMAT == '(') and
      ('matrix[' .. tostring(o.size[1]) .. ','
       .. tostring(o.size[2]) .. '] (')
       or '')
   for i,e in ipairs(o.data) do
      for j,k in ipairs(e) do
	 buff = buff .. tostring(k)
	 if j ~= o.size[2] then
	    buff = buff .. VALUE_SEPARATOR
	 end
      end
      buff = buff .. ((ROW_FORMAT == '(') and '),(' or
		      '\n')
   end
   return string.sub(buff,0, (ROW_FORMAT == '(') and
		     #buff - 2 or #buff - 1)
end

function matrix_meta.__index(obj,key)
   if type(key) == 'number' then
      return obj.data[key]
   elseif type(key) == 'string' then
      return obj[key]
      --[[ There must be a way to return only 
	 a column. ]]
   elseif type(key) == 'table' then
      if #key == 2 then
	 return obj.data[key[1]][key[2]]
      else
	 return obj.data[key[1]]
      end
   else
      return nil
   end
end

function matrix_meta.__newindex(obj,key,value)
   if type(key) == 'number' or type(key) == 'table' then
      local key_table = (type(key) == 'table') and
	 key or {key}
      
      if #key_table == 1 then
	 if key_table[1] > obj.size[1] and
	    type(value) == 'table'then
	    if #value == obj.size[2] then
	       table.insert(obj.data,value)
	    end
	 else
	    if type(value) == 'table' and
	       #value == obj.size[2]  then
	       obj.data[key_table[1]] = value
	    end
	 end
      elseif #key_table == 2 then
	 if key_table[1] <= obj.size[1] and
	    key_table[2] <= obj.size[2] and
	    type(value) == type(obj.data[key_table[1]]
				[key_table[2]]) then
	    obj.data[key_table[1]][key_table[2]] =
	       value
	    return obj
	 else
	    return nil
	 end
      else
	 return nil
      end      
   elseif type(key) == 'string' then
      obj[key] = value
      return obj
   else
      return nil
   end
   return value
end

local function fill(r,c,value)
   local ret = {}
   for i = 1,r do
      local row = {}
      for j = 1,c do
	 table.insert(row, value or 0)
      end
      table.insert(ret,row)
   end
   return ret
end

function matrix_meta.__add(a,b)
   assert(a.size[1] == b.size[1] and a.size[2] == a.size[2])
   local other_matrix = {size = {a.size[1],b.size[2]},
			 data = fill(a.size[1],b.size[2])}
   for i = 1,a.size[1] do
      for j = 1,b.size[2] do
	 other_matrix.data[i][j] = a.data[i][j] + b[i][j]
      end
   end
   return other_matrix
end

function matrix_meta.__sub(a,b)
   assert(a.size[1] == b.size[1] and a.size[2] == b.size[2])
   local other_matrix = matrix:new(a.size[1],a.size[2])
   for i = 1,a.size[1] do
      for j = 1,a.size[2] do
	 other_matrix.data[i][j] = a:elem(i,j) -
	    b:elem(i,j)
      end
   end
   return other_matrix
end

return matrix_meta
