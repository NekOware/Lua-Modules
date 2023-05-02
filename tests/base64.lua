
--// Utilities

local tests = {}

local function check(bool, name)
  local result = (type(bool)=='string'and bool)or not bool and "FAIL" or "OK"
  table.insert(tests, name .. ": " .. result)
end

local function print_results(name)
  print('Test results for ' .. name)
  for i,v in pairs(tests)do
    print(string.format('  %2i - %s', i, v))
  end
end

local function read_file(path)
  local file, error_msg, error_code = io.open(path, 'rb')
  if not file then
    return false, error_msg, error_code
  else
    local data = file:read('*a')
    file:close()
    return data
  end
end

--// The tests

local test_file_path = "../_test_file.txt"

local b64 = require'base64'

-- Simple encoding test.
do
  local correct = false
  
  local ok,err = pcall(function()
    local input = "Hello, World!"
    local expected = "SGVsbG8sIFdvcmxkIQ=="
    local got = b64.enc(input)
    correct = (got == expected)
  end)
  
  check(not ok and'ERROR'or correct, "Encode a string correctly")
end

-- Simple decoding test.
do
  local correct = false

  local ok,err = pcall(function()
    local input = "SGVsbG8sIFdvcmxkIQ=="
    local expected = "Hello, World!"
    local got = uu.dec(input)
    correct = (got == expected)
  end)

  check(not ok and'ERROR'or correct, "Decode a string correctly")
end

-- Decode strict mode error test.
do
  local correct = false

  local ok,err = pcall(function()
    local input = "SGkgbW9tIQ==\n#"
    local got = uu.dec(input)
  end)

  local expected = "[Base64.decode]: (Strict) Invalid character at position"

  if not ok and err then
    if type(err) == 'string' then
      correct = (err:sub(1, 55) == expected)
    end
  end

  check(correct, "Decode strict mode error test")
end


print_results('Base64.lua')
