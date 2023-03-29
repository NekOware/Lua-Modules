
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
local test_file_name = test_file_path:match('[^/]+$')

local uu = require'uuencoding'

-- Simple encoding test.
do
  local correct = false

  local ok,err = pcall(function()
    local input = "Hello, World!"
    local expected = "-2&5L;&\\L(%=O<FQD(0``\n`"
    local got = uu.enc(input)
    correct = (got == expected)
  end)

  check(not ok and'ERROR'or correct, "Encode a string correctly")
end

-- Simple decoding test.
do
  local correct = false

  local ok,err = pcall(function()
    local input = "-2&5L;&\\L(%=O<FQD(0``\n`"
    local expected = "Hello, World!"
    local got = uu.dec(input)
    correct = (got == expected)
  end)

  check(not ok and'ERROR'or correct, "Decode a string correctly")
end

-- Encode and Decode without loss.
do
  local correct = false

  local ok,err = pcall(function()
    local input = "The quick brown fox jumps over the lazy dog."
    local encoded = uu.enc(input)
    local decoded = uu.dec(encoded)
    correct = (input == decoded)
  end)

  check(not ok and'ERROR'or correct, "Encode and decode a string without loss")
end

-- Encode a file correctly.
do
  local correct = false

  local ok,err = pcall(function()
    local file = test_file_path
    local perm = "644"
    local encoded = uu.encFile(file, perm)

    local file_name = test_file_name
    local file_data = read_file(file)
    local file_data_enc = uu.enc(file_data)
    local expected = string.format(
      'begin %s %s\n%s\nend', perm, file_name, file_data_enc
    )
    correct = (encoded == expected)
  end)

  check(not ok and'ERROR'or correct, "Encode a file correctly")
end

-- Decode a file correctly.
do
  local correct = false

  local ok,err = pcall(function()
    local count, decoded = uu.decFile(
      'begin 644 _test_file.txt\n'..
      'M2&5L;&\\L(%=O<FQD(0T*5&AE(\'%U:6-K(&)R;W=N(&9O>"!J=6UP<R!O=F5R\n'..
      '7(\'1H92!L87IY(&1O9RX-"DAI(&UO;2$`\n'..
      '`\n'..
      'end'
    )
    local expected_count= 1
    local expected_name = "_test_file.txt"
    local expected_perm = "644"
    local expected_data = "Hello, World!\r\nThe quick brown fox jumps over the lazy dog.\r\nHi mom!"
    if count == expected_count then
      if -- I hate this too, but i did it for readability.
        decoded[1].name == expected_name and
        decoded[1].perm == expected_perm and
        decoded[1].data == expected_data
      then
        correct = true
      end
    end
  end)

  check(not ok and'ERROR'or correct, "Decode a file correctly")
end

-- Encode and Decode a file without loss.
do
  local correct = false

  local ok,err = pcall(function()
    local file = test_file_path
    local perm = "644"

    local encoded = uu.encFile(file, perm)
    local count, decoded = uu.decFile(encoded)

    local expected_count= 1
    local expected_name = test_file_name
    local expected_perm = "644"
    local expected_data = read_file(file)
    if count == expected_count then
      if -- I hate this too, but i did it for readability.
        decoded[1].name == expected_name and
        decoded[1].perm == expected_perm and
        decoded[1].data == expected_data
      then
        correct = true
      end
    end
  end)

  check(not ok and'ERROR'or correct, "Encode and decode a file without loss")
end

print_results('UUEncoding.lua')
