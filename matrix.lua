-- Matrix library for any type of value. 
-- Mantainer: Achengli Yassin <sadlowsay@ichigo.me>
-- License: BSD

local stack = require'./debug'.stack
local printable = require'./debug'.printable

local config = require'matrixconf'

local VALUE_SEPARATOR = config.VALUE_SEPARATOR
local ROW_FORMAT = config.ROW_FORMAT

local matrix = {}

matrix.VERSION = '0.0.1'
matrix.DESCRIPTION = 'Matrix library.'
matrix.LICENSE = 'BSD'

local matrix_meta = require'matrix_meta'


local function check_data(data)
   local rows,columns = 0,0

   if #data > 0 then rows = #data
   else return 0,0 end

   for i,e in pairs(data) do
      if type(i) ~= 'number' then return false end
      if i == 1 then columns = #e
      else
	 if #e ~= columns then return false end
      end
   end
   return rows,columns
end

function matrix:elem(i,j)
   if not i then
      -- calling column
      if j  then
	 if type(j) == 'number' and j < self.size[2] then
	    local ret = {}
	    for i,e in ipairs(self.data) do
	       if i == j then table.insert(ret,e) end
	    end
	    return ret
	 end
      end
   elseif type(i) == 'number' then
      -- calling position (can be row)
      if j then
	 if type(j) == 'number' then return self.data[i][j]
	 else return nil end
      else return self.data[i] end
   else return nil end
end

function table.copy(t)
   local ret = {}
   for i,e in pairs(t) do
      if type(e) ~= 'table' then ret[i] = e else
	 ret[i] = table.copy(e) end
   end
   return ret
end

function matrix:new(o,j)
   local ret_value = {size={0,0},data = {}}
   
   if type(o) == 'number' then
      local key_value = table.pack(o,j)
      if #key_value == 2 then
	 assert(type(key_value[1]) == type(key_value[2]))
	 ret_value.size = {key_value[1],key_value[2]}
      end
   elseif type(o) == 'table' then
      o = table.copy(o)
      if o.data then
	 local r,c = check_data(o.data)
	 if r then
	    ret_value.data = table.copy(o.data)
	    ret_value.size = {r,c}
	 end end
   end
   setmetatable(ret_value,matrix_meta)
   return ret_value
end

-- call performs
function matrix:matrix(o,j) return matrix:new(o,j) end
function matrix:create(o,j) return matrix:new(o,j) end
function matrix_meta.__add(a,b) return matrix:new(matrix_meta.add(a,b)) end
function matrix_meta.__sub(a,b) return matrix:new(matrix_meta.sub(a,b)) end
function matrix_meta.__mul(a,b) return matrix:new(matrix_meta.mul(a,b)) end
function matrix_meta.__mod(a,b) return matrix:new(matrix_meta.mod(a,b)) end
function matrix_meta.__pow(a,b) return matrix:new(matrix_meta.pow(a,b)) end
function matrix_meta.__band(a,b) return matrix:new(matrix_meta.band(a,b)) end
function matrix_meta.__bor(a,b) return matrix:new(matrix_meta.bor(a,b)) end
function matrix_meta.__bxor(a,b) return matrix:new(matrix_meta.bxor(a,b)) end
function matrix_meta.__bnot(a) return matrix:new(matrix_meta.bnot(a)) end
function matrix_meta.__unm(a) return matrix:new(matrix_meta.unm(a)) end

matrix_meta.__len = matrix_meta.len
matrix_meta.__eq = matrix_meta.eq

return matrix 
