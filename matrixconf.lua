-- Configuration file for matrix library

local ROW_FORMAT = '(' --[[ '(' (each row between 
   brackets]]
local VALUE_SEPARATOR = '\t' --[[ ' ' (you can use 
   space also]]

VALUE_SEPARATOR = ((ROW_FORMAT == '\n') and VALUE_SEPARATOR
   or ',')
local CONCURRENT = false

return {
   VALUE_SEPARATOR = VALUE_SEPARATOR,
   ROW_FORMAT = ROW_FORMAT,
   CONCURRENT = CONCURRENT}
