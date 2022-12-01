local function stack_trace(e)
   local msg = 'stack trace'
   if e then
      msg = msg .. ' (' .. e .. ')'
   end
   print(msg)
end

local function printable(e)
   for i,e in pairs(e) do
      print(tostring(i) .. ":",e)
   end
end

return {stack = stack_trace,
printable = printable}
