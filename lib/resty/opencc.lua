
local ffi = require("ffi")
local ffi_new = ffi.new
local ffi_str = ffi.string
local setmetatable = setmetatable
local error = error


local _M = { _VERSION = '0.01' }

local mt = { __index = _M }


local opencc = ffi.load("opencc")

ffi.cdef[[
typedef void* opencc_t;

opencc_t opencc_open(const char* configFileName);
int opencc_close(opencc_t opencc);
char* opencc_convert_utf8(opencc_t opencc, const char* input, size_t length);
void opencc_convert_utf8_free(char* str);

size_t strlen(const char *s);
]]


function _M.new(self, config)
  local o = opencc.opencc_open(config)
  return setmetatable({ _opencc_t = o }, mt)
end


function _M.convert(self, input)
  -- local buf = ffi_new("char[?]", #input * 2)
  local output = opencc.opencc_convert_utf8(self._opencc_t, input, #input)
  local output_length = ffi.C.strlen(output)
  local output_str = ffi_str(output, output_length)
  opencc.opencc_convert_utf8_free(output)
  return output_str
end


function _M.close(self)
  opencc.opencc_close(self._opencc_t)
end


return _M
