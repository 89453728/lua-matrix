local matrix = require'matrix'

local a = matrix:new({data = {{1,2},{6,5}}})
local b = matrix:new(a)

print(a)
print('')
print(b)

b[{1,2}] = 11
print(string.rep('--',15))
print(a)
print''      
print(b)
