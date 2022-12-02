local matrix = require'matrix'

local test_passed = 0
local test_failed = 0
local separator = '-'

local function compare_matrix(m1,m2)
   assert(m1.data and m2.data)
   assert(m1.size and m2.size)
   for i = 1,m1.size[1] do
      for j = 1,m1.size[2] do
	 if m1.data[i][j] ~= m2.data[i][j] then
	    return false
	 end
      end
   end
   return true
end

local function  eval_test(test_result, index, msg)
   if test_result then
      test_passed = test_passed + 1
      print ("Test " .. tostring(index) .. " Ok")
   else
      test_failed = test_failed + 1
      print ("Test " .. tostring(index) .. " Failed")
      print(msg)
   end
   print(string.rep('-',17))
end

local function create_test(...)
   local test = {}

   if type(...) ~= 'table' then
      test = table.pack(...)
   end

   assert(#test == 5)
   
   test.name = test[1] or 'undefined'
   test.input = test[2] or {}
   test.result = test[3] or {}
   test.msg = test[4] or {}
   test.func = test[5] or function (e)
      print("This test is void with argument " .. tostring(e))
   end
   return {
      name = test.name, input = test.input,
      result = test.result, msg = test.msg, message = test.msg,
      func = test.func}
end

local test_vector = {
   create_test('matrix tostring metamethod', {data = {{1,2,3},{4,5,6},{7,8,9}}},
	       "matrix[3,3] (1,2,3),(4,5,6),(7,8,9)",
	       "__tostring test has errors",
	       function (test_value, idx)
		  print("Test " .. tostring(idx) .. ":",
			test_value.name)
		  local m = matrix:new(test_value.input)
		  print("result:\t\t" .. tostring(m))
		  print("expected:\t" .. test_value.result)
		  eval_test(tostring(m) == test_value.result,idx,
			    test_value.msg)		  
   end),
   create_test('matrix consturctor', {2,2}, {2,2},
	       "matrix constructor with two arguments not working well",
	       function (test_value,idx)
		  print("Test " ..tostring(idx) .. ':', test_value.name)
		  local m = matrix:new(test_value.input[1],
				       test_value.input[2])
		  local size = m.size
		  print("result:\t\t" .. size[1] .. '\t' .. size[2])
		  print("expected:\t" .. test_value.result[1] ..'\t'
			.. test_value.result[2])
		  eval_test(#size == #test_value.result and
			    size[1] == test_value.result[1] and
			    size[2] == test_value.result[2],
			    idx,test_value.msg)
   end),
   create_test('matrix addition', {{data = {{1,2},{2,3}}},
		  {data = {{3,3},{-1,0}}}},
	       {data = {{4,5},{1,3}}},"Matrix addition error.",
	       function (test_value,idx)
		  local m1 = matrix:create(test_value.input[1])
		  local m2 = matrix:create(test_value.input[2])
		  local m3 = m1 + m2
		  local m4 = matrix:create(test_value.result)
		  print("result: ")
		  print(m3)
		  print("expected: ")
		  print(m4)
		  eval_test(compare_matrix(m3,m4),idx, test_value.msg)
   end),
   create_test('matrix product', {{data = {{1,2},{4,-2}}},
		  {data = {{3,4},{-1,1}}}},{data = {{1,6},{14,14}}},
	       'Matrix product error.',
	       function (test_value,idx)
		  local m1 = matrix:create(test_value.input[1])
		  local m2 = matrix:create(test_value.input[2])
		  local m3 = m1 * m2
		  local m4 = matrix:create(test_value.result)
		  print("result: ")
		  print(m3)
		  print("expected: ")
		  print(m4)
		  eval_test(compare_matrix(m3,m4),idx, test_value.msg)
   end),
   create_test('matrix pow', {{data = {{1,2},{4,-2}}},
		  {data = {{3,4},{-1,1}}}},{data = {{1,16},{.25,-2}}},
	       'Matrix exponentiation error.',
	       function (test_value,idx)
		  local m1 = matrix:create(test_value.input[1])
		  local m2 = matrix:create(test_value.input[2])
		  local m3 = m1 ^ m2
		  local m4 = matrix:create(test_value.result)
		  print("result: ")
		  print(m3)
		  print("expected: ")
		  print(m4)
		  eval_test(compare_matrix(m3,m4),idx, test_value.msg)
end)}

for idx,elem in pairs(test_vector) do
   elem.func(elem,idx)
end

print("Tests passed:", test_passed)
print("Test failed:", test_failed)
